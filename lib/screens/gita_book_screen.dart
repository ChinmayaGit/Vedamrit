import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../catalog.dart';
import '../gita_text.dart';
import '../phrases.dart';
import '../models.dart';
import '../reader_audio.dart';
import '../scripture_catalog.dart';
import '../theme.dart';
import '../widgets.dart';
import 'reader_screen.dart';
import 'settings_screen.dart';

class SongCelestialScreen extends StatefulWidget {
  const SongCelestialScreen({super.key});

  @override
  State<SongCelestialScreen> createState() => _SongCelestialScreenState();
}

class _SongCelestialScreenState extends State<SongCelestialScreen> {
  String? text;
  bool showControls = true;
  late ReaderAudio audio;

  @override
  void initState() {
    super.initState();
    audio = context.read<ReaderAudio>();
    audio.speed = context.read<AppState>().speed;
    _load();
  }

  @override
  void dispose() {
    audio.stop();
    super.dispose();
  }

  Future<void> _load() async {
    await GitaText.ensure();
    if (!mounted) return;
    setState(() => text = GitaText.song);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final sound = context.watch<ReaderAudio>();
    const id = 'song-celestial';
    final body = text;
    return Scaffold(
      backgroundColor: paperOf(context),
      appBar: showControls
          ? AppBar(
              backgroundColor: paperOf(context),
              surfaceTintColor: Colors.transparent,
              title: Text(phrase(state, 'songTitle')),
              actions: [
                IconButton(
                  tooltip: 'Fullscreen',
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () => setState(() => showControls = false),
                ),
                const PageTools(),
              ],
            )
          : null,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (state.tapToToggleUi) {
            setState(() => showControls = !showControls);
          }
        },
        child: Stack(
          children: [
            BookPage(
              children: [
                const Text(
                  '॥ श्रीमद्भगवद्गीता ॥',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kSaffron, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sir Edwin Arnold, 1885',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kMuted),
                ),
                const SizedBox(height: 22),
                if (state.language != 'en')
                  Text(
                    phrase(state, 'readingHelp'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, height: 1.7, color: inkOf(context)),
                  )
                else if (body == null)
                  const LinearProgressIndicator(color: kSaffron)
                else
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, height: 1.7, color: inkOf(context)),
                  ),
              ],
            ),
            if (showControls)
              Positioned(
                left: 16,
                right: 16,
                bottom: 16 + MediaQuery.paddingOf(context).bottom,
                child: ReaderDock(
              bookmarked: state.bookmarked(id),
              playing: sound.playing && sound.activeId == id,
              speed: sound.speed,
              onBookmark: () {
                state.toggleBookmark(
                  const Bookmark(
                    id: id,
                    kind: 'song',
                    title: 'The Song Celestial',
                    subtitle: 'Sir Edwin Arnold, 1885',
                  ),
                );
              },
              onPlay: state.language == 'en' && body != null ? () => audio.toggle(id, [SpeechBit(body, state.spokenLocale)]) : null,
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class GitaChapterBookScreen extends StatefulWidget {
  const GitaChapterBookScreen({super.key, required this.chapter});

  final int chapter;

  @override
  State<GitaChapterBookScreen> createState() => _GitaChapterBookScreenState();
}

class _GitaChapterBookScreenState extends State<GitaChapterBookScreen> {
  late int chapter;
  late ReaderAudio audio;
  bool ready = false;
  bool showControls = true;
  final Map<int, String> meanings = {};
  int _token = 0;
  String? _loadedLang;

  @override
  void initState() {
    super.initState();
    chapter = widget.chapter;
    audio = context.read<ReaderAudio>();
    audio.speed = context.read<AppState>().speed;
    _prepare();
  }

  @override
  void dispose() {
    audio.stop();
    super.dispose();
  }

  Future<void> _prepare() async {
    await GitaText.ensure();
    if (!mounted) return;
    final state = context.read<AppState>();
    final current = state.chapterOf(chapter);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      state.remember(
        ReadingSpot(
          title: current?.headingFor(state.language) ?? 'Bhagavad Gita',
          subtitle: 'Chapter $chapter',
          chapter: chapter,
          verse: 1,
          progress: 0,
          kind: 'chapter',
        ),
      );
    });
    setState(() {
      ready = true;
      _loadedLang = state.language;
      meanings.clear();
    });
    _loadMeanings();
  }

  Future<void> _loadMeanings() async {
    final token = ++_token;
    final state = context.read<AppState>();
    final lang = state.language;
    _loadedLang = lang;
    if (mounted && meanings.isNotEmpty) setState(meanings.clear);
    if (lang == 'en' || lang == 'sa') return;
    final leaves = GitaText.chapter(chapter);
    final language = languageByCode(lang);
    const batch = 4;
    for (var i = 0; i < leaves.length; i += batch) {
      if (!mounted || token != _token) return;
      final slice = leaves.skip(i).take(batch);
      await Future.wait(slice.map((leaf) async {
        try {
          final shloka = await state.openShloka(leaf.chapter, leaf.verse);
          String? line;
          if (language.assisted) {
            final english = shloka.englishSource;
            if (english != null) line = await state.api.assist(lang, leaf.chapter, leaf.verse, english);
          } else {
            for (final voice in shloka.inLanguage(lang)) {
              if (voice.hasTranslation) {
                line = tidyMeaning(voice.translation!);
                break;
              }
            }
          }
          if (!mounted || token != _token || line == null || line.isEmpty) return;
          setState(() => meanings[leaf.verse] = line!);
        } catch (_) {}
      }));
    }
  }

  void _step(int delta) {
    final next = chapter + delta;
    if (next < 1 || next > 18) return;
    audio.stop();
    setState(() => chapter = next);
    _prepare();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final sound = context.watch<ReaderAudio>();
    if (ready && _loadedLang != state.language) {
      final lang = state.language;
      _loadedLang = lang;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || context.read<AppState>().language != lang) return;
        _loadMeanings();
      });
    }
    final current = state.chapterOf(chapter);
    final leaves = ready ? GitaText.chapter(chapter) : const <GitaLeaf>[];
    final english = ready ? GitaText.englishChapter(chapter) : '';
    final id = 'gita-chapter-$chapter';
    final title = current?.headingFor(state.language) ?? 'Chapter $chapter';
    return Scaffold(
      backgroundColor: paperOf(context),
      appBar: showControls
          ? AppBar(
              backgroundColor: paperOf(context),
              surfaceTintColor: Colors.transparent,
              title: Text(title),
              actions: [
                IconButton(
                  tooltip: 'Fullscreen',
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () => setState(() => showControls = false),
                ),
                const PageTools(),
              ],
            )
          : null,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (state.tapToToggleUi) {
            setState(() => showControls = !showControls);
          }
        },
        child: Stack(
          children: [
            BookPage(
            children: [
              Text(
                '॥ अध्यायः $chapter ॥',
                textAlign: TextAlign.center,
                style: const TextStyle(color: kSaffron, fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.2, color: inkOf(context)),
              ),
              if (current != null) ...[
                const SizedBox(height: 6),
                Text(current.name, textAlign: TextAlign.center, style: const TextStyle(color: kMuted)),
              ],
              const SizedBox(height: 8),
              Text(
                '${leaves.length} shlokas',
                textAlign: TextAlign.center,
                style: const TextStyle(color: kMuted),
              ),
              const SizedBox(height: 28),
              if (!ready) const LinearProgressIndicator(color: kSaffron),
              for (final leaf in leaves) ...[
                Text(
                  '॥ ${leaf.chapter}.${leaf.verse} ॥',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: kSaffron, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                Text(
                  leaf.sanskrit,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, height: 1.85, fontWeight: FontWeight.w600, color: inkOf(context)),
                ),
                if (state.showTransliteration && leaf.transliteration.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    leaf.transliteration,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: kMuted, fontSize: 15, height: 1.55, fontStyle: FontStyle.italic),
                  ),
                ],
                if (meanings[leaf.verse] != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    meanings[leaf.verse]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, height: 1.6, color: inkOf(context)),
                  ),
                ],
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ReaderScreen(chapter: leaf.chapter, verse: leaf.verse)),
                    );
                  },
                  child: Text(phrase(state, 'thisShloka')),
                ),
                const SizedBox(height: 22),
              ],
              const Divider(color: kSaffron, thickness: 1, indent: 80, endIndent: 80),
              const SizedBox(height: 18),
              Text(
                'Original Translation (The Song Celestial)',
                textAlign: TextAlign.center,
                style: const TextStyle(color: kSaffron, fontWeight: FontWeight.w800, letterSpacing: 1.2),
              ),
              const SizedBox(height: 4),
              const Text(
                'The Song Celestial · Sir Edwin Arnold, 1885',
                textAlign: TextAlign.center,
                style: TextStyle(color: kMuted, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Text(
                english.isEmpty ? phrase(state, 'opening') : english,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, height: 1.7, color: inkOf(context)),
              ),
            ],
          ),
          if (showControls)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16 + MediaQuery.paddingOf(context).bottom,
              child: ReaderDock(
                bookmarked: state.bookmarked(id),
                playing: sound.playing && sound.activeId == id,
                speed: sound.speed,
                onPrevious: chapter <= 1 ? null : () => _step(-1),
                onNext: chapter >= 18 ? null : () => _step(1),
                onBookmark: () {
                  state.toggleBookmark(
                    Bookmark(
                      id: id,
                      kind: 'chapter',
                      title: 'Gita chapter $chapter',
                      subtitle: title,
                      chapter: chapter,
                      verse: 1,
                    ),
                  );
                },
                onPlay: leaves.isEmpty
                    ? null
                    : () => audio.toggle(id, [
                          for (final leaf in leaves) SpeechBit(leaf.sanskrit, 'hi-IN'),
                          if (state.language == 'en' && english.isNotEmpty) SpeechBit(english, state.spokenLocale),
                          if (state.language != 'en' && state.language != 'sa')
                            for (final leaf in leaves)
                              if (meanings[leaf.verse] != null) SpeechBit(meanings[leaf.verse]!, state.spokenLocale),
                        ]),
              ),
            ),
        ],
      ),
      ),
    );
  }
}

class FortyVersesScreen extends StatelessWidget {
  const FortyVersesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: paperOf(context),
      appBar: AppBar(
        backgroundColor: paperOf(context),
        surfaceTintColor: Colors.transparent,
        title: Text(phrase(state, 'forty')),
        actions: const [PageTools()],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        children: [
          Text(
            phrase(state, 'shortPath'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: kMuted, height: 1.4),
          ),
          const SizedBox(height: 16),
          for (final spot in fortyVerses)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: cardOf(context),
                foregroundColor: kSaffron,
                child: Text('${spot.$1}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
              ),
              title: Text('॥ ${spot.$1}.${spot.$2} ॥', textAlign: TextAlign.center),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ReaderScreen(chapter: spot.$1, verse: spot.$2)),
                );
              },
            ),
        ],
      ),
    );
  }
}

class BookPage extends StatelessWidget {
  const BookPage({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: ListView(
          padding: EdgeInsets.fromLTRB(28, 12, 28, 132 + MediaQuery.paddingOf(context).bottom),
          children: children,
        ),
      ),
    );
  }
}
