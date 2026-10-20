import 'models.dart';

const gitaBase = 'https://vedicscriptures.github.io';
const gutendexBase = 'https://gutendex.com/books';
const openLibraryBase = 'https://openlibrary.org/search.json';
const archiveSearchBase = 'https://archive.org/advancedsearch.php';
const myMemoryBase = 'https://api.mymemory.translated.net/get';

const apiHeaders = {'User-Agent': 'Vedamrit/1.0 (personal scripture reader)'};

const readingLanguages = <ReadingLanguage>[
  ReadingLanguage('sa', 'संस्कृत · Sanskrit', false),
  ReadingLanguage('hi', 'हिन्दी · Hindi', false),
  ReadingLanguage('en', 'English', false),
  ReadingLanguage('te', 'తెలుగు · Telugu', true),
  ReadingLanguage('ta', 'தமிழ் · Tamil', true),
  ReadingLanguage('ml', 'മലയാളം · Malayalam', true),
  ReadingLanguage('kn', 'ಕನ್ನಡ · Kannada', true),
  ReadingLanguage('bn', 'বাংলা · Bengali', true),
  ReadingLanguage('mr', 'मराठी · Marathi', true),
  ReadingLanguage('gu', 'ગુજરાતી · Gujarati', true),
  ReadingLanguage('or', 'ଓଡ଼ିଆ · Odia', true),
  ReadingLanguage('pa', 'ਪੰਜਾਬੀ · Punjabi', true),
  ReadingLanguage('ur', 'اردو · Urdu', true),
  ReadingLanguage('ne', 'नेपाली · Nepali', true),
  ReadingLanguage('si', 'සිංහල · Sinhala', true),
  ReadingLanguage('es', 'Español · Spanish', true),
  ReadingLanguage('fr', 'Français · French', true),
  ReadingLanguage('de', 'Deutsch · German', true),
  ReadingLanguage('ru', 'Русский · Russian', true),
  ReadingLanguage('ar', 'العربية · Arabic', true),
];

const ttsLocales = <String, String>{
  'sa': 'hi-IN',
  'hi': 'hi-IN',
  'en': 'en-IN',
  'te': 'te-IN',
  'ta': 'ta-IN',
  'ml': 'ml-IN',
  'kn': 'kn-IN',
  'bn': 'bn-IN',
  'mr': 'mr-IN',
  'gu': 'gu-IN',
  'or': 'or-IN',
  'pa': 'pa-IN',
  'ur': 'ur-IN',
  'ne': 'ne-NP',
  'si': 'si-LK',
  'es': 'es-ES',
  'fr': 'fr-FR',
  'de': 'de-DE',
  'ru': 'ru-RU',
  'ar': 'ar-SA',
};

const libraryPresets = <String>[
  'Bhagavad Gita',
  'Srimad Bhagavatam',
  'Rigveda',
  'Yajurveda',
  'Samaveda',
  'Atharvaveda',
  'Upanishads',
  'Mahabharata',
  'Ramayana',
  'Yoga Sutra',
];

const aboutSources = '''
Shlokas come from the free Bhagavad Gita API at vedicscriptures.github.io. Sanskrit, Hindi, and English include the acharya voices that API publishes: Shankara, Ramanuja, Madhva, Vallabha, Abhinavagupta, Sridhara, Chinmayananda, Sivananda, Prabhupada, and the others it returns. Each voice is named.

Telugu, Tamil, Malayalam, Kannada, Bengali, Marathi, Gujarati, Odia, Punjabi, Urdu, Nepali, Sinhala, Spanish, French, German, Russian, and Arabic are a reading aid. Vedamrit sends the short English verse to the MyMemory translation service and keeps the result on this phone. That line is not an acharya translation.

Full books come from three free libraries: Project Gutenberg through Gutendex, Open Library, and the Internet Archive. The download button keeps a public file on this phone.

A signed-in account keeps your name, language, reading place, and bookmarks. Sangha thoughts, circles, and temple notes are shared through Firebase. The śāstra text itself stays in the app and the free libraries. Temple photos stay on the phone that added them.
''';

