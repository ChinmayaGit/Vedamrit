import 'dart:convert';

import 'package:flutter/services.dart';

class GitaLeaf {
  final int chapter;
  final int verse;
  final String sanskrit;
  final String transliteration;

  const GitaLeaf({
    required this.chapter,
    required this.verse,
    required this.sanskrit,
    required this.transliteration,
  });
}

class GitaText {
  static List<GitaLeaf>? _leaves;
  static List<String>? _english;
  static String? song;

  static Future<void> ensure() async {
    if (_leaves != null && _english != null && song != null) return;
    final raw = await rootBundle.loadString('assets/scripture/gita_verses.json');
    final rows = jsonDecode(raw) as List;
    _leaves = rows.map((row) {
      final item = (row as Map).cast<String, dynamic>();
      return GitaLeaf(
        chapter: item['c'] as int,
        verse: item['v'] as int,
        sanskrit: _lines('${item['sa'] ?? ''}'),
        transliteration: _lines('${item['tr'] ?? ''}'),
      );
    }).toList();
    final poem = await rootBundle.loadString('assets/scripture/song_celestial.txt');
    song = _lines(poem);
    _english = _splitArnold(song!);
  }

  static GitaLeaf? leaf(int chapter, int verse) {
    final rows = _leaves;
    if (rows == null) return null;
    for (final row in rows) {
      if (row.chapter == chapter && row.verse == verse) return row;
    }
    return null;
  }

  static List<GitaLeaf> chapter(int number) {
    final rows = _leaves;
    if (rows == null) return const [];
    return rows.where((row) => row.chapter == number).toList();
  }

  static String englishChapter(int number) {
    final rows = _english;
    if (rows == null || number < 1 || number >= rows.length) return '';
    return rows[number];
  }
}

String tidyMeaning(String text) {
  return text.replaceFirst(RegExp(r'^\d+\.\d+\.?\s*'), '').trim();
}

String _lines(String raw) {
  return raw.split('\n').map((line) => line.trim()).join('\n').replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
}

const _romans = <String, int>{
  'I': 1,
  'II': 2,
  'III': 3,
  'IV': 4,
  'V': 5,
  'VI': 6,
  'VII': 7,
  'VIII': 8,
  'IX': 9,
  'X': 10,
  'XI': 11,
  'XII': 12,
  'XIII': 13,
  'XIV': 14,
  'XV': 15,
  'XVI': 16,
  'XVII': 17,
  'XVIII': 18,
};

List<String> _splitArnold(String text) {
  final chapters = List<String>.filled(19, '');
  final buffer = StringBuffer();
  int? current;
  for (final raw in text.split('\n')) {
    final line = raw.trim();
    final match = RegExp(r'^CHAPTER\s+([IVX]+)$').firstMatch(line);
    final number = match == null ? null : _romans[match.group(1)];
    if (number != null) {
      if (current != null) chapters[current] = buffer.toString().trim();
      buffer.clear();
      current = number;
      continue;
    }
    if (current != null && line.startsWith('HERE END')) {
      chapters[current] = buffer.toString().trim();
      buffer.clear();
      current = null;
      continue;
    }
    if (current != null) buffer.writeln(line);
  }
  if (current != null) chapters[current] = buffer.toString().trim();
  return chapters;
}
