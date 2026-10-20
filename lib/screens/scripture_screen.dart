import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../catalog.dart';
import '../phrases.dart';
import '../gita_api.dart';
import '../models.dart';
import '../scripture_catalog.dart';
import '../theme.dart';
import '../widgets.dart';
import 'gita_book_screen.dart';
import 'settings_screen.dart';
import 'library_screen.dart';
import 'passage_screen.dart';
import 'reader_screen.dart';
import 'search_screen.dart';
import 'book_reader_screen.dart';

void openChapter(BuildContext context, Chapter chapter) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChapterScreen(chapter: chapter)));
}

void openVeda(BuildContext context, Veda veda) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => VedaScreen(veda: veda)));
}

void resumeSpot(BuildContext context, ReadingSpot? spot) {
  if (spot == null) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReaderScreen(chapter: 1, verse: 1)));
    return;
  }
  if (spot.kind == 'book' && spot.bookPath != null) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookReaderScreen(
          id: spot.bookId ?? spot.title,
          title: spot.title,
          path: spot.bookPath!,
          kind: spot.bookKind ?? 'txt',
        ),
      ),
    );
    return;
  }
  if (spot.kind == 'chapter') {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GitaChapterBookScreen(chapter: spot.chapter > 0 ? spot.chapter : 1),
      ),
    );
    return;
  }
  if (spot.kind == 'song') {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SongCelestialScreen()));
    return;
  }
  if (spot.kind == 'forty') {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FortyVersesScreen()));
    return;
  }
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => ReaderScreen(
        chapter: spot.chapter > 0 ? spot.chapter : 1,
        verse: spot.verse > 0 ? spot.verse : 1,
      ),
    ),
  );
}

class SectionShelfScreen extends StatelessWidget {
  const SectionShelfScreen({super.key, required this.section});

  final (String, String, String) section;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: paperOf(context),
      appBar: AppBar(
        backgroundColor: paperOf(context),
        surfaceTintColor: Colors.transparent,
        title: Text(phrase(state, section.$1)),
        actions: const [PageTools()],
      ),
      body: _Shelf(
        section: section,
        chapters: state.chapters,
        kept: state.keptChapters,
      ),
    );
  }
}

class ScriptureCatalogGrid extends StatelessWidget {
  const ScriptureCatalogGrid({super.key, required this.onSelectSection});

  final void Function((String, String, String) section) onSelectSection;