ReadingLanguage languageByCode(String code) {
  for (final language in readingLanguages) {
    if (language.code == code) return language;
  }
  return readingLanguages[2];
}

String ttsLocale(String code) => ttsLocales[code] ?? 'en-IN';

const offlineQuote = DailyQuote(
  chapter: 2,
  verse: 47,
  sanskrit: 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥',
  transliteration: 'karmanye vadhikaraste ma phaleshu kadachana\nma karma-phala-hetur bhur ma te sango stv akarmani',
  gloss: 'Your claim is the work itself, never the fruit. Do not make the fruit your motive, and do not cling to doing nothing.',
);

const bundledChapters = <Chapter>[
  Chapter(
    number: 1,
    verses: 47,
    name: 'अर्जुनविषादयोग',
    transliteration: 'Arjuna Vishada Yoga',
    translation: 'Arjuna’s Grief',
    summary: 'Arjuna sees his teachers and family across the field and lays down his bow.',
  ),
  Chapter(
    number: 2,
    verses: 72,
    name: 'सांख्ययोग',
    transliteration: 'Sankhya Yoga',
    translation: 'The Yoga of Knowledge',
    summary: 'Krishna separates the body that dies from the self that does not, and asks for work without bargaining for the fruit.',
  ),
  Chapter(
    number: 3,
    verses: 43,
    name: 'कर्मयोग',
    transliteration: 'Karma Yoga',
    translation: 'The Yoga of Action',
    summary: 'Action is required. Even the one who knows still acts, without clutching the result.',
  ),
  Chapter(
    number: 4,
    verses: 42,
    name: 'ज्ञानकर्मसंन्यासयोग',
    transliteration: 'Jnana Karma Sannyasa Yoga',
    translation: 'Knowledge and Renunciation',
    summary: 'Krishna describes the yoga of action, and that he appears whenever dharma thins.',
  ),
  Chapter(
    number: 5,
    verses: 29,
    name: 'कर्मसंन्यासयोग',
    transliteration: 'Karma Sannyasa Yoga',
    translation: 'Renunciation of Action',
    summary: 'Renunciation and action meet when the work is done without a selfish claim.',
  ),
  Chapter(
    number: 6,
    verses: 47,
    name: 'ध्यानयोग',
    transliteration: 'Dhyana Yoga',
    translation: 'The Yoga of Meditation',
    summary: 'The mind is trained by sitting with it, and the self becomes a friend to the self.',
  ),
  Chapter(
    number: 7,
    verses: 30,
    name: 'ज्ञानविज्ञानयोग',
    transliteration: 'Jnana Vijnana Yoga',
    translation: 'Knowledge and Realization',
    summary: 'Krishna speaks of a lower nature and a higher one, and of how he is known.',
  ),
  Chapter(
    number: 8,
    verses: 28,
    name: 'अक्षरब्रह्मयोग',
    transliteration: 'Akshara Brahma Yoga',
    translation: 'The Imperishable',
    summary: 'At the hour of leaving, the mind goes where it was trained to rest.',
  ),
  Chapter(
    number: 9,
    verses: 34,
    name: 'राजविद्याराजगुह्ययोग',
    transliteration: 'Raja Vidya Raja Guhya Yoga',
    translation: 'The Royal Secret',
    summary: 'A life offered simply, in devotion, is held.',
  ),
  Chapter(
    number: 10,
    verses: 42,
    name: 'विभूतियोग',
    transliteration: 'Vibhuti Yoga',
    translation: 'Divine Glories',
    summary: 'Krishna recites a garland of his manifestations in the world.',
  ),
  Chapter(
    number: 11,
    verses: 55,
    name: 'विश्वरूपदर्शनयोग',
    transliteration: 'Vishvarupa Darshana Yoga',
    translation: 'The Cosmic Form',
    summary: 'Arjuna is given eyes to see the vast form, terrible and tender at once.',
  ),
  Chapter(
    number: 12,
    verses: 20,
    name: 'भक्तियोग',
    transliteration: 'Bhakti Yoga',
    translation: 'The Yoga of Devotion',
    summary: 'The one who is kind, steady, and unenvious is dear.',
  ),
  Chapter(
    number: 13,
    verses: 35,
    name: 'क्षेत्रक्षेत्रज्ञविभागयोग',
    transliteration: 'Kshetra Kshetrajna Yoga',
    translation: 'Field and Knower',
    summary: 'The field is the body and nature. The knower of the field is the self.',
  ),
  Chapter(
    number: 14,
    verses: 27,
    name: 'गुणत्रयविभागयोग',
    transliteration: 'Gunatraya Vibhaga Yoga',
    translation: 'The Three Qualities',
    summary: 'Sattva, rajas, and tamas bind in different ways. Freedom is seeing them act.',
  ),
  Chapter(
    number: 15,
    verses: 20,
    name: 'पुरुषोत्तमयोग',
    transliteration: 'Purushottama Yoga',
    translation: 'The Supreme Person',
    summary: 'The world is a banyan with roots above. Detachment cuts it, and the supreme person is found.',
  ),
  Chapter(
    number: 16,
    verses: 24,
    name: 'दैवासुरसम्पद्विभागयोग',
    transliteration: 'Daivasura Sampad Yoga',
    translation: 'Divine and Harsh Natures',
    summary: 'Divine qualities and cruel ones are listed, so a person can tell them apart in themselves.',
  ),
  Chapter(
    number: 17,
    verses: 28,
    name: 'श्रद्धात्रयविभागयोग',
    transliteration: 'Shraddhatraya Vibhaga Yoga',
    translation: 'Three Kinds of Faith',
    summary: 'Faith, food, sacrifice, and gift each follow the three qualities.',
  ),
  Chapter(
    number: 18,
    verses: 78,
    name: 'मोक्षसंन्यासयोग',
    transliteration: 'Moksha Sannyasa Yoga',
    translation: 'Liberation and Renunciation',
    summary: 'The teaching is gathered: do your own work, offer it, and take refuge.',
  ),
];

