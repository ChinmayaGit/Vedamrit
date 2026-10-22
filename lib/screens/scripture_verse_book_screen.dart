import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models.dart';
import '../reader_audio.dart';
import '../sanskrit_documents_data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'gita_book_screen.dart';
import 'settings_screen.dart';

/// Renders any sacred scripture using the exact Gita pattern:
/// - Heading & Context
/// - Chapter / Verse Number badge
/// - In Sanskrit (Devanagari)
/// - Transliteration (IAST with diacritics)
/// - Translation in selected language (dynamic multi-language translation via assist)
/// - Original language translation (authoritative English)
class ScriptureVerseBookScreen extends StatefulWidget {
  const ScriptureVerseBookScreen({super.key, required this.book});

  final SacredVerseBook book;

  @override
  State<ScriptureVerseBookScreen> createState() => _ScriptureVerseBookScreenState();
}

class _ScriptureVerseBookScreenState extends State<ScriptureVerseBookScreen> {
  final Map<int, String> _translations = {};
  bool _showControls = true;
  String? _loadedLang;
  int _token = 0;
  late ReaderAudio _audio;

  @override
  void initState() {
    super.initState();
    _audio = context.read<ReaderAudio>();
    _audio.speed = context.read<AppState>().speed;
    _prepare();
  }

  @override
  void dispose() {
    _audio.stop();
    super.dispose();
  }

