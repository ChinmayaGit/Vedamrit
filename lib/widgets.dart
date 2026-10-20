import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'phrases.dart';
import 'reader_audio.dart';
import 'theme.dart';

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.light = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: light ? Colors.white : kSaffron,
      borderRadius: BorderRadius.circular(30),
      elevation: darkOf(context) ? 0 : 8,
      shadowColor: liftShadow(context),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: light ? kBlack : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: inkOf(context)),
      ),
    );
  }
}

class CoverCard extends StatelessWidget {
  const CoverCard({
    super.key,
    required this.kicker,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.onTap,
    this.width = 138,
    this.height = 188,
  });

  final String kicker;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        elevation: darkOf(context) ? 0 : 8,
        shadowColor: liftShadow(context),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kicker, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, height: 1.2),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TaskBar extends StatelessWidget {
  const TaskBar({super.key, required this.label, required this.value});

  final String? label;
  final double? value;

  @override
  Widget build(BuildContext context) {
    if (label == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label!, style: const TextStyle(color: kMuted, fontSize: 12)),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: value,
            color: kClay,
            backgroundColor: kSaffron.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  const ExpandableText(this.text, {super.key});

  final String text;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: open ? null : 6,
          overflow: open ? TextOverflow.visible : TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16, height: 1.45, color: inkOf(context)),
        ),
        if (widget.text.length > 220)
          TextButton(
            onPressed: () => setState(() => open = !open),
            child: Text(open ? 'Show less' : 'Read more'),
          ),
      ],
    );
  }
}

class ReaderDock extends StatelessWidget {
  const ReaderDock({
    super.key,
    required this.bookmarked,
    required this.onBookmark,
    required this.speed,
    required this.playing,
    this.onPrevious,
    this.onNext,
    this.onPlay,
  });

  final bool bookmarked;
  final VoidCallback onBookmark;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onPlay;
  final double speed;
  final bool playing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Semantics(
          button: true,
          label: bookmarked ? 'Remove bookmark' : 'Bookmark',
          child: Material(
            color: kSaffron,
            shape: const CircleBorder(),
            elevation: darkOf(context) ? 2 : 8,
            shadowColor: liftShadow(context),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBookmark,
              child: SizedBox(
                width: 58,
                height: 58,
                child: Icon(bookmarked ? Icons.bookmark : Icons.bookmark_border, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Material(
            color: cardOf(context),
            elevation: darkOf(context) ? 0 : 8,
            shadowColor: liftShadow(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: BorderSide(color: darkOf(context) ? const Color(0xFF4A3F36) : Colors.transparent),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                children: [
                  _dockButton(context, Icons.chevron_left, 'Previous', onPrevious),
                  _dockButton(context, playing ? Icons.pause : Icons.play_arrow, playing ? 'Pause reading' : 'Read aloud', onPlay),
                  TextButton(
                    onPressed: () => showSpeedSheet(context),
                    child: Text('${speed.toStringAsFixed(1)}×', style: TextStyle(fontWeight: FontWeight.w800, color: inkOf(context))),
                  ),
                  _dockButton(context, Icons.chevron_right, 'Next', onNext),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dockButton(BuildContext context, IconData icon, String label, VoidCallback? onPressed) {
    return Expanded(
      child: IconButton(
        tooltip: label,
        onPressed: onPressed,
        icon: Icon(icon, color: onPressed == null ? kMuted : inkOf(context)),
      ),
    );
  }
}

Future<void> showSpeedSheet(BuildContext context) {
  final state = context.read<AppState>();
  final audio = context.read<ReaderAudio>();
  var value = state.speed.clamp(0.2, 3.0);
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheet) {
      return StatefulBuilder(
        builder: (context, setLocal) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(phrase(state, 'speed'), style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text('${value.toStringAsFixed(1)}×', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: kSaffron)),
                  Slider(
                    min: 0.2,
                    max: 3,
                    divisions: 28,
                    value: value,
                    activeColor: kSaffron,
                    onChanged: (next) {
                      final stepped = (next * 10).round() / 10;
                      setLocal(() => value = stepped);
                      state.setSpeed(stepped);
                      audio.setSpeed(stepped);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

void showNotice(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