const vedas = <Veda>[
  Veda(
    id: 'rig',
    name: 'Rigveda',
    sanskrit: 'ऋग्वेद',
    summary: 'The oldest of the four, a book of hymns to Agni, Indra, Soma, Savitri, and the dawn. The Gayatri sits in the third mandala.',
    query: 'Rigveda',
    passages: [
      Passage(
        id: 'gayatri',
        title: 'Gayatri',
        sanskrit: 'ॐ भूर्भुवः स्वः।\nतत्सवितुर्वरेण्यं भर्गो देवस्य धीमहि।\nधियो यो नः प्रचोदयात्॥',
        transliteration: 'om bhur bhuvah svah\ntat savitur varenyam bhargo devasya dhimahi\ndhiyo yo nah prachodayat',
        meaning: 'We meditate on the splendor of divine Savitri. May that light set our understanding in motion.',
      ),
      Passage(
        id: 'purusha',
        title: 'Purusha Sukta, opening',
        sanskrit: 'सहस्रशीर्षा पुरुषः सहस्राक्षः सहस्रपात्।\nस भूमिं विश्वतो वृत्वा अत्यतिष्ठद्दशाङ्गुलम्॥',
        transliteration: 'sahasra-shirsha purushah sahasrakshah sahasrapat\nsa bhumim vishvato vritva atyatishthad dashangulam',
        meaning: 'The person has a thousand heads, a thousand eyes, a thousand feet. He covers the earth on every side and still stands beyond it.',
      ),
    ],
  ),
  Veda(
    id: 'yajur',
    name: 'Yajurveda',
    sanskrit: 'यजुर्वेद',
    summary: 'The veda of the sacrifice, the spoken formulas of the rite. It is kept in the Krishna and Shukla recensions.',
    query: 'Yajurveda',
    passages: [
      Passage(
        id: 'tryambaka',
        title: 'Mahamrityunjaya',
        sanskrit: 'ॐ त्र्यम्बकं यजामहे सुगन्धिं पुष्टिवर्धनम्।\nउर्वारुकमिव बन्धनान्मृत्योर्मुक्षीय मामृतात्॥',
        transliteration: 'om tryambakam yajamahe sugandhim pushti-vardhanam\nurvarukam iva bandhanan mrityor mukshiya mamritat',
        meaning: 'We offer to the three-eyed one who nourishes. Like a ripe fruit freed from its stem, may we be released from death, not from what is deathless.',
      ),
      Passage(
        id: 'sahana',
        title: 'Study peace',
        sanskrit: 'ॐ सह नाववतु। सह नौ भुनक्तु। सह वीर्यं करवावहै।\nतेजस्विनावधीतमस्तु मा विद्विषावहै।\nॐ शान्तिः शान्तिः शान्तिः॥',
        transliteration: 'om saha navavatu saha nau bhunaktu saha viryam karavavahai\ntejasvi navadhitam astu ma vidvishavahai\nom shantih shantih shantih',
        meaning: 'May we be protected together and fed together. May we work with vigor, may our study shine, and may we not fall into enmity. Peace, peace, peace.',
      ),
    ],
  ),
  Veda(
    id: 'sama',
    name: 'Samaveda',
    sanskrit: 'सामवेद',
    summary: 'Mostly Rig hymns set to melody for the udgatri priest. The text is a songbook more than a new collection of stories.',
    query: 'Samaveda',
    passages: [
      Passage(
        id: 'agna',
        title: 'Agna a yahi',
        sanskrit: 'अग्न आ याहि वीतये गृणानो हव्यदातये।\nनि होता सत्सि बर्हिषि॥',
        transliteration: 'agna a yahi vitaye grinaano havyadataye\nni hota satsi barhishi',
        meaning: 'Agni, come to the feast. You are praised as the offerings are given. Sit as the priest upon the sacred grass.',
      ),
    ],
  ),
  Veda(
    id: 'atharva',
    name: 'Atharvaveda',
    sanskrit: 'अथर्ववेद',
    summary: 'Hymns for healing, household peace, and the long life of a people. It stands a little apart from the three ritual vedas.',
    query: 'Atharvaveda',
    passages: [
      Passage(
        id: 'bhadram',
        title: 'Bhadram karnebhih',
        sanskrit: 'भद्रं कर्णेभिः शृणुयाम देवाः।\nभद्रं पश्येमाक्षभिर्यजत्राः।\nस्थिरैरङ्गैस्तुष्टुवांसस्तनूभिः।\nव्यशेम देवहितं यदायुः॥',
        transliteration: 'bhadram karnebhih shrinuyama devah\nbhadram pashyemakshabhir yajatrah\nsthirair angais tushtuvamsas tanubhih\nvyashema devahitam yad ayuh',
        meaning: 'May we hear what is auspicious and see what is auspicious. With steady limbs, praising, may we reach the span of life appointed for us.',
      ),
    ],
  ),
];