  void _prepare() {
    _token++;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _recordReadingSpot();
      _loadTranslations();
    });
  }

  void _recordReadingSpot() {
    context.read<AppState>().remember(
          ReadingSpot(
            title: widget.book.title,
            subtitle: widget.book.sanskritTitle,
            chapter: 1,
            verse: 1,
            progress: 0.0,
            kind: 'verse_book',
            bookId: widget.book.id,
          ),
        );
  }

  Future<void> _loadTranslations() async {
    final token = _token;
    final state = context.read<AppState>();
    final lang = state.language;
    _loadedLang = lang;

    if (mounted && _translations.isNotEmpty) {
      setState(_translations.clear);
    }

    if (lang == 'en' || lang == 'sa') return;

    final verses = widget.book.verses;
    const batch = 3;
    for (var i = 0; i < verses.length; i += batch) {
      if (!mounted || token != _token) return;
      final slice = verses.skip(i).take(batch);
      await Future.wait(
        slice.map((v) async {
          try {
            final translated = await state.api.assist(
              lang,
              100 + (widget.book.id.hashCode.abs() % 800),
              v.number,
              v.originalTranslation,
            );
            if (!mounted || token != _token || translated.isEmpty) return;
            setState(() => _translations[v.number] = translated);
          } catch (_) {}
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final sound = context.watch<ReaderAudio>();
    final id = 'scripture-${widget.book.id}';
    final mq = MediaQuery.of(context);

    if (_loadedLang != state.language) {
      final lang = state.language;
      _loadedLang = lang;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || context.read<AppState>().language != lang) return;
        _loadTranslations();
      });
    }

    return Scaffold(
      backgroundColor: paperOf(context),
      appBar: _showControls
          ? AppBar(
              backgroundColor: paperOf(context),
              surfaceTintColor: Colors.transparent,
              title: Text(widget.book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              actions: [
                IconButton(
                  tooltip: 'Fullscreen',
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () => setState(() => _showControls = false),
                ),
                const PageTools(),
              ],
            )
          : null,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (state.tapToToggleUi) {
            setState(() => _showControls = !_showControls);
          }
        },
        child: Stack(
          children: [
            BookPage(
              children: [
                // 1. Heading
                Text(
                  '॥ ${widget.book.sanskritTitle} ॥',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: kSaffron, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.book.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.2, color: inkOf(context)),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.book.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: kMuted, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: kSaffron.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kSaffron.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'SanskritDocuments.org · ${widget.book.category.toUpperCase()}',
                      style: const TextStyle(color: kSaffron, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // 2. Verses loop following Gita pattern
                for (final verse in widget.book.verses) ...[
                  // Chapter / Verse Number
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: kSaffron.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '॥ ${verse.label} ॥',
                        style: const TextStyle(color: kSaffron, fontWeight: FontWeight.w800, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // In Sanskrit
                  Text(
                    verse.sanskrit,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      height: 1.85,
                      fontWeight: FontWeight.w600,
                      color: inkOf(context),
                    ),
                  ),

                  // Transliteration (IAST)
                  if (state.showTransliteration && verse.iast.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      verse.iast,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: kMuted,
                        fontSize: 15,
                        height: 1.55,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],

                  // Translation Language Selected
                  if (_translations[verse.number] != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _translations[verse.number]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.6,
                        color: inkOf(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  // Original Language Translated (Authoritative English)
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardOf(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          verse.originalTranslation,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.55,
                            color: inkOf(context).withValues(alpha: 0.85),
                          ),
                        ),
                        if (verse.commentary != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            verse.commentary!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: kMuted, fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Quick Voice / Bookmark row per verse
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        tooltip: 'Listen to Verse & Translation',
                        icon: const Icon(Icons.volume_up_outlined, size: 20, color: kMuted),
                        onPressed: () {
                          final tr = _translations[verse.number] ?? verse.originalTranslation;
                          _audio.toggle(
                            '$id-${verse.number}',
                            [
                              SpeechBit(verse.sanskrit, 'hi-IN'),
                              if (tr.trim().isNotEmpty) SpeechBit(tr, state.spokenLocale),
                            ],
                          );
                        },
                      ),
                      IconButton(
                        tooltip: 'Bookmark',
                        icon: Icon(
                          state.bookmarked('$id-${verse.number}') ? Icons.bookmark : Icons.bookmark_border,
                          size: 20,
                          color: state.bookmarked('$id-${verse.number}') ? kSaffron : kMuted,
                        ),
                        onPressed: () {
                          final vId = '$id-${verse.number}';
                          final willAdd = !state.bookmarked(vId);
                          state.toggleBookmark(
                            Bookmark(
                              id: vId,
                              kind: 'verse',
                              title: '${widget.book.title} ${verse.label}',
                              subtitle: verse.sanskrit.split('\n').first,
                              sanskrit: verse.sanskrit,
                              transliteration: verse.iast,
                              meaning: verse.originalTranslation,
                            ),
                          );
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(willAdd ? 'Verse Bookmarked' : 'Bookmark Removed'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // Footer note
                const Divider(color: kSaffron, thickness: 1, indent: 80, endIndent: 80),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Sanskrit Documents Archive · ${widget.book.sourceUrl}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: kMuted, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),

            // Floating exit fullscreen button when controls are hidden
            if (!_showControls)
              Positioned(
                top: 16 + mq.padding.top,
                right: 16,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(() => _showControls = true),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.fullscreen_exit, color: Colors.white, size: 22),
                    ),
                  ),
                ),
              ),

            // Bottom ReaderDock
            if (_showControls)
              Positioned(
                left: 16,
                right: 16,
                bottom: 16 + mq.padding.bottom,
                child: ReaderDock(
                  bookmarked: state.bookmarked(id),
                  playing: sound.playing && sound.activeId == id,
                  speed: sound.speed,
                  onBookmark: () {
                    final willAdd = !state.bookmarked(id);
                    state.toggleBookmark(
                      Bookmark(
                        id: id,
                        kind: 'book',
                        title: widget.book.title,
                        subtitle: widget.book.sanskritTitle,
                      ),
                    );
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(willAdd ? 'Added to Bookmarks' : 'Removed from Bookmarks'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onPlay: () {
                    final speechBits = <SpeechBit>[];
                    for (final v in widget.book.verses) {
                      speechBits.add(SpeechBit(v.sanskrit, 'hi-IN'));
                      final tr = _translations[v.number] ?? v.originalTranslation;
                      if (tr.trim().isNotEmpty) {
                        speechBits.add(SpeechBit(tr, state.spokenLocale));
                      }
                    }
                    _audio.toggle(id, speechBits);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
