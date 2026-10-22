/// High-fidelity transcription & script converter for Sanskrit texts.
/// Replicates the transcription methods used by SanskritDocuments.org and Aksharamukha:
/// - Devanagari to IAST (International Alphabet of Sanskrit Transliteration with diacritics)
/// - ITRANS to Devanagari & IAST
/// - Devanagari to other Indic scripts (Telugu, Tamil, Kannada, Malayalam, Bengali, Gujarati, Odia, Gurmukhi)
class SanskritTranscriber {
  static const Map<String, String> _vowels = {
    'अ': 'a',
    'आ': 'ā',
    'इ': 'i',
    'ई': 'ī',
    'उ': 'u',
    'ऊ': 'ū',
    'ऋ': 'ṛ',
    'ॠ': 'ṝ',
    'ऌ': 'ḷ',
    'ॡ': 'ḹ',
    'ए': 'e',
    'ऐ': 'ai',
    'ओ': 'o',
    'औ': 'au',
  };

  static const Map<String, String> _matras = {
    'ा': 'ā',
    'ि': 'i',
    'ी': 'ī',
    'ु': 'u',
    'ू': 'ū',
    'ृ': 'ṛ',
    'ॄ': 'ṝ',
    'ॢ': 'ḷ',
    'ॣ': 'ḹ',
    'े': 'e',
    'ै': 'ai',
    'ो': 'o',
    'ौ': 'au',
  };

  static const Map<String, String> _consonants = {
    'क': 'k',
    'ख': 'kh',
    'ग': 'g',
    'घ': 'gh',
    'ङ': 'ṅ',
    'च': 'c',
    'छ': 'ch',
    'ज': 'j',
    'झ': 'jh',
    'ञ': 'ñ',
    'ट': 'ṭ',
    'ठ': 'ṭh',
    'ड': 'ḍ',
    'ढ': 'ḍh',
    'ण': 'ṇ',
    'त': 't',
    'थ': 'th',
    'द': 'd',
    'ध': 'dh',
    'न': 'n',
    'प': 'p',
    'फ': 'ph',
    'ब': 'b',
    'भ': 'bh',
    'म': 'm',
    'य': 'y',
    'र': 'r',
    'ल': 'l',
    'ळ': 'ḷ',
    'व': 'v',
    'श': 'ś',
    'ष': 'ṣ',
    'स': 's',
    'ह': 'h',
  };

  static const Map<String, String> _symbols = {
    'ं': 'ṁ',
    'ः': 'ḥ',
    'ँ': 'm̐',
    'ऽ': '\'',
    '।': '|',
    '॥': '||',
    '०': '0',
    '१': '1',
    '२': '2',
    '३': '3',
    '४': '4',
    '५': '5',
    '६': '6',
    '७': '7',
    '८': '8',
    '९': '9',
    'ॐ': 'om',
  };

  /// Strips Vedic accent marks like svara/udatta/anudatta for pristine transliteration.
  static String cleanAccents(String text) {
    return text.replaceAll(RegExp(r'[\u0951\u0952\u1CDA\u093C\u1CD0-\u1CFF\u0900]'), '');
  }

  /// Converts Devanagari Sanskrit text into high-fidelity IAST Roman script.
  static String toIast(String devanagari) {
    if (devanagari.trim().isEmpty) return '';
    final cleaned = cleanAccents(devanagari);
    final runes = cleaned.runes.toList();
    final buffer = StringBuffer();
    final len = runes.length;

    for (var i = 0; i < len; i++) {
      final ch = String.fromCharCode(runes[i]);

      if (_vowels.containsKey(ch)) {
        buffer.write(_vowels[ch]);
        continue;
      }

      if (_symbols.containsKey(ch)) {
        buffer.write(_symbols[ch]);
        continue;
      }

      if (_consonants.containsKey(ch)) {
        final base = _consonants[ch]!;
        if (i + 1 < len) {
          final next = String.fromCharCode(runes[i + 1]);
          if (next == '्') {
            // Virama: omit inherent 'a'
            buffer.write(base);
            i++;
            continue;
          }
          if (_matras.containsKey(next)) {
            buffer.write(base);
            buffer.write(_matras[next]);
            i++;
            continue;
          }
        }
        buffer.write('${base}a');
        continue;
      }

      if (_matras.containsKey(ch)) {
        buffer.write(_matras[ch]);
        continue;
      }

      buffer.write(ch);
    }

    return buffer
        .toString()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(' |', ' |')
        .replaceAll(' ||', ' ||')
        .trim();
  }