const cantos = <Canto>[
  Canto(number: 1, name: 'Creation', sanskrit: 'प्रथम स्कन्ध', summary: 'The sages at Naimisha ask about Krishna, and the frame of the Bhagavata is set.', query: 'Srimad Bhagavatam canto 1'),
  Canto(number: 2, name: 'The cosmic form', sanskrit: 'द्वितीय स्कन्ध', summary: 'A short map of how the universe is pictured, and how attention turns toward the divine.', query: 'Srimad Bhagavatam canto 2'),
  Canto(number: 3, name: 'The status of the world', sanskrit: 'तृतीय स्कन्ध', summary: 'Vidura’s questions, Kapila’s teaching, and the measure of a human life.', query: 'Srimad Bhagavatam canto 3'),
  Canto(number: 4, name: 'The line of the good', sanskrit: 'चतुर्थ स्कन्ध', summary: 'Stories of Daksha, Dhruva, and Prithu, on stubbornness, steadiness, and rule.', query: 'Srimad Bhagavatam canto 4'),
  Canto(number: 5, name: 'The structure of the world', sanskrit: 'पञ्चम स्कन्ध', summary: 'The geography of the purana’s universe, and the teaching of Rishabhadeva.', query: 'Srimad Bhagavatam canto 5'),
  Canto(number: 6, name: 'The thread of duty', sanskrit: 'षष्ठ स्कन्ध', summary: 'Ajamila, the name that saves, and the birth of the Maruts.', query: 'Srimad Bhagavatam canto 6'),
  Canto(number: 7, name: 'Prahlada', sanskrit: 'सप्तम स्कन्ध', summary: 'The child who will not give up Narayana, and Narasimha at the threshold.', query: 'Srimad Bhagavatam canto 7'),
  Canto(number: 8, name: 'The churning and the vows', sanskrit: 'अष्टम स्कन्ध', summary: 'The ocean is churned, Gajendra calls, and Vamana asks for three steps.', query: 'Srimad Bhagavatam canto 8'),
  Canto(number: 9, name: 'The royal histories', sanskrit: 'नवम स्कन्ध', summary: 'The solar and lunar lines, told as a chain of names and turns.', query: 'Srimad Bhagavatam canto 9'),
  Canto(number: 10, name: 'Krishna', sanskrit: 'दशम स्कन्ध', summary: 'The long canto of Krishna’s life in Vraja and Dvaraka. This is the heart most readers come for.', query: 'Srimad Bhagavatam canto 10'),
  Canto(number: 11, name: 'The last instructions', sanskrit: 'एकादश स्कन्ध', summary: 'Krishna’s teaching to Uddhava as the Yadava story closes.', query: 'Srimad Bhagavatam canto 11'),
  Canto(number: 12, name: 'The age and the release', sanskrit: 'द्वादश स्कन्ध', summary: 'The ages, the decline of dharma, and the end of the telling at Naimisha.', query: 'Srimad Bhagavatam canto 12'),
];

