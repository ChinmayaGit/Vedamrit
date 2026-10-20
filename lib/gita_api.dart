import 'dart:convert';

import 'package:http/http.dart' as http;

import 'catalog.dart';
import 'local_store.dart';
import 'models.dart';

class GitaException implements Exception {
  final String message;
  const GitaException(this.message);

  @override
  String toString() => message;
}

class GitaApi {
  GitaApi(this.store);

  final LocalStore store;
  static const _timeout = Duration(seconds: 30);

  Future<List<Chapter>> fetchChapters() async {
    final response = await _get(Uri.parse('$gitaBase/chapters'));
    await store.writeText('gita/chapters.json', response);
    final parsed = parseChapters(response);
    if (parsed.isEmpty) {
      throw const GitaException('The Gita library returned no chapters.');
    }
    return parsed;
  }

  static List<Chapter> parseChapters(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! List) return [];
    final fallback = {for (final chapter in bundledChapters) chapter.number: chapter};
    final chapters = <Chapter>[];
    for (final item in decoded) {
      if (item is! Map) continue;
      final number = _asInt(item['chapter_number']);
      if (number <= 0) continue;
      final known = fallback[number];
      final meaning = item['meaning'];
      var english = '';
      var hindi = '';
      if (meaning is Map) {
        english = '${meaning['en'] ?? ''}'.trim();
        hindi = '${meaning['hi'] ?? ''}'.trim();
      } else if (meaning is String) {
        english = meaning.trim();
      }
      final count = _asInt(item['verses_count']);
      chapters.add(
        Chapter(
          number: number,
          verses: count > 0 ? count : (known?.verses ?? 1),
          name: _text(item['name'], known?.name ?? 'अध्याय $number'),
          transliteration: _text(item['transliteration'], known?.transliteration ?? 'Chapter $number'),
          translation: _text(item['translation'], known?.translation ?? 'Chapter $number'),
          summary: english.isEmpty ? (known?.summary ?? '') : english,
          hindiSummary: hindi,
        ),
      );
    }
    chapters.sort((a, b) => a.number.compareTo(b.number));
    return chapters;
  }

  Future<Shloka?> cachedShloka(int chapter, int verse) async {
    final body = await store.readText('gita/$chapter-$verse.json');
    if (body == null) return null;
    try {
      return parseShloka(body);
    } catch (_) {
      return null;
    }
  }

  Future<bool> hasShloka(int chapter, int verse) => store.exists('gita/$chapter-$verse.json');

  Future<bool> hasChapter(int chapter) async => (await store.readText('gita/ch-$chapter.done')) == '1';

  Future<void> markChapter(int chapter) => store.writeText('gita/ch-$chapter.done', '1');

  Future<Shloka> fetchShloka(int chapter, int verse) async {
    final body = await _get(Uri.parse('$gitaBase/slok/$chapter/$verse'));
    return parseShloka(body);
  }

  Future<void> persistShloka(Shloka shloka) => store.writeText('gita/${shloka.chapter}-${shloka.verse}.json', shloka.raw);

  static Shloka parseShloka(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! Map) {
      throw const GitaException('This shloka could not be read.');
    }
    final voices = <Voice>[];
    decoded.forEach((key, value) {
      if (value is! Map) return;
      final author = _text(value['author'], '$key');
      _addVoice(voices, author, 'hi', value['ht']?.toString(), value['hc']?.toString());
      _addVoice(voices, author, 'en', value['et']?.toString(), value['ec']?.toString());
      _addVoice(voices, author, 'sa', null, value['sc']?.toString());
    });
    return Shloka(
      chapter: _asInt(decoded['chapter']),
      verse: _asInt(decoded['verse']),
      sanskrit: _text(decoded['slok'], ''),
      transliteration: _text(decoded['transliteration'], ''),
      voices: voices,
      raw: body,
    );
  }

  Future<String?> cachedAssist(String language, int chapter, int verse) =>
      store.readText('gita/assist/$language-$chapter-$verse.txt');

  Future<String> assist(String language, int chapter, int verse, String english) async {
    final cached = await cachedAssist(language, chapter, verse);
    if (cached != null && cached.trim().isNotEmpty) return cached.trim();
    var text = english.replaceAll(RegExp(r'\s+'), ' ').trim();
    text = text.replaceFirst(RegExp(r'^\d+\.\d+\.?\s*'), '');
    if (text.length > 420) text = text.substring(0, 420);
    final uri = Uri.parse('$myMemoryBase?q=${Uri.encodeQueryComponent(text)}&langpair=en|$language');
    final body = await _get(uri);
    final decoded = jsonDecode(body);
    if (decoded is! Map) {
      throw const GitaException('The reading aid returned nothing.');
    }
    final data = decoded['responseData'];
    final translated = data is Map ? '${data['translatedText'] ?? ''}'.trim() : '';
    if (decoded['responseStatus'] != 200 || translated.isEmpty || translated.toUpperCase().contains('MYMEMORY WARNING')) {
      throw const GitaException('The reading aid could not translate this verse. Try again later.');
    }
    if (translated == text) {
      throw const GitaException('The reading aid sent the English line back unchanged.');
    }
    await store.writeText('gita/assist/$language-$chapter-$verse.txt', translated);
    return translated;
  }

  Future<String> _get(Uri uri) async {
    try {
      final response = await http.get(uri, headers: apiHeaders).timeout(_timeout);
      if (response.statusCode != 200) {
        throw GitaException('The library answered ${response.statusCode}.');
      }
      return utf8.decode(response.bodyBytes);
    } on GitaException {
      rethrow;
    } catch (_) {
      throw const GitaException('Could not reach the library. Check the connection and try again.');
    }
  }

  static void _addVoice(List<Voice> voices, String author, String language, String? translation, String? commentary) {
    final voice = Voice(author: author, language: language, translation: translation, commentary: commentary);
    if (voice.hasText) voices.add(voice);
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? 0;
}

String _text(dynamic value, String fallback) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? fallback : text;
}