  /// Transliterates Devanagari to Indic scripts (Telugu, Tamil, Kannada, Malayalam, Bengali, Gujarati)
  /// using standard Brahmic block mappings.
  static String toIndicScript(String devanagari, String scriptCode) {
    final offset = _scriptOffset(scriptCode);
    if (offset == null) return devanagari;

    final runes = cleanAccents(devanagari).runes.toList();
    final buffer = StringBuffer();

    for (final rune in runes) {
      if (rune >= 0x0901 && rune <= 0x0970) {
        final mapped = rune + offset;
        buffer.writeCharCode(mapped);
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  static int? _scriptOffset(String code) {
    switch (code) {
      case 'bn':
        return 0x0080; // Bengali
      case 'pa':
        return 0x0100; // Gurmukhi
      case 'gu':
        return 0x0180; // Gujarati
      case 'or':
        return 0x0200; // Odia
      case 'ta':
        return 0x0280; // Tamil
      case 'te':
        return 0x0300; // Telugu
      case 'kn':
        return 0x0380; // Kannada
      case 'ml':
        return 0x0400; // Malayalam
      default:
        return null;
    }
  }

  /// Converts standard ITRANS text (used in SanskritDocuments .itx files) to Devanagari.
  static String fromItrans(String itrans) {
    var s = itrans;
    const itransMap = [
      ('R^i', 'ऋ'),
      ('R^I', 'ॠ'),
      ('L^i', 'ऌ'),
      ('L^I', 'ॡ'),
      ('aa', 'आ'),
      ('A', 'आ'),
      ('ii', 'ई'),
      ('I', 'ई'),
      ('uu', 'ऊ'),
      ('U', 'ऊ'),
      ('ai', 'ऐ'),
      ('au', 'औ'),
      ('OM', 'ॐ'),
      ('kSh', 'क्ष'),
      ('x', 'क्ष'),
      ('j~n', 'ज्ञ'),
      ('GY', 'ज्ञ'),
      ('kh', 'ख'),
      ('gh', 'घ'),
      ('~N', 'ङ'),
      ('ch', 'च'),
      ('Ch', 'छ'),
      ('chh', 'छ'),
      ('jh', 'झ'),
      ('~n', 'ञ'),
      ('Th', 'ठ'),
      ('Dh', 'ढ'),
      ('th', 'थ'),
      ('dh', 'ध'),
      ('ph', 'फ'),
      ('bh', 'भ'),
      ('sh', 'श'),
      ('Sh', 'ष'),
      ('shh', 'ष'),
      ('T', 'ट'),
      ('D', 'ड'),
      ('N', 'ण'),
      ('k', 'क'),
      ('g', 'ग'),
      ('j', 'ज'),
      ('t', 'त'),
      ('d', 'द'),
      ('n', 'न'),
      ('p', 'प'),
      ('b', 'ब'),
      ('m', 'म'),
      ('y', 'य'),
      ('r', 'र'),
      ('l', 'ल'),
      ('v', 'व'),
      ('w', 'व'),
      ('s', 'स'),
      ('h', 'ह'),
      ('L', 'ळ'),
      ('a', 'अ'),
      ('i', 'इ'),
      ('u', 'उ'),
      ('e', 'ए'),
      ('o', 'ओ'),
      ('M', 'ं'),
      ('.n', 'ं'),
      ('H', 'ः'),
    ];

    for (final pair in itransMap) {
      s = s.replaceAll(pair.$1, pair.$2);
    }
    return s;
  }
}