Passage? passageById(String id) {
  for (final veda in vedas) {
    for (final passage in veda.passages) {
      if (passage.id == id) return passage;
    }
  }
  return null;
}

int dayIndex(List<Chapter> chapters) {
  final now = DateTime.now();
  final start = DateTime(now.year, 1, 1);
  final day = now.difference(start).inDays;
  final total = chapters.fold<int>(0, (sum, chapter) => sum + chapter.verses);
  if (total <= 0) return 0;
  return day % total;
}

(int, int) locateVerse(int index, List<Chapter> chapters) {
  var left = index;
  for (final chapter in chapters) {
    if (left < chapter.verses) return (chapter.number, left + 1);
    left -= chapter.verses;
  }
  return (2, 47);
}

String dayKey() {
  final now = DateTime.now();
  return '${now.year}-${now.month}-${now.day}';
}

List<Thought> seedThoughts() => [
      Thought(
        id: 'thought-karma',
        author: 'Ananya',
        text: 'I keep 2.47 on the kitchen wall. The fruit is not the point of chopping vegetables either.',
        createdAt: DateTime(2026, 10, 12, 8).millisecondsSinceEpoch,
        likes: 6,
      ),
      Thought(
        id: 'thought-quiet',
        author: 'Raghav',
        text: 'Went to the old shrine before sunrise. No photograph. The bell and the wet stone were enough.',
        createdAt: DateTime(2026, 10, 10, 6).millisecondsSinceEpoch,
        likes: 4,
      ),
      Thought(
        id: 'thought-ask',
        author: 'Leela',
        text: 'If karma yoga is work without a bargain, what do we do with a job that only pays when we bargain?',
        createdAt: DateTime(2026, 10, 8, 19).millisecondsSinceEpoch,
        likes: 9,
      ),
    ];

List<CircleGroup> seedGroups() => [
      CircleGroup(
        id: 'group-gita',
        name: 'Gita circle',
        about: 'One shloka, read slowly.',
        channels: [
          Channel(
            id: 'ch-general',
            name: 'general',
            messages: [
              ChatMessage(
                id: 'm1',
                author: 'Ananya',
                text: 'Shall we stay with chapter 2 this week?',
                createdAt: DateTime(2026, 10, 11, 9).millisecondsSinceEpoch,
                mine: false,
              ),
              ChatMessage(
                id: 'm2',
                author: 'Raghav',
                text: 'Yes. Verse 47, then the ones just after it.',
                createdAt: DateTime(2026, 10, 11, 9, 12).millisecondsSinceEpoch,
                mine: false,
              ),
            ],
          ),
          Channel(id: 'ch-today', name: 'today’s verse'),
        ],
      ),
      CircleGroup(
        id: 'group-yatra',
        name: 'Yatra',
        about: 'Which temple, and how to reach it.',
        channels: [
          Channel(
            id: 'ch-routes',
            name: 'routes',
            messages: [
              ChatMessage(
                id: 'm3',
                author: 'Leela',
                text: 'Kedarnath road is a trek from Gaurikund once the season is open. Carry the last kilometer slowly.',
                createdAt: DateTime(2026, 10, 9, 15).millisecondsSinceEpoch,
                mine: false,
              ),
            ],
          ),
        ],
      ),
    ];

