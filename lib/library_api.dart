import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'catalog.dart';
import 'gita_api.dart';
import 'models.dart';

class DliCategory {
  final String id;
  final String label;
  final String query;
  final IconData icon;

  const DliCategory({
    required this.id,
    required this.label,
    required this.query,
    required this.icon,
  });
}

const dliCategories = <DliCategory>[
  DliCategory(
    id: 'all',
    label: 'All Sacred Works',
    query: 'collection:digitallibraryindia AND mediatype:texts',
    icon: Icons.all_inclusive,
  ),
  DliCategory(
    id: 'vedas',
    label: 'Vedas & Samhitas',
    query: 'collection:digitallibraryindia AND mediatype:texts AND (Veda OR Vedic OR Samhita OR Brahmana)',
    icon: Icons.auto_stories,
  ),
  DliCategory(
    id: 'upanishads',
    label: 'Upanishads',
    query: 'collection:digitallibraryindia AND mediatype:texts AND (Upanishad OR Upanisad)',
    icon: Icons.self_improvement,
  ),
  DliCategory(
    id: 'gita',
    label: 'Bhagavad Gita',
    query: 'collection:digitallibraryindia AND mediatype:texts AND (Gita OR Geeta)',
    icon: Icons.menu_book,
  ),
  DliCategory(
    id: 'puranas',
    label: 'Puranas & Epics',
    query: 'collection:digitallibraryindia AND mediatype:texts AND (Purana OR Mahabharata OR Ramayana)',
    icon: Icons.temple_hindu,
  ),
  DliCategory(
    id: 'philosophy',
    label: 'Darshana & Philosophy',
    query: 'collection:digitallibraryindia AND mediatype:texts AND (Vedanta OR Darshana OR Sankhya OR Nyaya OR Mimamsa OR Advaita)',
    icon: Icons.psychology,
  ),
  DliCategory(
    id: 'yoga',
    label: 'Yoga & Ayurveda',
    query: 'collection:digitallibraryindia AND mediatype:texts AND (Yoga OR Patanjali OR Ayurveda OR Charaka)',
    icon: Icons.spa,
  ),
  DliCategory(
    id: 'sanskrit',
    label: 'Sanskrit Classics',
    query: 'collection:digitallibraryindia AND mediatype:texts AND (language:san OR Kalidasa OR Kavya OR Nataka)',
    icon: Icons.translate,
  ),
  DliCategory(
    id: 'stotras',
    label: 'Stotras & Devotion',
    query: 'collection:digitallibraryindia AND mediatype:texts AND (Stotra OR Sahasranama OR Bhakti OR Stotram)',
    icon: Icons.favorite,
  ),
];

class LibraryApi {
  static const _timeout = Duration(seconds: 30);

