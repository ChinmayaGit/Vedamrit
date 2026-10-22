import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
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
  int currentPage = 0;
  int totalPages = 0;
  bool pdfReady = false;
  late ReaderAudio audio;

  bool get isPdf => widget.kind.toLowerCase() == 'pdf';
  bool get readable => widget.kind == 'txt' || widget.kind == 'html' || isPdf;

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

    if (isPdf) {
      try {
        if (!widget.path.startsWith('assets/')) {
          final file = File(widget.path);
          if (!await file.exists()) {
            throw Exception('The kept PDF file is missing.');
          }
        }
        if (!mounted) return;
        setState(() => loading = false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          context.read<AppState>().remember(
                ReadingSpot(
                  title: widget.title,
                  subtitle: 'Kept PDF on this phone',
                  chapter: 0,
                  verse: 0,
                  progress: 0.0,
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
    final isTest = Platform.environment.containsKey('FLUTTER_TEST');

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
                if (!isPdf) const PageTools(),
              ],
            )
          : null,
      body: Stack(
        children: [
          if (loading)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(color: kSaffron),
            ),
          if (error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
              ),
            )
          else if (!readable)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: const Text(
                    'This file is kept on the phone. Vedamrit reads plain text, HTML, and PDF here. EPUB stays in the app folder for you to keep.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, height: 1.45),
                  ),
                ),
              ),
            )
          else if (isPdf)
            Positioned.fill(
              child: isTest
                  ? Container(
                      key: const Key('pdfViewPlaceholder'),
                      color: paperOf(context),
                      alignment: Alignment.center,
                      child: Text('PDF: ${widget.title}', style: TextStyle(color: inkOf(context))),
                    )
                  : PDFView(
                      filePath: widget.path,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: true,
                      pageFling: true,
                      pageSnap: true,
                      fitPolicy: FitPolicy.WIDTH,
                      onRender: (pages) {
                        if (!mounted) return;
                        setState(() {
                          totalPages = pages ?? 0;
                          pdfReady = true;
                        });
                      },
                      onPageChanged: (page, total) {
                        if (!mounted) return;
                        final current = page ?? 0;
                        final count = total ?? totalPages;
                        setState(() {
                          currentPage = current;
                          totalPages = count;
                        });
                        final progress = (count > 1) ? (current / (count - 1)) : 0.0;
                        context.read<AppState>().remember(
                              ReadingSpot(
                                title: widget.title,
                                subtitle: count > 0 ? 'Page ${current + 1} of $count' : 'Kept PDF on this phone',
                                chapter: current,
                                verse: 0,
                                progress: progress.clamp(0.0, 1.0),
                                kind: 'book',
                                bookId: canonicalId,
                                bookPath: widget.path,
                                bookKind: widget.kind,
                              ),
                            );
                      },
                      onError: (err) {
                        if (!mounted) return;
                        setState(() => error = err.toString());
                      },
                      onPageError: (page, err) {
                        if (!mounted) return;
                        setState(() => error = 'Page $page: $err');
                      },
                    ),
            )
          else
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (state.tapToToggleUi) {
                  setState(() => showControls = !showControls);
                }
              },
              child: Align(
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
            ),
          if (isPdf && totalPages > 0 && showControls)
            Positioned(
              top: 12,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${currentPage + 1} / $totalPages',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (!showControls)
            Positioned(
              top: 16 + mq.padding.top,
              right: 16,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => showControls = true),
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
                      subtitle: isPdf
                          ? (totalPages > 0 ? 'Page ${currentPage + 1} of $totalPages' : 'PDF on this phone')
                          : 'Kept on this phone',
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
                onPlay: (body == null || body.isEmpty)
                    ? null
                    : () => audio.toggle(id, [SpeechBit(body, state.spokenLocale)]),
              ),
            ),
        ],
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