List<TemplePost> seedTemples() => [
      TemplePost(
        id: 'seed-kashi',
        name: 'Kashi Vishwanath',
        place: 'Varanasi, Uttar Pradesh',
        scripture: 'In the lanes, short Shiva stotras are painted on the walls. The shrine itself is the jyotirlinga named Vishwanath, lord of the universe.',
        meaning: 'Kashi is kept as the city where a life can be offered at the end. The linga is Shiva as the one in whom the city holds together.',
        value: 'People come to bathe in the Ganga, walk the old lanes, and stand for the evening lamps. The value is the continuity: the same river, the same name, a new visitor.',
        visit: 'Reach Varanasi by rail or air, then the old city on foot or by boat. The temple sits in a dense lane near Dashashwamedh. Go early, leave bags, and follow the queue.',
        author: 'Vedamrit',
        hue: 0,
        createdAt: DateTime(2026, 10, 14, 7).millisecondsSinceEpoch,
        likes: 28,
        comments: [
          TempleComment(
            id: 'kashi-c1',
            author: 'Meera',
            text: 'The boat at dawn showed the ghats better than the queue did.',
            createdAt: DateTime(2026, 10, 14, 11).millisecondsSinceEpoch,
            mine: false,
          ),
        ],
      ),
      TemplePost(
        id: 'seed-kedarnath',
        name: 'Kedarnath',
        place: 'Rudraprayag, Uttarakhand',
        scripture: 'One of the twelve jyotirlingas, set in a stone shrine below the snow line. The form here is the hump of Shiva, in the old telling of the Pandavas.',
        meaning: 'A high, severe shrine. The climb is part of the meeting: weather, breath, and a small sanctum.',
        value: 'It closes the Char Dham of the mountains for many pilgrims. The value is the effort and the quiet once the helicopters stop.',
        visit: 'Come in the open months, roughly late spring to autumn. Reach Gaurikund, then trek, pony, or palanquin. Check the road and weather the day you leave Haridwar or Rishikesh.',
        author: 'Vedamrit',
        hue: 3,
        createdAt: DateTime(2026, 10, 13, 6).millisecondsSinceEpoch,
        likes: 19,
      ),
      TemplePost(
        id: 'seed-tirumala',
        name: 'Tirumala Venkateswara',
        place: 'Tirupati, Andhra Pradesh',
        scripture: 'The hill shrine of Venkateswara. Devotees recite the Suprabhatam at the opening. Look for the tall gopuram and the inscriptions along the prakara, not only the queue.',
        meaning: 'Vishnu as the lord who stands on the seven hills, asked for with a vow and a return.',
        value: 'One of the most visited temples. The value people name is a promise kept: hair offered, a walk up, a second visit when the prayer is answered.',
        visit: 'Tirupati town is below. The shrine is on Tirumala, by road, walkway, or the stepped path. Book the darshan window before you travel, and keep the dress code.',
        author: 'Vedamrit',
        hue: 1,
        createdAt: DateTime(2026, 10, 11, 5).millisecondsSinceEpoch,
        likes: 33,
      ),
      TemplePost(
        id: 'seed-meenakshi',
        name: 'Meenakshi Amman',
        place: 'Madurai, Tamil Nadu',
        scripture: 'A city-temple. The towers are textbooks of plastered gods. Inside, Meenakshi and Sundareshwara have their own shrines, and the painted halls carry the local purana.',
        meaning: 'The goddess is the center, not an addition. Madurai is told as her city, with Shiva as Sundareshwara beside her.',
        value: 'Come for the scale of the corridors and the evening procession. The value is a living temple that still uses its whole plan, not a ruin.',
        visit: 'Madurai is a rail and air junction. The temple is in the old center. Non-hindus may be stopped at an inner gate. Phones are often restricted. Walk the four towers outside even if the queue is long.',
        author: 'Vedamrit',
        hue: 5,
        createdAt: DateTime(2026, 10, 9, 16).millisecondsSinceEpoch,
        likes: 22,
      ),
      TemplePost(
        id: 'seed-puri',
        name: 'Jagannath',
        place: 'Puri, Odisha',
        scripture: 'The wooden triad, Jagannath, Balabhadra, and Subhadra, replaced in the Nabakalebara when the wood is renewed. The kitchen and the Rath Yatra are part of the text of the place.',
        meaning: 'Krishna as the lord of the world, in a form that is deliberately not a usual stone murti.',
        value: 'The chariot day turns the temple inside out: the deities come to the street. The value is that public meeting, and the daily offering cooked at a huge scale.',
        visit: 'Puri is on the Odisha coast, a few hours from Bhubaneswar. The main gate is the lion gate, Singhadwara. In the weeks of the Rath Yatra the town is crowded. Dress simply and follow the local entry rules.',
        author: 'Vedamrit',
        hue: 4,
        createdAt: DateTime(2026, 10, 7, 8).millisecondsSinceEpoch,
        likes: 17,
      ),
      TemplePost(
        id: 'seed-guruvayur',
        name: 'Guruvayur',
        place: 'Thrissur, Kerala',
        scripture: 'Krishna as Guruvayurappan, a four-armed form. The temple follows a strict Kerala rite. Listen for the drums more than for a painted panel.',
        meaning: 'A house of Krishna kept to the tantra of the region: round sanctum, sloping roof, oil lamps.',
        value: 'People bring children, marriages, and the first rice here. The value is domestic devotion with a demanding timetable.',
        visit: 'Guruvayur is a short road trip from Thrissur. Men are expected in the mundu, and shirts are removed inside. There are counters for the dress if you arrive without it. Check the day’s opening.',
        author: 'Vedamrit',
        hue: 6,
        createdAt: DateTime(2026, 10, 5, 7).millisecondsSinceEpoch,
        likes: 14,
      ),
      TemplePost(
        id: 'seed-somnath',
        name: 'Somnath',
        place: 'Gir Somnath, Gujarat',
        scripture: 'The first jyotirlinga in the traditional list, on the western shore. The present building is a restoration. The nearby banastambha marks the point used in old coastal measure.',
        meaning: 'Shiva as lord of the moon, at the edge of the land, rebuilt after being broken.',
        value: 'The value people speak of is return: a shrine that was destroyed and raised again, still facing the sea.',
        visit: 'Reach Veraval and Somnath by rail or by road from Ahmedabad and Rajkot. The evening aarti faces the water. The sound-and-light telling is optional. The sanctum has its own entry rules.',
        author: 'Vedamrit',
        hue: 2,
        createdAt: DateTime(2026, 10, 3, 18).millisecondsSinceEpoch,
        likes: 11,
      ),
      TemplePost(
        id: 'seed-kamakhya',
        name: 'Kamakhya',
        place: 'Guwahati, Assam',
        scripture: 'On Nilachal hill. The sanctum is a spring, not a stone figure, and the place is a center of the Shakta pithas. The walls of the complex mix several periods of building.',
        meaning: 'The goddess as the source, honored where the hill keeps an underground stream.',
        value: 'Ambubachi, when the shrine closes and reopens, is the gathering. The value is a theology that does not hide the body or the earth.',
        visit: 'Guwahati is the city below. Taxis climb Nilachal. During Ambubachi the hill is extremely crowded and the shrine is shut for a few days. Go outside that week if you want a quieter darshan, or go for the fair if that is the point.',
        author: 'Vedamrit',
        hue: 7,
        createdAt: DateTime(2026, 10, 1, 9).millisecondsSinceEpoch,
        likes: 15,
        comments: [
          TempleComment(
            id: 'kam-c1',
            author: 'Ishan',
            text: 'The view of the Brahmaputra from the hill is worth the wait outside.',
            createdAt: DateTime(2026, 10, 2, 12).millisecondsSinceEpoch,
            mine: false,
          ),
        ],
      ),
    ];
