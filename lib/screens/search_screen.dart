import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../phrases.dart';
import '../theme.dart';
import 'library_screen.dart';
import 'settings_screen.dart';
import 'reader_screen.dart';
import 'scripture_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  String query = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final chapters = state.chapters;
    final lower = query.trim().toLowerCase();
    final jump = RegExp(r'(\d{1,2})\s*[:.\-]\s*(\d{1,3})').firstMatch(query);
    int? jumpChapter;
    int? jumpVerse;
    if (jump != null) {
      final chapter = int.parse(jump.group(1)!);
      final verse = int.parse(jump.group(2)!);
      final known = chapters.where((item) => item.number == chapter);
      if (known.isNotEmpty && verse >= 1 && verse <= known.first.verses) {
        jumpChapter = chapter;
        jumpVerse = verse;
      }
    }
    final matches = chapters.where((chapter) {
      if (lower.isEmpty) return true;
      return chapter.translation.toLowerCase().contains(lower) ||
          chapter.transliteration.toLowerCase().contains(lower) ||
          chapter.name.contains(query.trim()) ||
          '${chapter.number}' == lower;
    }).toList();
    return Scaffold(
      appBar: AppBar(title: Text(phrase(state, 'search')), actions: const [PageTools()]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Karma, chapter 12, or 2.47',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              ),
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (jumpChapter != null && jumpVerse != null)
                  ListTile(
                    leading: const Icon(Icons.menu_book, color: kSaffron),
                    title: Text('Open shloka $jumpChapter.$jumpVerse'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ReaderScreen(chapter: jumpChapter!, verse: jumpVerse!)),
                      );
                    },
                  ),
                for (final chapter in matches)
                  ListTile(
                    title: Text(chapter.headingFor(state.language)),
                    subtitle: Text('${chapter.name} · ${chapter.verses} shlokas'),
                    onTap: () => openChapter(context, chapter),
                  ),
                if (query.trim().isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.local_library_outlined),
                    title: Text('Search free books for “${query.trim()}”'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => LibraryScreen(initialQuery: query.trim())),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
