import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'catalog.dart';
import 'models.dart';

class ReaderAudio extends ChangeNotifier {
  FlutterTts? _tts;
  bool _closed = false;
  bool playing = false;
  double speed = 1;
  String? activeId;
  bool _stopRequested = false;
  int _index = 0;
  final List<SpeechBit> _pieces = [];

  Future<void> toggle(String id, List<SpeechBit> bits) async {
    if (activeId == id && playing) {
      await pause();
      return;
    }
    if (activeId == id && !playing && _pieces.isNotEmpty && _index < _pieces.length) {
      playing = true;
      _stopRequested = false;
      _notify();
      await _speakCurrent();
      return;
    }
    await start(id, bits);
  }

  Future<void> start(String id, List<SpeechBit> bits) async {
    await _ensure();
    _stopRequested = true;
    await _tts?.stop();
    _stopRequested = false;
    _pieces
      ..clear()
      ..addAll(_expand(bits));
    if (_pieces.isEmpty) return;
    activeId = id;
    _index = 0;
    playing = true;
    _notify();
    await _speakCurrent();
  }

  Future<void> pause() async {
    _stopRequested = true;
    playing = false;
    await _tts?.stop();
    _notify();
  }

  Future<void> stop() async {
    _stopRequested = true;
    playing = false;
    _index = 0;
    _pieces.clear();
    activeId = null;
    await _tts?.stop();
    _notify();
  }

  void _notify() {
    if (_closed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _closed = true;
    super.dispose();
  }

  Future<void> setSpeed(double value) async {
    speed = (value.clamp(0.2, 3.0) * 10).round() / 10;
    try {
      await _tts?.setSpeechRate(_rate);
    } catch (_) {}
    _notify();
  }

  Future<void> _ensure() async {
    if (_tts != null) return;
    final engine = FlutterTts();
    await engine.setSpeechRate(_rate);
    await engine.setVolume(1);
    await engine.setPitch(1);
    engine.setCompletionHandler(() {
      if (_stopRequested || !playing) return;
      _index += 1;
      _speakCurrent();
    });
    engine.setErrorHandler((_) {
      if (_stopRequested) return;
      playing = false;
      _notify();
    });
    engine.setCancelHandler(() {
      if (_stopRequested) return;
    });
    _tts = engine;
  }

  Future<void> _speakCurrent() async {
    final engine = _tts;
    if (!playing || engine == null || _index >= _pieces.length) {
      playing = false;
      _notify();
      return;
    }
    final piece = _pieces[_index];
    var locale = piece.locale.replaceAll('_', '-').trim();
    if (locale.startsWith('sa')) {
      locale = 'hi-IN';
    } else if (!locale.contains('-')) {
      locale = ttsLocale(locale);
    }
    try {
      await engine.setLanguage(locale);
    } catch (_) {}
    final spoken = _withoutNumbers(piece.text);
    if (spoken.isEmpty) {
      _index += 1;
      await _speakCurrent();
      return;
    }
    try {
      await engine.setSpeechRate(_rate);
      await engine.speak(spoken);
    } catch (_) {
      playing = false;
      _notify();
    }
  }

  double get _rate {
    final t = ((speed - 0.2) / 2.8).clamp(0.0, 1.0);
    if (defaultTargetPlatform == TargetPlatform.iOS) return 0.2 + t * 0.55;
    return 0.1 + t * 1.4;
  }

  String _withoutNumbers(String text) {
    var clean = text.replaceAll(RegExp(r'\|+'), ' ');
    clean = clean.replaceAll(RegExp(r'[०-९]+'), ' ');
    clean = clean.replaceAll(RegExp(r'\b\d+\s*[-–—.]\s*\d+\b'), ' ');
    clean = clean.replaceAll(RegExp(r'\s+[-–—]+\s+'), ' ');
    return clean.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  List<SpeechBit> _expand(List<SpeechBit> bits) {
    final pieces = <SpeechBit>[];
    for (final bit in bits) {
      for (final part in _split(bit.text)) {
        pieces.add(SpeechBit(part, bit.locale));
      }
    }
    return pieces;
  }

  List<String> _split(String text) {
    final clean = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (clean.isEmpty) return [];
    const size = 280;
    final parts = <String>[];
    var start = 0;
    while (start < clean.length) {
      var end = start + size;
      if (end >= clean.length) {
        final tail = clean.substring(start).trim();
        if (tail.isNotEmpty) parts.add(tail);
        break;
      }
      final slice = clean.substring(start, end);
      final breaks = [slice.lastIndexOf('।'), slice.lastIndexOf('.'), slice.lastIndexOf(' '), slice.lastIndexOf(',')];
      var cut = breaks.reduce((a, b) => a > b ? a : b);
      if (cut < 40) cut = size - 1;
      end = start + cut + 1;
      final part = clean.substring(start, end).trim();
      if (part.isNotEmpty) parts.add(part);
      start = end;
    }
    return parts;
  }
}
