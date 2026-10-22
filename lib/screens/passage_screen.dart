import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models.dart';
import '../reader_audio.dart';
import '../theme.dart';
import '../widgets.dart';
import 'settings_screen.dart';

class PassageScreen extends StatefulWidget {
  const PassageScreen({super.key, required this.passage, this.libraryQuery});

  final Passage passage;
  final String? libraryQuery;

  @override
  State<PassageScreen> createState() => _PassageScreenState();
}

class _PassageScreenState extends State<PassageScreen> {
  late ReaderAudio audio;
  bool showControls = true;

  @override
  void initState() {
    super.initState();
    audio = context.read<ReaderAudio>();
    audio.speed = context.read<AppState>().speed;
  }

  @override
  void dispose() {
    audio.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final sound = context.watch<ReaderAudio>();
    final passage = widget.passage;
    final id = 'passage-${passage.id}';
    final bits = <SpeechBit>[
      if (passage.sanskrit.trim().isNotEmpty) SpeechBit(passage.sanskrit, 'hi-IN'),
      if (state.showTransliteration && passage.transliteration.trim().isNotEmpty) SpeechBit(passage.transliteration, 'en-IN'),
      if (passage.meaning.trim().isNotEmpty) SpeechBit(passage.meaning, state.spokenLocale),
    ];
    return Scaffold(
      backgroundColor: paperOf(context),
      appBar: showControls
          ? AppBar(
              backgroundColor: paperOf(context),
              surfaceTintColor: Colors.transparent,
              title: Text(passage.title),
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
            ListView(
              padding: EdgeInsets.fromLTRB(20, showControls ? 8 : (16 + MediaQuery.paddingOf(context).top), 20, 120),
              children: [
              if (passage.sanskrit.trim().isNotEmpty)
                Text(passage.sanskrit, style: const TextStyle(fontSize: 26, height: 1.5, fontWeight: FontWeight.w700)),
              if (state.showTransliteration && passage.transliteration.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(passage.transliteration, style: const TextStyle(color: kMuted, height: 1.4)),
              ],
              const SizedBox(height: 16),
              Text(passage.meaning, style: const TextStyle(fontSize: 17, height: 1.5)),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Sanskrit Documents Archive (sanskritdocuments.org)',
                  style: TextStyle(color: kMuted, fontSize: 12),
                ),
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
                      Bookmark(
                        id: id,
                        kind: 'passage',
                        title: passage.title,
                        subtitle: passage.meaning,
                        passageId: passage.id,
                        sanskrit: passage.sanskrit,
                        transliteration: passage.transliteration,
                        meaning: passage.meaning,
                      ),
                    );
                  },
                  onPlay: bits.isEmpty ? null : () => audio.toggle(id, bits),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
