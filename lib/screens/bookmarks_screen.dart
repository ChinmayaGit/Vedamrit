import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../catalog.dart';
import '../phrases.dart';
import '../models.dart';
import '../theme.dart';
import 'book_reader_screen.dart';
import 'settings_screen.dart';
import 'gita_book_screen.dart';
import 'passage_screen.dart';
import 'reader_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final marks = state.bookmarks;
    return Scaffold(
      appBar: AppBar(
        title: Text(phrase(state, 'bookmarks')),
        automaticallyImplyLeading: !embedded,
        actions: const [PageTools()],
      ),
      body: marks.isEmpty
          ? const Center(child: Text('The round bookmark button keeps a place here.', style: TextStyle(color: kMuted)))
          : ListView.separated(
              itemCount: marks.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final mark = marks[index];
                return ListTile(
                  leading: const Icon(Icons.bookmark, color: kSaffron),
                  title: Text(mark.title),
                  subtitle: Text(mark.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    tooltip: 'Remove',
                    onPressed: () => context.read<AppState>().toggleBookmark(mark),
                    icon: const Icon(Icons.close),
                  ),
                  onTap: () => _open(context, mark),
                );
              },
            ),
    );
  }

  void _open(BuildContext context, Bookmark mark) {
    if (mark.kind == 'song') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SongCelestialScreen()));
      return;
    }
    if (mark.kind == 'chapter' && mark.chapter != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => GitaChapterBookScreen(chapter: mark.chapter!)));
      return;
    }
    if (mark.kind == 'shloka' && mark.chapter != null && mark.verse != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReaderScreen(chapter: mark.chapter!, verse: mark.verse!)));
      return;
    }
    if (mark.kind == 'passage') {
      final known = mark.passageId == null ? null : passageById(mark.passageId!);
      final passage = known ??
          Passage(
            id: mark.passageId ?? mark.id,
            title: mark.title,
            sanskrit: mark.sanskrit ?? '',
            transliteration: mark.transliteration ?? '',
            meaning: mark.meaning ?? mark.subtitle,
          );
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => PassageScreen(passage: passage)));
      return;
    }
    if (mark.kind == 'book' && mark.bookPath != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BookReaderScreen(
            id: mark.id,
            title: mark.title,
            path: mark.bookPath!,
            kind: mark.bookKind ?? 'txt',
          ),
        ),
      );
    }
  }
}
