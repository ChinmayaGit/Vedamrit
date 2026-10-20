import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../catalog.dart';
import '../phrases.dart';
import '../models.dart';
import '../reader_audio.dart';
import '../theme.dart';
import '../widgets.dart';
import 'bookmarks_screen.dart';
import 'reader_screen.dart';
import 'scripture_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static bool _didAutoResume = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = context.read<AppState>();
      state.loadQuoteOfDay();
      if (!_didAutoResume && state.autoResumeRecent && state.spot != null) {
        _didAutoResume = true;
        resumeSpot(context, state.spot);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final day = state.chapters[DateTime.now().difference(DateTime(DateTime.now().year)).inDays % state.chapters.length];
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'homeRecentFab',
        backgroundColor: kSaffron,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.auto_stories),
        label: Text(
          state.spot != null ? 'Resume: ${state.spot!.title}' : 'Resume Reading',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        tooltip: 'Resume reading where you left off',
        onPressed: () => resumeSpot(context, state.spot),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Menu',
                        onPressed: () => _menu(context, state),
                        icon: const Icon(Icons.menu),
                      ),
                      const Spacer(),
                      const PageTools(),
                      IconButton(
                        tooltip: 'Search',
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen())),
                        icon: const Icon(Icons.search),
                      ),
                      IconButton(
                        tooltip: 'Bookmarks',
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BookmarksScreen())),
                        icon: const Icon(Icons.bookmark_border),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 16),
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(fontSize: 30, height: 1.15),
                        children: [
                          TextSpan(text: phrase(state, 'today')),
                          TextSpan(text: phrase(state, 'todayEm'), style: const TextStyle(fontWeight: FontWeight.w800, color: kSaffron)),
                        ],
                      ),
                    ),
                  ),
                  _QuoteBanner(quote: state.quote, loading: state.quoteLoading, note: state.quoteNote),
                  const SizedBox(height: 22),
                  SectionLabel(phrase(state, 'shastra')),
                  const SizedBox(height: 10),
                  ScriptureCatalogGrid(
                    onSelectSection: (section) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SectionShelfScreen(section: section)),
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  SectionLabel(phrase(state, 'bookOfDay')),
                  _DayCard(chapter: day),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            _ContinueBar(spot: state.spot),
          ],
        ),
      ),
    );
  }

  void _menu(BuildContext context, AppState state) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheet) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.bookmark_outline),
                title: Text(phrase(state, 'bookmarks')),
                onTap: () {
                  Navigator.pop(sheet);
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BookmarksScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: Text(phrase(state, 'settings')),
                subtitle: Text(languageByCode(state.language).label),
                onTap: () {
                  Navigator.pop(sheet);
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(phrase(state, 'sourcesTitle')),
                onTap: () {
                  Navigator.pop(sheet);
                  showDialog<void>(
                    context: context,
                    builder: (dialog) => AlertDialog(
                      title: Text(phrase(state, 'sources')),
                      content: const SingleChildScrollView(child: Text(aboutSources)),
                      actions: [TextButton(onPressed: () => Navigator.pop(dialog), child: Text(phrase(state, 'close')))],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

}

class _QuoteBanner extends StatelessWidget {
  const _QuoteBanner({required this.quote, required this.loading, required this.note});

  final DailyQuote? quote;
  final bool loading;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final shown = quote;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: shown == null
            ? null
            : () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ReaderScreen(chapter: shown.chapter, verse: shown.verse)),
                );
              },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(colors: [Color(0xFF6B2D3C), kClay]),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
            child: loading && shown == null
                ? const SizedBox(height: 88, child: Center(child: CircularProgressIndicator(color: Colors.white)))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            shown == null ? 'श्लोकः' : 'श्लोकः  ·  ${shown.chapter}.${shown.verse}',
                            style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          if (shown != null)
                            IconButton(
                              tooltip: 'Read the verse',
                              onPressed: () {
                                context.read<ReaderAudio>().toggle('quote-${shown.chapter}-${shown.verse}', [
                                  SpeechBit(shown.sanskrit, 'hi-IN'),
                                ]);
                              },
                              icon: Icon(
                                context.watch<ReaderAudio>().playing &&
                                        context.watch<ReaderAudio>().activeId == 'quote-${shown.chapter}-${shown.verse}'
                                    ? Icons.pause
                                    : Icons.volume_up,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        shown?.sanskrit ?? 'Today’s shloka will appear here.',
                        style: const TextStyle(color: Colors.white, fontSize: 20, height: 1.45, fontWeight: FontWeight.w600),
                      ),
                      if (shown != null) ...[
                        const SizedBox(height: 8),
                        Text(shown.transliteration, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                      ],
                      if (note != null) ...[
                        const SizedBox(height: 8),
                        Text(note!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.chapter});

  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: creamOf(context),
        borderRadius: BorderRadius.circular(28),
        boxShadow: softShadow(context),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(phrase(state, 'gita'), style: const TextStyle(color: kSaffron, fontWeight: FontWeight.w800, letterSpacing: 0.6, fontSize: 12)),
                const SizedBox(height: 8),
                Text(chapter.headingFor(state.language), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(chapter.transliteration, style: const TextStyle(color: kMuted)),
                const SizedBox(height: 8),
                if (chapter.blurbFor(state.language).isNotEmpty)
                  Text(chapter.blurbFor(state.language), maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(height: 1.35)),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 140,
                    child: PillButton(label: phrase(state, 'read'), onPressed: () => openChapter(context, chapter)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CoverCard(
            width: 108,
            height: 150,
            kicker: chapter.number.toString().padLeft(2, '0'),
            title: chapter.name,
            subtitle: '${chapter.verses} shlokas',
            colors: coverGradients[(chapter.number - 1) % coverGradients.length],
            onTap: () => openChapter(context, chapter),
          ),
        ],
      ),
    );
  }
}

class _ContinueBar extends StatelessWidget {
  const _ContinueBar({required this.spot});

  final ReadingSpot? spot;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final current = spot;
    return Material(
      color: cardOf(context),
      elevation: darkOf(context) ? 0 : 12,
      shadowColor: liftShadow(context),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: InkWell(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        onTap: () => resumeSpot(context, current),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 12, 14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 62,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: coverGradients[(current?.chapter ?? 1) % coverGradients.length]),
                ),
                child: Text(
                  '${current?.chapter ?? 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(current == null ? phrase(state, 'begin') : current.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(current == null ? 'Chapter 1 · shloka 1' : current.subtitle, style: const TextStyle(color: kMuted, fontSize: 13)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: current?.progress ?? 0,
                        minHeight: 4,
                        color: kClay,
                        backgroundColor: kSaffron.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: kMuted),
            ],
          ),
        ),
      ),
    );
  }
}
