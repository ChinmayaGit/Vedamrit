class SacredWork {
  final String id;
  final String section;
  final String title;
  final String credit;
  final String kind;
  final String? assetPath;
  final String? gutenberg;
  final String? query;
  final String? verseBookId;

  const SacredWork({
    required this.id,
    required this.section,
    required this.title,
    required this.credit,
    required this.kind,
    this.assetPath,
    this.gutenberg,
    this.query,
    this.verseBookId,
  });
}

const scriptureSections = <(String, String, String)>[
  ('vedas', 'Vedas', 'The Four Vedas'),
  ('gita', 'Gita', 'The Bhagavad Gita'),
  ('upanishads', 'Upanishads', 'Vedanta texts'),
  ('puranas', 'Puranas', 'The sacred Puranas'),
  ('epics', 'Epics', 'The great epics'),
  ('shastras', 'Shastras', 'Sutras and shastras'),
  ('yoga', 'Yoga', 'Yoga philosophy'),
  ('vedanta', 'Vedanta', 'Brahma Sutras and Advaita'),
  ('prasthanatrayi', 'Prasthanatrayi', 'The Three Foundations'),
  ('tantra', 'Tantra', 'Agamas and Tantras'),
  ('smriti', 'Smriti', 'Dharma and Smritis'),
];

const fortyVerses = <(int, int)>[
  (2, 47),
  (2, 20),
  (2, 22),
  (2, 27),
  (2, 50),
  (2, 62),
  (3, 19),
  (3, 27),
  (3, 35),
  (4, 7),
  (4, 8),
  (4, 11),
  (4, 24),
  (5, 10),
  (5, 18),
  (6, 5),
  (6, 26),
  (6, 30),
  (6, 35),
  (7, 7),
  (7, 19),
  (8, 5),
  (9, 22),
  (9, 26),
  (9, 27),
  (10, 20),
  (11, 32),
  (11, 55),
  (12, 13),
  (12, 15),
  (13, 28),
  (14, 26),
  (15, 7),
  (16, 21),
  (17, 3),
  (18, 46),
  (18, 54),
  (18, 61),
  (18, 66),
  (18, 78),
];

