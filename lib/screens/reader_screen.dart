import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../catalog.dart';
import '../gita_text.dart';
import '../phrases.dart';
import '../models.dart';
import '../reader_audio.dart';
import '../theme.dart';
import '../widgets.dart';
import 'gita_book_screen.dart';
import 'settings_screen.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key, required this.chapter, required this.verse});

  final int chapter;
  final int verse;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late int chapter;
  late int verse;
  Shloka? shloka;
  GitaLeaf? bundled;
  String? assisted;
  String? error;
  bool loading = true;
  bool kept = false;
  bool assisting = false;
  bool showControls = true;
  String? _seenLanguage;
  late ReaderAudio audio;

  @override
  void initState() {
    super.initState();
    chapter = widget.chapter;
    verse = widget.verse;
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
    setState(() {
      loading = true;
      error = null;
      assisted = null;
    });
    final state = context.read<AppState>();
    try {
      await GitaText.ensure();
      if (mounted) setState(() => bundled = GitaText.leaf(chapter, verse));
      final next = await state.openShloka(chapter, verse);
      final onPhone = await state.shlokaKept(chapter, verse);
      if (!mounted) return;
      final current = state.chapterOf(chapter);
      state.remember(
        ReadingSpot(
          title: current?.headingFor(state.language) ?? 'Bhagavad Gita',
          subtitle: 'Shloka ${next.chapter}.${next.verse}',
          chapter: next.chapter,
          verse: next.verse,
          progress: current == null || current.verses == 0 ? 0 : next.verse / current.verses,
        ),
      );
      setState(() {
        shloka = next;
        kept = onPhone;
        loading = false;
      });
      await _loadAssist();
    } catch (err) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = err.toString();
      });
    }
  }

  Future<void> _loadAssist() async {
    final state = context.read<AppState>();
    final current = shloka;
    final language = languageByCode(state.language);
    if (current == null || !language.assisted) return;
    final english = current.englishSource;
    if (english == null) return;
    setState(() => assisting = true);
    try {
      final line = await state.api.assist(language.code, current.chapter, current.verse, english);
      if (!mounted) return;
      setState(() {
        assisted = line;
        assisting = false;
      });
    } catch (err) {
      if (!mounted) return;
      setState(() {
        assisting = false;
        assisted = null;
        error = err.toString();
      });
    }
  }

  Future<void> _keep() async {
    final current = shloka;
    if (current == null) return;
    try {
      await context.read<AppState>().keepShloka(current);
      if (!mounted) return;
      setState(() => kept = true);
      showNotice(context, 'Shloka kept on this phone.');
    } catch (err) {
      if (!mounted) return;
      showNotice(context, err.toString());
    }
  }

  void _step(int delta) {
    final next = context.read<AppState>().neighbor(chapter, verse, delta);
    if (next == null) return;
    audio.stop();
    setState(() {
      chapter = next.$1;
      verse = next.$2;
    });
    _load();
  }

  List<SpeechBit> _bits() {
    final current = shloka;
    final sanskrit = current?.sanskrit ?? bundled?.sanskrit ?? '';
    final transliteration = current?.transliteration ?? bundled?.transliteration ?? '';
    if (sanskrit.isEmpty) return [];
    final state = context.read<AppState>();
    final language = languageByCode(state.language);
    final spoken = state.spokenLocale;
    final bits = <SpeechBit>[
      SpeechBit(sanskrit, 'hi-IN'),
      if (state.showTransliteration && transliteration.isNotEmpty) SpeechBit(transliteration, 'en-IN'),
    ];
    if (current == null) return bits;
    if (language.assisted && assisted != null) {
      bits.add(SpeechBit(assisted!, spoken));
    } else {
      final voices = current.inLanguage(language.code);
      if (voices.isNotEmpty) {
        final voice = voices.first;
        if (voice.hasTranslation) bits.add(SpeechBit(voice.translation!, spoken));
        if (voice.hasCommentary) bits.add(SpeechBit(voice.commentary!, spoken));
      }
    }
    return bits;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final sound = context.watch<ReaderAudio>();
    final language = languageByCode(state.language);
    final current = shloka;
    final page = bundled;
    final sanskrit = current?.sanskrit ?? page?.sanskrit ?? '';
    final transliteration = current?.transliteration ?? page?.transliteration ?? '';
    final markId = 'shloka-$chapter-$verse';
    final id = '$markId-${language.code}';
    final meaning = _meaning(current, language);
    final ink = inkOf(context);
    if (_seenLanguage != state.language) {
      final next = state.language;
      _seenLanguage = next;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || context.read<AppState>().language != next) return;
        setState(() {
          assisted = null;
          assisting = false;
        });
        _loadAssist();
      });
    }
    return Scaffold(
      backgroundColor: paperOf(context),
      appBar: showControls
          ? AppBar(
              backgroundColor: paperOf(context),
              surfaceTintColor: Colors.transparent,
              title: Text('॥ $chapter.$verse ॥'),
              actions: [
                IconButton(
                  tooltip: 'Fullscreen',
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () => setState(() => showControls = false),
                ),
                const PageTools(),
                IconButton(
                  tooltip: kept ? 'On this phone' : 'Keep this shloka',
                  onPressed: current == null || kept ? null : _keep,
                  icon: Icon(kept ? Icons.cloud_done : Icons.download),
                ),
              ],
            )
          : null,
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (state.tapToToggleUi) {
                setState(() => showControls = !showControls);
              }
            },
            onHorizontalDragEnd: (details) {
              final velocity = details.primaryVelocity ?? 0;
              if (velocity < -180) _step(1);
              if (velocity > 180) _step(-1);
            },
            child: BookPage(
              children: [
                if (loading && sanskrit.isEmpty) const LinearProgressIndicator(color: kSaffron),
                if (error != null && sanskrit.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Text(error!, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        PillButton(label: 'Try again', onPressed: _load),
                      ],
                    ),
                  ),
                if (sanskrit.isNotEmpty) ...[
                  Text(
                    'Chapter $chapter',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: kSaffron, fontWeight: FontWeight.w800, letterSpacing: 0.6),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    sanskrit,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, height: 1.9, fontWeight: FontWeight.w600, color: ink),
                  ),
                  if (state.showTransliteration && transliteration.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      transliteration,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: kMuted, fontSize: 15, height: 1.55, fontStyle: FontStyle.italic),
                    ),
                  ],
                  const SizedBox(height: 18),
                  const Divider(color: kSaffron, thickness: 1, indent: 72, endIndent: 72),
                  const SizedBox(height: 16),
                  Text(
                    language.code == 'sa' ? 'संस्कृत' : language.label.split('·').first.trim(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: kSaffron, fontWeight: FontWeight.w800, letterSpacing: 1.1),
                  ),
                  const SizedBox(height: 14),
                  if (language.code == 'sa')
                    Text(
                      phrase(state, 'readingHelp'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: kMuted, height: 1.4),
                    )
                  else if (meaning != null) ...[
                    Text(
                      meaning,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, height: 1.65, color: ink),
                    ),
                    if (_speaker(current, language) != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _speaker(current, language)!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: kMuted, fontSize: 13),
                      ),
                    ],
                  ] else if (assisting || loading)
                    const LinearProgressIndicator(color: kSaffron)
                  else
                    Text(
                      phrase(state, 'opening'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: kMuted, height: 1.4),
                    ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(error!, textAlign: TextAlign.center, style: const TextStyle(color: kClay)),
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => GitaChapterBookScreen(chapter: chapter)),
                      );
                    },
                    child: Text(phrase(state, 'readAsBook')),
                  ),
                  if (current != null && !language.assisted && language.code != 'sa')
                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(phrase(state, 'acharyas'), textAlign: TextAlign.center),
                        children: [_voiceList(current, language.code)],
                      ),
                    ),
                ],
              ],
            ),
          ),
          if (showControls)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16 + MediaQuery.paddingOf(context).bottom,
              child: ReaderDock(
              bookmarked: state.bookmarked(markId),
              playing: sound.playing && sound.activeId == id,
              speed: sound.speed,
              onBookmark: () {
                final willAdd = !state.bookmarked(markId);
                state.toggleBookmark(
                  Bookmark(
                    id: markId,
                    kind: 'shloka',
                    title: 'Gita $chapter.$verse',
                    subtitle: state.chapterOf(chapter)?.headingFor(state.language) ?? 'Bhagavad Gita',
                    chapter: chapter,
                    verse: verse,
                  ),
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(willAdd ? 'Added Gita $chapter.$verse to Bookmarks' : 'Removed from Bookmarks'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              onPrevious: state.neighbor(chapter, verse, -1) == null ? null : () => _step(-1),
              onNext: state.neighbor(chapter, verse, 1) == null ? null : () => _step(1),
              onPlay: current == null ? null : () => audio.toggle(id, _bits()),
            ),
          ),
        ],
      ),
    );
  }

  String? _meaning(Shloka? current, ReadingLanguage language) {
    if (language.assisted) return assisted;
    if (current == null || language.code == 'sa') return null;
    final voices = current.inLanguage(language.code);
    for (final voice in voices) {
      if (voice.hasTranslation) return tidyMeaning(voice.translation!);
    }
    return null;
  }

  String? _speaker(Shloka? current, ReadingLanguage language) {
    if (language.assisted && assisted != null) {
      return 'Reading aid, from the short English. It is not an acharya translation.';
    }
    if (current == null || language.code == 'sa') return null;
    final voices = current.inLanguage(language.code);
    for (final voice in voices) {
      if (voice.hasTranslation) return voice.author;
    }
    return null;
  }

  Widget _voiceList(Shloka current, String code) {
    final voices = current.inLanguage(code);
    if (voices.isEmpty) {
      return const Text('No voice in this language for this shloka. Try Sanskrit or English.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Acharyas from the Bhagavad Gita API', style: TextStyle(color: kMuted)),
        const SizedBox(height: 8),
        for (final voice in voices) ...[
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardOf(context),
              borderRadius: BorderRadius.circular(18),
              boxShadow: softShadow(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(voice.author, style: const TextStyle(fontWeight: FontWeight.w800, color: kSaffron)),
                if (voice.hasTranslation) ...[
                  const SizedBox(height: 8),
                  const Text('Translation', style: TextStyle(color: kMuted, fontSize: 12)),
                  const SizedBox(height: 4),
                  ExpandableText(voice.translation!),
                ],
                if (voice.hasCommentary) ...[
                  const SizedBox(height: 8),
                  const Text('Commentary', style: TextStyle(color: kMuted, fontSize: 12)),
                  const SizedBox(height: 4),
                  ExpandableText(voice.commentary!),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
