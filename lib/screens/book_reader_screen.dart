import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models.dart';
import '../reader_audio.dart';
import '../theme.dart';
import '../widgets.dart';
import 'settings_screen.dart';

class BookReaderScreen extends StatefulWidget {
  const BookReaderScreen({
    super.key,
    required this.id,
    required this.title,
    required this.path,
    required this.kind,
  });

  final String id;
  final String title;
  final String path;
  final String kind;

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  String? text;
  String? error;
  bool loading = true;
  bool showControls = true;
  late ReaderAudio audio;

  bool get readable => widget.kind == 'txt' || widget.kind == 'html';

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
    if (!readable) {
      setState(() => loading = false);
      return;
    }
    try {
      String raw;
      if (widget.path.startsWith('assets/')) {
        final byteData = await rootBundle.load(widget.path);
        raw = utf8.decode(byteData.buffer.asUint8List(), allowMalformed: true);
      } else {
        final file = File(widget.path);
        if (!await file.exists()) {
          throw Exception('The kept file is missing.');
        }
        raw = await file.readAsString();
      }
      if (widget.kind == 'html') raw = _stripHtml(raw);
      if (raw.length > 400000) {
        raw = '${raw.substring(0, 400000)}\n\nShowing the first part of a long text.';
      }
      if (!mounted) return;
      setState(() {
        text = raw.trim();
        loading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<AppState>().remember(
              ReadingSpot(
                title: widget.title,
                subtitle: 'Kept on this phone',
                chapter: 0,
                verse: 0,
                progress: 0.5,
                kind: 'book',
                bookId: canonicalId,
                bookPath: widget.path,
                bookKind: widget.kind,
              ),
            );
      });
    } catch (err) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = err.toString();
      });
    }
  }

  String get canonicalId => widget.id.startsWith('book-') ? widget.id : 'book-${widget.id}';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final sound = context.watch<ReaderAudio>();
    final id = canonicalId;
    final body = text;
    final mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: paperOf(context),
      appBar: showControls
          ? AppBar(
              backgroundColor: paperOf(context),
              surfaceTintColor: Colors.transparent,
              title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis),
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
            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    28,
                    showControls ? 8 : (16 + mq.padding.top),
                    28,
                    showControls ? 120 : (24 + mq.padding.bottom),
                  ),
                  children: [
                    if (loading) const LinearProgressIndicator(color: kSaffron),
                    if (!readable)
                      const Text(
                        'This file is kept on the phone. Vedamrit reads plain text and HTML here. EPUB and PDF stay in the app folder for you to keep.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, height: 1.45),
                      ),
                    if (error != null) Text(error!, textAlign: TextAlign.center),
                    if (body != null)
                      SelectableText(
                        body,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, height: 1.7, color: inkOf(context)),
                        onTap: () {
                          if (state.tapToToggleUi) {
                            setState(() => showControls = !showControls);
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
            if (showControls)
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
                        title: widget.title,
                        subtitle: 'Kept on this phone',
                        bookPath: widget.path,
                        bookKind: widget.kind,
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
                  onPlay: body == null || body.isEmpty ? null : () => audio.toggle(id, [SpeechBit(body, state.spokenLocale)]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<script[\s\S]*?</script>', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'<style[\s\S]*?</style>', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll(RegExp(r'[ \t]{2,}'), ' ')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }
}