const scriptureWorks = <SacredWork>[
  // --------------------------------------------------------------------------
  // 1. 4 VEDAS (https://sanskritdocuments.org/sanskrit/veda)
  // --------------------------------------------------------------------------
  SacredWork(
    id: 'rig-agni-suktam',
    section: 'vedas',
    title: 'Rig Veda: Agni Suktam (1.1)',
    credit: 'Complete 9 mantras with Sanskrit in Devanagari, IAST transliteration, selected language & English translation.',
    kind: 'verse_book',
    verseBookId: 'rig-agni-suktam',
  ),
  SacredWork(
    id: 'rig-purusha-suktam',
    section: 'vedas',
    title: 'Rig Veda: Purusha Suktam (10.90)',
    credit: 'The Cosmic Hymn of Creation with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'rig-purusha-suktam',
  ),
  SacredWork(
    id: 'sama-veda-gana',
    section: 'vedas',
    title: 'Sama Veda: Chhanda Archika',
    credit: 'Agneya Parva & sacred melodies with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'sama-veda-gana',
  ),
  SacredWork(
    id: 'yajur-shukla-isha',
    section: 'vedas',
    title: 'Shukla Yajur Veda: Vajasaneyi Samhita',
    credit: 'Chapter 40 (Ishavasya) with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'yajur-shukla-isha',
  ),
  SacredWork(
    id: 'yajur-krishna-taittiriya',
    section: 'vedas',
    title: 'Krishna Yajur Veda: Sri Rudram',
    credit: 'Taittiriya Samhita 4.5 (Namakam) with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'yajur-krishna-taittiriya',
  ),
  SacredWork(
    id: 'atharva-veda-prithvi',
    section: 'vedas',
    title: 'Atharva Veda: Bhumi Suktam (12.1)',
    credit: 'Hymn to Mother Earth with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'atharva-veda-prithvi',
  ),
  SacredWork(
    id: 'veda-sacred-mantras',
    section: 'vedas',
    title: 'Foundational Vedic Mantras',
    credit: 'Gayatri, Mahamrityunjaya, Pavamana & Shanti Mantras with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'veda-sacred-mantras',
  ),

  // --------------------------------------------------------------------------
  // GITA
  // --------------------------------------------------------------------------
  SacredWork(
    id: 'gita-verses',
    section: 'gita',
    title: 'The Bhagavad Gita',
    credit: 'All 18 chapters · 700 Shlokas. Sanskrit in Devanagari, IAST, selected language & English translation.',
    kind: 'chapters',
  ),
  SacredWork(
    id: 'song-celestial',
    section: 'gita',
    title: 'The Song Celestial',
    credit: 'Verse translation by Sir Edwin Arnold, 1885. Full English poetic rendering.',
    kind: 'song',
  ),
  SacredWork(
    id: 'gita-forty',
    section: 'gita',
    title: 'The Gita in a nutshell',
    credit: 'Forty shlokas, Sanskrit and English, as a short path through the book.',
    kind: 'forty',
  ),
  SacredWork(
    id: 'gita-prose',
    section: 'gita',
    title: 'The Bhagavad Gita — chapter view',
    credit: 'Each shloka in Sanskrit, with the English reading beside it.',
    kind: 'chapters',
  ),

  // --------------------------------------------------------------------------
  // 2. UPANISHADS (https://sanskritdocuments.org/upanishhat)
  // --------------------------------------------------------------------------
  SacredWork(
    id: 'upanishad-isha',
    section: 'upanishads',
    title: 'Isha Upanishad (ईशावास्योपनिषत्)',
    credit: 'Complete 18 verses. Sanskrit in Devanagari, IAST transliteration, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'upanishad-isha',
  ),
  SacredWork(
    id: 'upanishad-mandukya',
    section: 'upanishads',
    title: 'Mandukya Upanishad (माण्डूक्योपनिषत्)',
    credit: 'All 12 mantras on OM and the 4 states of consciousness (Turiya). Sanskrit, IAST & translation.',
    kind: 'verse_book',
    verseBookId: 'upanishad-mandukya',
  ),
  SacredWork(
    id: 'upanishad-katha',
    section: 'upanishads',
    title: 'Katha Upanishad (कठोपनिषत्)',
    credit: 'Dialogue of Nachiketa and Yama on Immortality. Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'upanishad-katha',
  ),
  SacredWork(
    id: 'upanishad-kena',
    section: 'upanishads',
    title: 'Kena Upanishad (केनोपनिषत्)',
    credit: 'The Nature of Brahman & Consciousness. Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'upanishad-kena',
  ),
  SacredWork(
    id: 'upanishad-taittiriya',
    section: 'upanishads',
    title: 'Taittiriya Upanishad (तैत्तिरीयोपनिषत्)',
    credit: 'Shikshavalli & Brahmanandavalli. Truth, Consciousness & Bliss.',
    kind: 'verse_book',
    verseBookId: 'upanishad-taittiriya',
  ),

  // --------------------------------------------------------------------------
  // 3. PURANAS (https://sanskritdocuments.org/doc_purana)
  // --------------------------------------------------------------------------
  SacredWork(
    id: 'purana-bhagavatam',
    section: 'puranas',
    title: 'Srimad Bhagavatam (श्रीमद्भागवतम्)',
    credit: 'Foundational shlokas across the 12 Skandhas with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'purana-bhagavatam',
  ),
  SacredWork(
    id: 'purana-vishnu',
    section: 'puranas',
    title: 'Vishnu Purana (विष्णुपुराणम्)',
    credit: 'Creation and Vishnu Tattva with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'purana-vishnu',
  ),
  SacredWork(
    id: 'purana-shiva',
    section: 'puranas',
    title: 'Shiva Purana (शिवपुराणम्)',
    credit: 'Vidyeshvara Samhita & Shiva Tattva with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'purana-shiva',
  ),
  SacredWork(
    id: 'purana-garuda',
    section: 'puranas',
    title: 'Garuda Purana (गरुडपुराणम्)',
    credit: 'Saroddhara on Karma, Soul and Dharma with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'purana-garuda',
  ),
  SacredWork(
    id: 'purana-devi-mahatmya',
    section: 'puranas',
    title: 'Devi Mahatmya: Durga Saptashati',
    credit: 'Markandeya Purana Narayani Stuti with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'purana-devi-mahatmya',
  ),

  // --------------------------------------------------------------------------
  // 4. ITIHASA (https://sanskritdocuments.org/itihasa)
  // --------------------------------------------------------------------------
  SacredWork(
    id: 'itihasa-ramayana-mula',
    section: 'epics',
    title: 'Valmiki Ramayana: Mula Ramayana',
    credit: 'Bala Kanda Sarga 1. Sanskrit in Devanagari, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'itihasa-ramayana-mula',
  ),
  SacredWork(
    id: 'itihasa-aditya-hridayam',
    section: 'epics',
    title: 'Valmiki Ramayana: Aditya Hridayam',
    credit: 'Yuddha Kanda Sarga 105. Sage Agastya\'s Hymn of Victory to the Sun God.',
    kind: 'verse_book',
    verseBookId: 'itihasa-aditya-hridayam',
  ),
  SacredWork(
    id: 'itihasa-yaksha-prashna',
    section: 'epics',
    title: 'Mahabharata: Yaksha Prashna',
    credit: 'Vana Parva Dharma dialogue of Yudhishthira. Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'itihasa-yaksha-prashna',
  ),
  SacredWork(
    id: 'itihasa-vidura-niti',
    section: 'epics',
    title: 'Mahabharata: Vidura Niti',
    credit: 'Udyoga Parva precepts on Wisdom, Virtue, and Conduct.',
    kind: 'verse_book',
    verseBookId: 'itihasa-vidura-niti',
  ),
  SacredWork(
    id: 'itihasa-bhishma-stuti',
    section: 'epics',
    title: 'Mahabharata: Bhishma Stuti',
    credit: 'Shanti Parva final hymn of Bhishma to Sri Krishna.',
    kind: 'verse_book',
    verseBookId: 'itihasa-bhishma-stuti',
  ),

  // --------------------------------------------------------------------------
  // 5. SHASTRAS (https://sanskritdocuments.org/shastra)
  // --------------------------------------------------------------------------
  SacredWork(
    id: 'shastra-arthashastra',
    section: 'shastras',
    title: 'Kautilya Artha Shastra',
    credit: 'Statecraft and governance sutras. Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'shastra-arthashastra',
  ),
  SacredWork(
    id: 'shastra-apastamba',
    section: 'shastras',
    title: 'Apastamba Dharma Sutra',
    credit: 'Sacred conduct, restraint, and duties. Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'shastra-apastamba',
  ),
  SacredWork(
    id: 'shastra-nyaya-sutras',
    section: 'shastras',
    title: 'Gautama Nyaya Sutras',
    credit: 'The instruments of valid knowledge & liberation. Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'shastra-nyaya-sutras',
  ),

  // --------------------------------------------------------------------------
  // 6. YOGA (https://sanskritdocuments.org/yoga)
  // --------------------------------------------------------------------------
  SacredWork(
    id: 'yoga-patanjali-samadhi',
    section: 'yoga',
    title: 'Patanjali Yoga Sutras: Samadhi Pada',
    credit: 'Foundational Yoga sutras 1.1–1.12 with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'yoga-patanjali-samadhi',
  ),
  SacredWork(
    id: 'yoga-patanjali-sadhana',
    section: 'yoga',
    title: 'Patanjali Yoga Sutras: Sadhana Pada',
    credit: 'Kriya Yoga, Kleshas, and the Eight Limbs of Ashtanga Yoga.',
    kind: 'verse_book',
    verseBookId: 'yoga-patanjali-sadhana',
  ),
  SacredWork(
    id: 'yoga-hatha-pradipika',
    section: 'yoga',
    title: 'Hatha Yoga Pradipika',
    credit: 'Sage Svatmarama on Asana, Pranayama, and Raja Yoga.',
    kind: 'verse_book',
    verseBookId: 'yoga-hatha-pradipika',
  ),

  // --------------------------------------------------------------------------
  // 7. VEDANTA (https://sanskritdocuments.org/vedanta)
  // --------------------------------------------------------------------------
  SacredWork(
    id: 'vedanta-brahma-sutras',
    section: 'vedanta',
    title: 'Brahma Sutras: Chatus-Sutri',
    credit: 'The 4 fundamental pillars with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'vedanta-brahma-sutras',
  ),
  SacredWork(
    id: 'vedanta-vivekachudamani',
    section: 'vedanta',
    title: 'Vivekachudamani (विवेकचूडामणिः)',
    credit: 'Adi Shankaracharya\'s foundational verses with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'vedanta-vivekachudamani',
  ),
  SacredWork(
    id: 'vedanta-upadesha-sahasri',
    section: 'vedanta',
    title: 'Upadesha Sahasri (उपदेशसाहस्री)',
    credit: 'Adi Shankaracharya\'s direct teachings on the Non-Dual Self.',
    kind: 'verse_book',
    verseBookId: 'vedanta-upadesha-sahasri',
  ),

  // --------------------------------------------------------------------------
  // 8. PRASTHANATRAYI (https://sanskritdocuments.org/prasthanatrayi)
  // --------------------------------------------------------------------------
  SacredWork(
    id: 'prasthanatrayi-trio',
    section: 'prasthanatrayi',
    title: 'Prasthanatrayi (प्रस्थानत्रयी)',
    credit: 'The Three Foundations: Shruti (Upanishads), Smriti (Gita), Nyaya (Brahma Sutras).',
    kind: 'verse_book',
    verseBookId: 'prasthanatrayi-trio',
  ),

  // --------------------------------------------------------------------------
  // 9. TANTRA (https://sanskritdocuments.org/tantra)
  // --------------------------------------------------------------------------
  SacredWork(
    id: 'tantra-shiva-sutras',
    section: 'tantra',
    title: 'Shiva Sutras (शिवसूत्राणि)',
    credit: 'Sage Vasugupta on Universal Consciousness. Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'tantra-shiva-sutras',
  ),
  SacredWork(
    id: 'tantra-vijnana-bhairava',
    section: 'tantra',
    title: 'Vijnana Bhairava Tantra',
    credit: '112 Dharanas of Spontaneous Realization in Kashmir Shaivism.',
    kind: 'verse_book',
    verseBookId: 'tantra-vijnana-bhairava',
  ),

  // --------------------------------------------------------------------------
  // 10. SMRITI (https://sanskritdocuments.org/smriti)
  // --------------------------------------------------------------------------
  SacredWork(
    id: 'smriti-manusmriti',
    section: 'smriti',
    title: 'Manusmriti: Laws of Manu',
    credit: 'Foundational Dharma verses with Sanskrit, IAST, selected language & English.',
    kind: 'verse_book',
    verseBookId: 'smriti-manusmriti',
  ),
  SacredWork(
    id: 'smriti-yajnavalkya',
    section: 'smriti',
    title: 'Yajnavalkya Smriti (याज्ञवल्क्यस्मृतिः)',
    credit: 'Golden principles of virtue, conduct, and liberation.',
    kind: 'verse_book',
    verseBookId: 'smriti-yajnavalkya',
  ),
];

List<SacredWork> worksIn(String section) =>
    scriptureWorks.where((work) => work.section == section).toList();