  Future<List<RemoteBook>> fetchDli({
    String? categoryId,
    String? searchQuery,
    int rows = 30,
  }) async {
    String q;
    if (categoryId != null && categoryId != 'all') {
      final match = dliCategories.firstWhere(
        (c) => c.id == categoryId,
        orElse: () => dliCategories.first,
      );
      q = match.query;
    } else {
      q = 'collection:digitallibraryindia AND mediatype:texts';
    }
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final clean = searchQuery.trim().replaceAll('"', '');
      q = '$q AND ($clean)';
    }
    final uri = Uri.parse(
      '$archiveSearchBase?q=${Uri.encodeQueryComponent(q)}&fl[]=identifier&fl[]=title&fl[]=creator&fl[]=year&fl[]=language&rows=$rows&page=1&output=json',
    );
    final body = await _body(uri);
    if (body == null) return [];
    try {
      final decoded = jsonDecode(body);
      final response = decoded is Map ? decoded['response'] : null;
      final docs = response is Map ? response['docs'] : null;
      if (docs is! List) return [];
      final list = <RemoteBook>[];
      for (final item in docs) {
        if (item is! Map) continue;
        final identifier = '${item['identifier'] ?? ''}';
        if (identifier.isEmpty) continue;
        final creator = item['creator'];
        final author = creator is List ? creator.take(2).join(', ') : '${creator ?? ''}';
        final year = item['year'] != null ? '${item['year']}' : '';
        final lang = item['language'] != null ? '${item['language']}' : '';
        var subtitle = author.isNotEmpty ? author : 'Digital Library of India';
        if (year.isNotEmpty) subtitle += ' · $year';
        if (lang.isNotEmpty) subtitle += ' · $lang';

        list.add(
          RemoteBook(
            id: 'ia-$identifier',
            title: _clean('${item['title'] ?? identifier}'),
            author: subtitle,
            source: 'Digital Library of India',
            coverUrl: 'https://archive.org/services/img/$identifier',
            archiveId: identifier,
            kind: 'archive',
          ),
        );
      }
      return list;
    } catch (_) {
      return [];
    }
  }

  Future<List<RemoteBook>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];
    final batches = await Future.wait([
      _gutendex(trimmed),
      _openLibrary(trimmed),
      _archive(trimmed),
    ]);
    final seen = <String>{};
    final books = <RemoteBook>[];
    for (final batch in batches) {
      for (final book in batch) {
        final key = book.title.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
        if (key.isEmpty || !seen.add('$key|${book.source}')) continue;
        books.add(book);
      }
    }
    books.sort((a, b) {
      if (a.canKeep == b.canKeep) return a.title.compareTo(b.title);
      return a.canKeep ? -1 : 1;
    });
    return books;
  }

  Future<({String url, String kind})?> resolveArchive(String identifier) async {
    final body = await _body(Uri.parse('https://archive.org/metadata/$identifier'));
    if (body == null) return null;
    final decoded = jsonDecode(body);
    final files = decoded is Map ? decoded['files'] : null;
    if (files is! List) return null;
    final ranked = <String, String>{};
    for (final item in files) {
      if (item is! Map) continue;
      final name = '${item['name'] ?? ''}';
      final lower = name.toLowerCase();
      if (name.isEmpty || _skipArchiveFile(lower)) continue;
      final kind = _kindFor(lower);
      if (kind == null) continue;
      ranked.putIfAbsent(kind, () => name);
    }
    const order = ['txt', 'html', 'epub', 'pdf'];
    for (final kind in order) {
      final name = ranked[kind];
      if (name == null) continue;
      final encoded = name.split('/').map(Uri.encodeComponent).join('/');
      return (url: 'https://archive.org/download/$identifier/$encoded', kind: kind);
    }
    return null;
  }

  Future<List<RemoteBook>> _gutendex(String query) async {
    final uri = Uri.parse(gutendexBase).replace(queryParameters: {'search': query});
    final body = await _body(uri);
    if (body == null) return [];
    final decoded = jsonDecode(body);
    final results = decoded is Map ? decoded['results'] : null;
    if (results is! List) return [];
    return results.take(12).whereType<Map>().map((item) {
      final formats = item['formats'];
      String? plain;
      String? html;
      String? epub;
      String? cover;
      if (formats is Map) {
        formats.forEach((key, value) {
          final kind = '$key'.toLowerCase();
          final url = '$value';
          if (kind.contains('image/jpeg') && cover == null) cover = url;
          if (kind.startsWith('text/plain') && !kind.contains('utf-16')) plain ??= url;
          if (kind.startsWith('text/html') && !kind.contains('.zip')) html ??= url;
          if (kind.contains('epub')) epub ??= url;
        });
      }
      final download = plain ?? html ?? epub;
      final kind = plain != null
          ? 'txt'
          : html != null
              ? 'html'
              : epub != null
                  ? 'epub'
                  : '';
      final authors = item['authors'];
      final author = authors is List
          ? authors.whereType<Map>().map((person) => '${person['name'] ?? ''}').where((name) => name.isNotEmpty).join(', ')
          : '';
      return RemoteBook(
        id: 'gutendex-${item['id']}',
        title: _clean('${item['title'] ?? 'Untitled'}'),
        author: author.isEmpty ? 'Project Gutenberg' : author,
        source: 'Gutenberg',
        coverUrl: cover,
        downloadUrl: download,
        kind: kind,
      );
    }).toList();
  }

  Future<List<RemoteBook>> _openLibrary(String query) async {
    final uri = Uri.parse(openLibraryBase).replace(queryParameters: {'q': query, 'limit': '12'});
    final body = await _body(uri);
    if (body == null) return [];
    final decoded = jsonDecode(body);
    final docs = decoded is Map ? decoded['docs'] : null;
    if (docs is! List) return [];
    return docs.whereType<Map>().map((item) {
      final ia = item['ia'];
      final archiveId = ia is List && ia.isNotEmpty ? '${ia.first}' : null;
      final coverId = item['cover_i'];
      final authors = item['author_name'];
      final author = authors is List ? authors.take(2).join(', ') : '';
      return RemoteBook(
        id: 'ol-${item['key'] ?? item['title']}',
        title: _clean('${item['title'] ?? 'Untitled'}'),
        author: author.isEmpty ? 'Open Library' : author,
        source: 'Open Library',
        coverUrl: coverId == null ? null : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg',
        archiveId: archiveId,
        kind: archiveId == null ? '' : 'archive',
      );
    }).toList();
  }

  Future<List<RemoteBook>> _archive(String query) async {
    final uri = Uri.parse(
      '$archiveSearchBase?q=${Uri.encodeQueryComponent('($query) AND mediatype:texts')}&fl[]=identifier&fl[]=title&fl[]=creator&rows=12&page=1&output=json',
    );
    final body = await _body(uri);
    if (body == null) return [];
    final decoded = jsonDecode(body);
    final response = decoded is Map ? decoded['response'] : null;
    final docs = response is Map ? response['docs'] : null;
    if (docs is! List) return [];
    return docs.whereType<Map>().map((item) {
      final identifier = '${item['identifier'] ?? ''}';
      final creator = item['creator'];
      final author = creator is List ? creator.take(2).join(', ') : '${creator ?? ''}';
      return RemoteBook(
        id: 'ia-$identifier',
        title: _clean('${item['title'] ?? identifier}'),
        author: author.isEmpty ? 'Internet Archive' : author,
        source: 'Internet Archive',
        archiveId: identifier.isEmpty ? null : identifier,
        kind: 'archive',
      );
    }).where((book) => book.archiveId != null).toList();
  }

  Future<String?> _body(Uri uri) async {
    try {
      final response = await http.get(uri, headers: apiHeaders).timeout(_timeout);
      if (response.statusCode != 200) return null;
      return utf8.decode(response.bodyBytes);
    } catch (_) {
      return null;
    }
  }

  bool _skipArchiveFile(String name) {
    return name.endsWith('.xml') ||
        name.endsWith('.sqlite') ||
        name.endsWith('.gz') ||
        name.endsWith('.zip') ||
        name.endsWith('.torrent') ||
        name.contains('thumb') ||
        name.endsWith('.mp3') ||
        name.endsWith('.ogg');
  }

  String? _kindFor(String name) {
    if (name.endsWith('.txt')) return 'txt';
    if (name.endsWith('.html') || name.endsWith('.htm')) return 'html';
    if (name.endsWith('.epub')) return 'epub';
    if (name.endsWith('.pdf')) return 'pdf';
    return null;
  }

  String _clean(String title) => title.replaceAll(RegExp(r'\s+'), ' ').trim();
}

class KeepableFile {
  final String url;
  final String kind;

  const KeepableFile(this.url, this.kind);
}

Future<KeepableFile?> resolveDownload(LibraryApi library, RemoteBook book) async {
  if (book.downloadUrl != null && book.kind.isNotEmpty && book.kind != 'archive') {
    return KeepableFile(book.downloadUrl!, book.kind);
  }
  final archiveId = book.archiveId;
  if (archiveId == null) {
    throw const GitaException('This listing has no public file to keep.');
  }
  final resolved = await library.resolveArchive(archiveId);
  if (resolved == null) {
    throw const GitaException('No text, html, epub, or pdf file was found for this book.');
  }
  return KeepableFile(resolved.url, resolved.kind);
}
