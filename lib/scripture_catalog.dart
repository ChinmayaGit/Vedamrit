class SacredWork {
  final String id;
  final String section;
  final String title;
  final String credit;
  final String kind;
  final String? assetPath;
  final String? gutenberg;
  final String? query;

  const SacredWork({
    required this.id,
    required this.section,
    required this.title,
    required this.credit,
    required this.kind,
    this.assetPath,
    this.gutenberg,
    this.query,
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
  // Vedas
  SacredWork(
    id: 'rig-griffith',
    section: 'vedas',
    title: 'The Rig Veda',
    credit: 'Complete translation by Ralph T.H. Griffith, 1896. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/rig_veda.txt',
  ),
  SacredWork(
    id: 'sama',
    section: 'vedas',
    title: 'The Sama Veda',
    credit: 'The Veda of melodies, Ralph T.H. Griffith. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/sama_veda.txt',
  ),
  SacredWork(
    id: 'white-yajur',
    section: 'vedas',
    title: 'The White Yajur Veda',
    credit: 'Ralph T.H. Griffith, books 1–40. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/white_yajur_veda.txt',
  ),
  SacredWork(
    id: 'white-yajur-index',
    section: 'vedas',
    title: 'The White Yajur Veda — index',
    credit: 'Complete book index and hymns by Griffith. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/white_yajur_veda.txt',
  ),
  SacredWork(
    id: 'black-yajur',
    section: 'vedas',
    title: 'The Black Yajur Veda',
    credit: 'Taittiriya Sanhita, Arthur Berriedale Keith, 1914. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/black_yajur_veda.txt',
  ),
  SacredWork(
    id: 'atharva-griffith',
    section: 'vedas',
    title: 'The Hymns of the Atharvaveda',
    credit: 'Ralph T.H. Griffith, 1895–96. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/atharva_veda.txt',
  ),
  SacredWork(
    id: 'atharva-bloomfield',
    section: 'vedas',
    title: 'The Atharva Veda (Bloomfield)',
    credit: 'Maurice Bloomfield, Sacred Books of the East, vol 42, 1897. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/atharva_veda_bloomfield.txt',
  ),
  SacredWork(
    id: 'vedic-reader',
    section: 'vedas',
    title: 'A Vedic Reader for Students',
    credit: 'Arthur Anthony Macdonell, 1917. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/vedic_reader.txt',
  ),
  SacredWork(
    id: 'veda-mantras',
    section: 'vedas',
    title: 'Mantras kept in the app',
    credit: 'Gayatri, Purusha Sukta, Mahamrityunjaya, and Vedic shlokas with gloss.',
    kind: 'vedas',
  ),

  // Gita
  SacredWork(
    id: 'gita-verses',
    section: 'gita',
    title: 'The Bhagavad Gita',
    credit: 'All 18 chapters. Sanskrit is kept in the app. English sits beside each shloka.',
    kind: 'chapters',
  ),
  SacredWork(
    id: 'song-celestial',
    section: 'gita',
    title: 'The Song Celestial',
    credit: 'Verse translation by Sir Edwin Arnold, 1885. The full English text is in the app.',
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
  SacredWork(
    id: 'gita-abbreviated',
    section: 'gita',
    title: 'Abbreviated Gita',
    credit: 'Forty selected shlokas with Sanskrit and transliteration.',
    kind: 'forty',
  ),

  // Upanishads
  SacredWork(
    id: 'upanishads-muller',
    section: 'upanishads',
    title: 'The Upanishads',
    credit: 'Max Müller, Sacred Books of the East, volumes 1 and 2, 1879–1884. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/upanishads.txt',
  ),
  SacredWork(
    id: 'upanishads-minor',
    section: 'upanishads',
    title: '30 Minor Upanishads',
    credit: 'English translations with introductions by K. Narayanasvami Aiyar, 1914. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/minor_upanishads.txt',
  ),

  // Puranas
  SacredWork(
    id: 'bhagavatam',
    section: 'puranas',
    title: 'Srimad Bhagavatam',
    credit: 'Twelve skandhas (Maha Purana), Sanskrit titles and summaries kept in the app.',
    kind: 'cantos',
  ),
  SacredWork(
    id: 'vishnu-purana',
    section: 'puranas',
    title: 'The Vishnu Purana',
    credit: 'Classic translation by H.H. Wilson, 1840. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/vishnu_purana.txt',
  ),
  SacredWork(
    id: 'shiva-purana',
    section: 'puranas',
    title: 'The Shiva Purana',
    credit: 'Creation, Shiva-lila, and dharma. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/shiva_purana.txt',
  ),
  SacredWork(
    id: 'garuda-purana',
    section: 'puranas',
    title: 'The Garuda Purana',
    credit: 'Saroddhara, translated by Ernest Wood & S.V. Subrahmanyam. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/garuda_purana.txt',
  ),
  SacredWork(
    id: 'markandeya-purana',
    section: 'puranas',
    title: 'The Markandeya Purana',
    credit: 'Ancient wisdom and Devi Mahatmya, tr. F. Eden Pargiter. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/markandeya_purana.txt',
  ),

  // Epics
  SacredWork(
    id: 'ramayana-dutt',
    section: 'epics',
    title: 'The Ramayana',
    credit: 'Abridged verse translation by Romesh Dutt, 1899. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/ramayana.txt',
  ),
  SacredWork(
    id: 'mahabharata-dutt',
    section: 'epics',
    title: 'The Mahabharata',
    credit: 'Abridged verse translation by Romesh Dutt, 1898. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/mahabharata.txt',
  ),
  SacredWork(
    id: 'indian-idylls',
    section: 'epics',
    title: 'Indian Idylls',
    credit: 'Stories from the Mahabharata, Sir Edwin Arnold, 1883. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/indian_idylls.txt',
  ),

  // Shastras
  SacredWork(
    id: 'dharma',
    section: 'shastras',
    title: 'The Dharma Shastras',
    credit: 'Apastamba, Gautama, Vasishtha, Baudhayana. SBE Vol 2, Bühler. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/dharma_sutras.txt',
  ),
  SacredWork(
    id: 'manu',
    section: 'shastras',
    title: 'The Laws of Manu',
    credit: 'Georg Bühler, Sacred Books of the East, 1886. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/laws_of_manu.txt',
  ),
  SacredWork(
    id: 'grihya',
    section: 'shastras',
    title: 'The Grihya Sutras',
    credit: 'Vedic domestic ritual, Hermann Oldenberg, 1886. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/grihya_sutras.txt',
  ),
  SacredWork(
    id: 'kapila',
    section: 'shastras',
    title: 'The Kapila Sutras',
    credit: 'Sankhya aphorisms, James R. Ballantyne, 1885. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/sankhya.txt',
  ),
  SacredWork(
    id: 'artha',
    section: 'shastras',
    title: 'The Artha Shastra of Kautilya',
    credit: 'Statecraft and governance, translated by R. Shamasastry, 1915. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/arthashastra.txt',
  ),
  SacredWork(
    id: 'vimanika',
    section: 'shastras',
    title: 'The Vimanika Shastra',
    credit: 'Maharshi Bharadwaja’s aeronautics, tr. G.R. Josyer. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/vimanika_shastra.txt',
  ),

  // Yoga
  SacredWork(
    id: 'yoga-classical',
    section: 'yoga',
    title: 'The Yoga Sutras of Patanjali',
    credit: 'Classical translation with commentary by Charles Johnston. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/yoga_sutras.txt',
  ),
  SacredWork(
    id: 'yoga-sarbatoare',
    section: 'yoga',
    title: 'The Yoga Aphorisms of Patanjali',
    credit: 'Patanjali’s Yoga Sutras with interpretation and notes. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/yoga_sutras.txt',
  ),
  SacredWork(
    id: 'yoga-systems',
    section: 'yoga',
    title: 'The Great Systems of Yoga',
    credit: 'A survey of the yoga tradition, Ernest Wood, 1954. Kept on this phone.',
    kind: 'asset',
    assetPath: 'assets/scripture/great_systems_of_yoga.txt',
  ),
];

List<SacredWork> worksIn(String section) => scriptureWorks.where((work) => work.section == section).toList();