  static const _sectionMeta = <String, ({String sanskrit, String desc, IconData icon})>{
    'vedas': (sanskrit: 'वेदाः', desc: 'Rig, Sama, Yajur, Atharva', icon: Icons.auto_stories),
    'gita': (sanskrit: 'श्रीमद्भगवद्गीता', desc: '18 Chapters · 700 Shlokas', icon: Icons.menu_book),
    'upanishads': (sanskrit: 'उपनिषदः', desc: '108 Upanishads & Vedanta', icon: Icons.self_improvement),
    'puranas': (sanskrit: 'पुराणानि', desc: 'Bhagavatam, Vishnu, Shiva...', icon: Icons.temple_hindu),
    'epics': (sanskrit: 'इतिहासः', desc: 'Mahabharata & Ramayana', icon: Icons.shield_outlined),
    'shastras': (sanskrit: 'शास्त्राणि', desc: 'Sutras & Treatises', icon: Icons.school_outlined),
    'yoga': (sanskrit: 'योगदर्शनम्', desc: 'Patanjali Sutras & Hatha Yoga', icon: Icons.spa_outlined),
  };

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: scriptureSections.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final sec = scriptureSections[index];
        final meta = _sectionMeta[sec.$1];
        final gradient = coverGradients[index % coverGradients.length];
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onSelectSection(sec),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: softShadow(context),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(meta?.icon ?? Icons.book, color: Colors.white, size: 20),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
                    ],
                  ),
                  const Spacer(),
                  if (meta != null)
                    Text(
                      meta.sanskrit,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    phrase(state, sec.$1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meta?.desc ?? sec.$3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ScriptureScreen extends StatefulWidget {
  const ScriptureScreen({super.key});

  @override
  State<ScriptureScreen> createState() => _ScriptureScreenState();
}

class _ScriptureScreenState extends State<ScriptureScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AppState>().refreshChapters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(phrase(state, 'shastra'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
              Text(phrase(state, 'sacred'), style: const TextStyle(fontSize: 13, color: kMuted)),
            ],
          ),
          actions: [
            const PageTools(),
            IconButton(
              tooltip: phrase(state, 'search'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen())),
              icon: const Icon(Icons.search),
            ),
            IconButton(
              tooltip: 'Keep the whole Gita on this phone',
              onPressed: state.activeTask != null ? null : () => _keepAll(context, state),
              icon: Icon(state.keptChapters.length == state.chapters.length ? Icons.cloud_done : Icons.cloud_download_outlined),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            ScriptureCatalogGrid(
              onSelectSection: (section) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => SectionShelfScreen(section: section)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _keepAll(BuildContext context, AppState state) async {
    final go = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Keep the Gita on this phone?'),
        content: const Text('This fetches all 18 chapters from the free Bhagavad Gita API and stores them here. It can take a few minutes.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialog, false), child: const Text('Not now')),
          TextButton(onPressed: () => Navigator.pop(dialog, true), child: const Text('Keep')),
        ],
      ),
    );
    if (go == true) await state.keepEntireGita();
  }
}

class _Shelf extends StatelessWidget {
  const _Shelf({required this.section, required this.chapters, required this.kept});

  final (String, String, String) section;
  final List<Chapter> chapters;
  final Set<int> kept;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final works = worksIn(section.$1).where((work) => state.language == 'en' || work.kind != 'song').toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text(section.$3, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(
          section.$1 == 'gita' ? phrase(state, 'gitaNote') : phrase(state, 'shelfNote'),
          style: const TextStyle(color: kMuted, height: 1.4),
        ),
        const SizedBox(height: 14),
        for (var i = 0; i < works.length; i++) ...[
          _ScriptTile(
            colors: coverGradients[i % coverGradients.length],
            kicker: section.$2,
            title: works[i].kind == 'song'
                ? phrase(state, 'songTitle')
                : works[i].kind == 'forty'
                    ? phrase(state, 'forty')
                    : works[i].title,
            subtitle: works[i].kind == 'forty' ? phrase(state, 'shortPath') : works[i].credit,
            onTap: () => openWork(context, works[i]),
          ),
          const SizedBox(height: 12),
        ],
        if (section.$1 == 'gita') ...[
          const SizedBox(height: 8),
          SectionLabel(phrase(state, 'chapters')),
          for (var i = 0; i < chapters.length; i++) ...[
            _ScriptTile(
              colors: coverGradients[i % coverGradients.length],
              kicker: chapters[i].number.toString().padLeft(2, '0'),
              title: chapters[i].headingFor(state.language),
              subtitle: '${chapters[i].name}  ·  ${chapters[i].verses} shlokas',
              trailing: kept.contains(chapters[i].number) ? const Icon(Icons.cloud_done, color: kSaffron) : null,
              onTap: () => openChapter(context, chapters[i]),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }
}

void openWork(BuildContext context, SacredWork work) {
  switch (work.kind) {
    case 'song':
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SongCelestialScreen()));
    case 'forty':
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FortyVersesScreen()));
    case 'chapters':
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GitaChapterBookScreen(chapter: 1)));
    case 'cantos':
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _CantoScreen()));
    case 'vedas':
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _VedaShelfScreen()));
    case 'asset':
      if (work.assetPath != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BookReaderScreen(
              id: work.id,
              title: work.title,
              path: work.assetPath!,
              kind: 'txt',
            ),
          ),
        );
      }
    case 'gutenberg':
      _openGutenberg(context, work);
    case 'search':
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => LibraryScreen(initialQuery: work.query ?? work.title)));
  }
}

Future<void> _openGutenberg(BuildContext context, SacredWork work) async {
  final id = work.gutenberg;
  if (id == null) return;
  final state = context.read<AppState>();
  final bookId = 'pg-$id';
  final saved = state.savedBook(bookId);
  if (saved != null) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookReaderScreen(id: saved.id, title: saved.title, path: saved.path, kind: saved.kind),
      ),
    );
    return;
  }
  try {
    await state.keepBook(
      RemoteBook(
        id: bookId,
        title: work.title,
        author: work.credit,
        source: 'Project Gutenberg',
        downloadUrl: 'https://www.gutenberg.org/cache/epub/$id/pg$id.txt',
        kind: 'txt',
      ),
    );
    if (!context.mounted) return;
    final kept = state.savedBook(bookId);
    if (kept == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookReaderScreen(id: kept.id, title: kept.title, path: kept.path, kind: kept.kind),
      ),
    );
  } on GitaException catch (err) {
    if (!context.mounted) return;
    showNotice(context, err.message);
  }
}

class _CantoScreen extends StatelessWidget {
  const _CantoScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Srimad Bhagavatam'), actions: const [PageTools()]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text(
            'Twelve skandhas. These notes are a guide. Full public-domain editions, when a library has them, are on the download button.',
            style: TextStyle(color: kMuted, height: 1.4),
          ),
          const SizedBox(height: 14),
          for (final canto in cantos) ...[
            _ScriptTile(
              colors: coverGradients[(canto.number - 1) % coverGradients.length],
              kicker: canto.number.toString().padLeft(2, '0'),
              title: canto.name,
              subtitle: canto.sanskrit,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PassageScreen(
                      passage: Passage(
                        id: 'canto-${canto.number}',
                        title: 'Skandha ${canto.number} · ${canto.name}',
                        sanskrit: canto.sanskrit,
                        transliteration: '',
                        meaning: canto.summary,
                      ),
                      libraryQuery: canto.query,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _VedaShelfScreen extends StatelessWidget {
  const _VedaShelfScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mantras'), actions: const [PageTools()]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          for (var i = 0; i < vedas.length; i++) ...[
            _ScriptTile(
              colors: coverGradients[(i + 2) % coverGradients.length],
              kicker: 'Veda',
              title: vedas[i].name,
              subtitle: vedas[i].sanskrit,
              onTap: () => openVeda(context, vedas[i]),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _ScriptTile extends StatelessWidget {
  const _ScriptTile({
    required this.colors,
    required this.kicker,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final List<Color> colors;
  final String kicker;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardOf(context),
      borderRadius: BorderRadius.circular(18),
      elevation: darkOf(context) ? 0 : 3,
      shadowColor: liftShadow(context),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(colors: colors),
                ),
                child: Text(kicker, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: kMuted)),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
              const Icon(Icons.chevron_right, color: kMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class ChapterScreen extends StatelessWidget {
  const ChapterScreen({super.key, required this.chapter});

  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final current = state.chapterOf(chapter.number) ?? chapter;
    final kept = state.keptChapters.contains(current.number);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapter ${current.number}'),
        actions: [
          const PageTools(),
          IconButton(
            tooltip: kept ? 'On this phone' : 'Keep this chapter',
            onPressed: kept || state.activeTask != null ? null : () => state.keepChapter(current.number),
            icon: Icon(kept ? Icons.cloud_done : Icons.cloud_download_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          if (state.activeTask != null) TaskBar(label: state.activeTask!.label, value: state.activeTask!.value),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoverCard(
                width: 120,
                height: 168,
                kicker: current.number.toString().padLeft(2, '0'),
                title: current.name,
                subtitle: '${current.verses} shlokas',
                colors: coverGradients[(current.number - 1) % coverGradients.length],
                onTap: () {},
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(current.headingFor(state.language), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.15)),
                    const SizedBox(height: 6),
                    Text(current.transliteration, style: const TextStyle(color: kMuted)),
                    const SizedBox(height: 8),
                    Text('${current.verses} shlokas', style: const TextStyle(color: kSaffron, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (current.blurbFor(state.language).isNotEmpty)
            Text(current.blurbFor(state.language), style: const TextStyle(fontSize: 16, height: 1.45)),
          const SizedBox(height: 18),
          PillButton(
            label: phrase(state, 'readChapter'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => GitaChapterBookScreen(chapter: current.number)),
              );
            },
          ),
          const SizedBox(height: 18),
          const SectionLabel('Shlokas'),
          for (var verse = 1; verse <= current.verses; verse++)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: creamOf(context),
                foregroundColor: kSaffron,
                child: Text('$verse', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
              ),
              title: Text('Shloka ${current.number}.$verse'),
              subtitle: Text(phrase(state, 'acharyas')),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ReaderScreen(chapter: current.number, verse: verse)),
                );
              },
            ),
        ],
      ),
    );
  }
}

class VedaScreen extends StatelessWidget {
  const VedaScreen({super.key, required this.veda});

  final Veda veda;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(veda.name), actions: const [PageTools()]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(veda.sanskrit, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(veda.summary, style: const TextStyle(fontSize: 16, height: 1.45)),
          const SizedBox(height: 16),
          PillButton(
            label: 'Find free editions',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => LibraryScreen(initialQuery: veda.query)));
            },
          ),
          const SizedBox(height: 18),
          const SectionLabel('Shlokas'),
          for (final passage in veda.passages)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(passage.title, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(passage.sanskrit, maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => PassageScreen(passage: passage, libraryQuery: veda.query)));
              },
            ),
        ],
      ),
    );
  }
}
