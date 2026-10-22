import 'sanskrit_transcriber.dart';

class SacredVerse {
  final int number;
  final String label;
  final String sanskrit;
  final String? transliteration;
  final String originalTranslation;
  final String? commentary;

  const SacredVerse({
    required this.number,
    required this.label,
    required this.sanskrit,
    this.transliteration,
    required this.originalTranslation,
    this.commentary,
  });

  String get iast {
    if (transliteration != null && transliteration!.trim().isNotEmpty) {
      return transliteration!.trim();
    }
    return SanskritTranscriber.toIast(sanskrit);
  }
}

class SacredVerseBook {
  final String id;
  final String category;
  final String title;
  final String sanskritTitle;
  final String subtitle;
  final String sourceUrl;
  final List<SacredVerse> verses;

  const SacredVerseBook({
    required this.id,
    required this.category,
    required this.title,
    required this.sanskritTitle,
    required this.subtitle,
    required this.sourceUrl,
    required this.verses,
  });
}

class SanskritDocumentsData {
  static const categories = <(String, String, String, String)>[
    ('vedas', '4 Vedas', 'वेदाः', 'https://sanskritdocuments.org/sanskrit/veda'),
    ('upanishads', 'Upanishads', 'उपनिषदः', 'https://sanskritdocuments.org/upanishhat'),
    ('puranas', 'Puranas', 'पुराणानि', 'https://sanskritdocuments.org/doc_purana'),
    ('epics', 'Ramayana / Mahabharata', 'इतिहासः', 'https://sanskritdocuments.org/itihasa'),
    ('shastras', 'Shastras', 'शास्त्राणि', 'https://sanskritdocuments.org/shastra'),
    ('yoga', 'Yoga', 'योगदर्शनम्', 'https://sanskritdocuments.org/yoga'),
    ('vedanta', 'Vedanta', 'वेदान्तः', 'https://sanskritdocuments.org/vedanta'),
    ('prasthanatrayi', 'Prasthanatrayi', 'प्रस्थानत्रयी', 'https://sanskritdocuments.org/prasthanatrayi'),
    ('tantra', 'Tantra', 'तन्त्रम्', 'https://sanskritdocuments.org/tantra'),
    ('smriti', 'Smriti', 'स्मृतिः', 'https://sanskritdocuments.org/smriti'),
  ];

  static final List<SacredVerseBook> books = [
    // ------------------------------------------------------------------------
    // 1. 4 VEDAS (https://sanskritdocuments.org/sanskrit/veda)
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'rig-agni-suktam',
      category: 'vedas',
      title: 'Rig Veda: Agni Suktam',
      sanskritTitle: 'ऋग्वेदः अग्निसूक्तम्',
      subtitle: 'Mandala 1 · Sukta 1 (Complete 9 Mantras) · Rishi Madhuchhandas',
      sourceUrl: 'https://sanskritdocuments.org/sanskrit/veda',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१.१',
          sanskrit: 'अग्निमीळे पुरोहितं यज्ञस्य देवमृत्विजम् ।\nहोतारं रत्नधातमम् ॥ १.००१.०१',
          transliteration: 'agnimīḷe purohitaṁ yajñasya devamṛtvijam |\nhotāraṁ ratnadhātamam || 1.1.1',
          originalTranslation:
              'I magnify and praise Agni the Purohita, divine ministrant of the sacrifice, the Hotar priest, best bestower of treasures.',
          commentary: 'Rishi: Madhucchandas Vaishvamitra · Devata: Agni · Chhandas: Gayatri',
        ),
        const SacredVerse(
          number: 2,
          label: '१.१.२',
          sanskrit: 'अग्निः पूर्वेभिरृषिभिरीड्यो नूतनैरुत ।\nस देवाँ एह वक्षति ॥ १.००१.०२',
          transliteration: 'agniḥ pūrvebhirṛṣibhirīḍyo nūtanairuta |\nsa devām̐ eha vakṣati || 1.1.2',
          originalTranslation:
              'Worthy is Agni to be praised by ancient seers and by the new: may he bring the gods hither.',
        ),
        const SacredVerse(
          number: 3,
          label: '१.१.३',
          sanskrit: 'अग्निना रयिमश्नवत्पोषमेव दिवेदिवे ।\nयशसं वीरवत्तमम् ॥ १.००१.०३',
          transliteration: 'agninā rayimaśnavatpoṣameva divedive |\nyaśasaṁ vīravattamam || 1.1.3',
          originalTranslation:
              'Through Agni may one gain wealth and prosperity day by day, abundant in heroic descendants.',
        ),
        const SacredVerse(
          number: 4,
          label: '१.१.४',
          sanskrit: 'अग्ने यं यज्ञमध्वरं विश्वतः परिभूरसि ।\nस इद्देवेषु गच्छति ॥ १.००१.०४',
          transliteration: 'agne yaṁ yajñamadhvaraṁ viśvataḥ paribhūrasi |\nsa iddeveṣu gacchati || 1.1.4',
          originalTranslation:
              'O Agni, the uninjured sacrificial rite which thou encompassest on every side, that alone reaches the gods.',
        ),
        const SacredVerse(
          number: 5,
          label: '१.१.५',
          sanskrit: 'अग्निर्होता कविक्रतुः सत्यश्चित्रश्रवस्तमः ।\nदेवो देवेभिरा गमत् ॥ १.००१.०५',
          transliteration: 'agnirhotā kavikratuḥ satyaścitraśravastamaḥ |\ndevo devebhirā gamat || 1.1.5',
          originalTranslation:
              'May Agni, the priest of insightful wisdom, truthful and richly famed, come hither, a god with all the gods.',
        ),
        const SacredVerse(
          number: 6,
          label: '१.१.६',
          sanskrit: 'यदङ्ग दाशुषे त्वमग्ने भद्रं करिष्यसि ।\nतवेत्तत्सत्यमङ्गिरः ॥ १.००१.०६',
          transliteration: 'yadaṅga dāśuṣe tvamagne bhadraṁ kariṣyasi |\ntavettatsatyamaṅgiraḥ || 1.1.6',
          originalTranslation:
              'Whatever blessing thou, O Agni Angiras, wilt bestow upon the worshipper, that blessing is indeed thine own truth.',
        ),
        const SacredVerse(
          number: 7,
          label: '१.१.७',
          sanskrit: 'उप त्वाग्ने दिवेदिवे दोषावस्तर्धिया वयम् ।\nनमो भरन्त एमसि ॥ १.००१.०७',
          transliteration: 'upa tvāgne divedive doṣāvastardhiyā vayam |\nnamo bharanta emasi || 1.1.7',
          originalTranslation:
              'To thee, O Agni, day by day, in darkness and in light, we come bringing heartfelt adoration with our prayer.',
        ),
        const SacredVerse(
          number: 8,
          label: '१.१.८',
          sanskrit: 'राजन्तमध्वराणां गोपामृतस्य दीदिविम् ।\nवर्धमानं स्वे दमे ॥ १.००१.०८',
          transliteration: 'rājantamadhvarāṇāṁ gopāmṛtasya dīdivim |\nvardhamānaṁ sve dame || 1.1.8',
          originalTranslation:
              'Ruler of solemn sacrifices, radiant guardian of Cosmic Truth (Rita), ever increasing in thy divine dwelling.',
        ),
        const SacredVerse(
          number: 9,
          label: '१.१.९',
          sanskrit: 'स नः पितेव सूनवेऽग्ने सूपायनो भव ।\nसचस्वा नः स्वस्तये ॥ १.००१.०९',
          transliteration: 'sa naḥ piteva sūnave\'gne sūpāyano bhava |\nsacasvā naḥ svastaye || 1.1.9',
          originalTranslation:
              'Be unto us easy of approach, O Agni, even as a father to his son; abide with us for our supreme wellbeing.',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'rig-purusha-suktam',
      category: 'vedas',
      title: 'Rig Veda: Purusha Suktam',
      sanskritTitle: 'पुरुषसूक्तम्',
      subtitle: 'Mandala 10 · Sukta 90 · The Cosmic Being',
      sourceUrl: 'https://sanskritdocuments.org/sanskrit/veda',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१०.९०.१',
          sanskrit: 'सहस्रशीर्षा पुरुषः सहस्राक्षः सहस्रपात् ।\nस भूमिं विश्वतो वृत्वात्यतिष्ठद्दशाङ्गुलम् ॥ १०.०९०.०१',
          transliteration: 'sahasraśīrṣā puruṣaḥ sahasrākṣaḥ sahasrapāt |\nsa bhūmiṁ viśvato vṛtvātyatiṣṭhaddaśāṅgulam || 10.90.1',
          originalTranslation:
              'A thousand heads hath Purusha, a thousand eyes, a thousand feet. On every side pervading earth he fills space ten fingers wide beyond.',
        ),
        const SacredVerse(
          number: 2,
          label: '१०.९०.२',
          sanskrit: 'पुरुष एवेदं सर्वं यद्भूतं यच्च भव्यम् ।\nउतामृतत्वस्येशानो यदन्नेनातिरोहति ॥ १०.०९०.०२',
          transliteration: 'puruṣa evedaṁ sarvaṁ yadbhūtaṁ yacca bhavyam |\nutāmṛtatvasyeśāno yadannenātirohati || 10.90.2',
          originalTranslation:
              'Purusha is all this all that hath been and all that shall be; he is also the Lord of immortality, which waxes greater by nourishment.',
        ),
        const SacredVerse(
          number: 3,
          label: '१०.९०.३',
          sanskrit: 'एतावानस्य महिमातो ज्यायांश्च पूरुषः ।\nपादोऽस्य विश्वा भूतानि त्रिपादस्यामृतं दिवि ॥ १०.०९०.०३',
          transliteration: 'etāvānasya mahimāto jyāyāṁśca pūruṣaḥ |\npādo\'sya viśvā bhūtāni tripādasyāmṛtaṁ divi || 10.90.3',
          originalTranslation:
              'So mighty is his greatness; yea, greater than this is Purusha. All creatures are one-fourth of him, three-fourths eternal life in heaven.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // 2. UPANISHADS (https://sanskritdocuments.org/upanishhat)
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'upanishad-isha',
      category: 'upanishads',
      title: 'Isha Upanishad',
      sanskritTitle: 'ईशावास्योपनिषत्',
      subtitle: 'Shukla Yajurveda · 18 Mantras · Complete Foundational Upanishad',
      sourceUrl: 'https://sanskritdocuments.org/upanishhat',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१',
          sanskrit: 'ॐ ईशा वास्यमिदं सर्वं यत्किञ्च जगत्यां जगत् ।\nतेन त्यक्तेन भुञ्जीथा मा गृधः कस्यस्विद्धनम् ॥ १ ॥',
          transliteration: 'om īśā vāsyamidaṁ sarvaṁ yatkiñca jagatyāṁ jagat |\ntena tyaktena bhuñjīthā mā gṛdhaḥ kasyasviddhanam || 1 ||',
          originalTranslation:
              'All this, whatsoever moves in this moving world, is enveloped by the Lord. By renouncing it, find your enjoyment; do not covet the wealth of anyone.',
          commentary: 'The foundational mantra of Advaita: seeing the Divine in all manifestation.',
        ),
        const SacredVerse(
          number: 2,
          label: '२',
          sanskrit: 'कुर्वन्नेवेह कर्माणि जिजीविषेच्छतं समाः ।\nएवं त्वयि नान्यथेतोऽस्ति न कर्म लिप्यते नरे ॥ २ ॥',
          transliteration: 'kurvanneveha karmāṇi jijīviṣecchataṁ samāḥ |\nevaṁ tvayi nānyatheto\'sti na karma lipyate nare || 2 ||',
          originalTranslation:
              'Performing work in this world, one may wish to live a hundred years. Thus it is with thee, and not otherwise; work clings not to a person who acts without attachment.',
        ),
        const SacredVerse(
          number: 3,
          label: '३',
          sanskrit: 'असुर्या नाम ते लोका अन्धेन तमसाऽऽवृताः ।\nतांस्ते प्रेत्याभिगच्छन्ति ये के चात्महनो जनाः ॥ ३ ॥',
          transliteration: 'asuryā nāma te lokā andhena tamasā\'\'vṛtāḥ |\ntāṁste pretyābhigacchanti ye ke cātmahano janāḥ || 3 ||',
          originalTranslation:
              'Demonic verily are those worlds, enveloped in blinding darkness; thither after death go those who are slayers of the Self.',
        ),
        const SacredVerse(
          number: 4,
          label: '४',
          sanskrit: 'अनेजदेकं मनसो जवीयो नैनद्देवा आप्नुवन्पूर्वमर्षत् ।\nतद्धावतोऽन्यानत्येति तिष्ठत्तस्मिन्नपो मातरिश्वा दधाति ॥ ४ ॥',
          transliteration: 'anejadekaṁ manaso javīyo nainaddevā āpnuvanpūrvamarṣat |\ntaddhāvato\'nyānatyeti tiṣṭhattasminnapo mātariśvā dadhāti || 4 ||',
          originalTranslation:
              'Unmoving, One, swifter than the mind; the senses could not overtake It as It ran before them. Standing still, It overtakes those who run; in It the life-breath sustains all action.',
        ),
        const SacredVerse(
          number: 5,
          label: '५',
          sanskrit: 'तदेजति तन्नैजति तद्दूरे तद्वन्तिके ।\nतदन्तरस्य सर्वस्य तदु सर्वस्यास्य बाह्यतः ॥ ५ ॥',
          transliteration: 'tadejati tannaijati taddūre tadvantike |\ntadantarasya sarvasya tadu sarvasyāsya bāhyataḥ || 5 ||',
          originalTranslation:
              'It moves, yet It moves not; It is far away, yet It is near; It is within all this, and It is outside all this.',
        ),
        const SacredVerse(
          number: 6,
          label: '६',
          sanskrit: 'यस्तु सर्वाणि भूतान्यात्मन्येवानुपश्यति ।\nसर्वभूतेषु चात्मानं ततो न विजुगुप्सते ॥ ६ ॥',
          transliteration: 'yastu sarvāṇi bhūtānyātmanyevānupaśyati |\nsarvabhūteṣu cātmānaṁ tato na vijugupsate || 6 ||',
          originalTranslation:
              'He who sees all beings in the Self and the Self in all beings shrinks not from anything and feels no hatred.',
        ),
        const SacredVerse(
          number: 7,
          label: '७',
          sanskrit: 'यस्मिन्सर्वाणि भूतान्यात्मैवाभूद्विजानतः ।\nतत्र को मोहः कः शोक एकत्वमनुपश्यतः ॥ ७ ॥',
          transliteration: 'yasminsarvāṇi bhūtānyātmaivābhūdvijānataḥ |\ntatra ko mohaḥ kaḥ śoka ekatvamanupaśyataḥ || 7 ||',
          originalTranslation:
              'When to the seer all beings have verily become the Self, what delusion, what grief can there be for him who beholds oneness?',
        ),
        const SacredVerse(
          number: 8,
          label: '८',
          sanskrit: 'स पर्यगाच्छुक्रमकायमव्रणमस्नाविरं शुद्धमपापविद्धम् ।\nकविर्मनीषी परिभूः स्वयम्भूर्याथातथ्यतोऽर्थान्व्यदधाच्छाश्वतीभ्यः समाभ्यः ॥ ८ ॥',
          transliteration: 'sa paryagācchukramakāyamavraṇamasnāviraṁ śuddhamapāpaviddham |\nkavirmanīṣī paribhūḥ svayambhūryāthātathyato\'rthānvyadadhācchāśvatībhyaḥ samābhyaḥ || 8 ||',
          originalTranslation:
              'He has attained the radiant, bodiless, invulnerable, pure, untainted by evil; the Seer, the Thinker, all-pervading, self-existent, who ordered all things rightly across eternal ages.',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'upanishad-mandukya',
      category: 'upanishads',
      title: 'Mandukya Upanishad',
      sanskritTitle: 'माण्डूक्योपनिषत्',
      subtitle: 'Atharvaveda · 12 Mantras · The Essence of OM and Turiya',
      sourceUrl: 'https://sanskritdocuments.org/upanishhat',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१',
          sanskrit: 'ॐ इत्येतदक्षरमिदँ सर्वं तस्योपव्याख्यानं भूतं भवद्भवविष्यदिति सर्वमोङ्कार एव ।\nयच्चान्यत् त्रिकालातीतं तदप्योङ्कार एव ॥ १ ॥',
          transliteration: 'om ityetedakṣaramidaṁ sarvaṁ tasyopavyākhyānaṁ bhūtaṁ bhavadbhaviṣyaditi sarvamoṅkāra eva |\nyaccānyat trikālātītaṁ tadapyoṅkāra eva || 1 ||',
          originalTranslation:
              'OM is all that is: past, present, and future are all verily the syllable OM; and whatever transcends the threefold division of time is also OM.',
        ),
        const SacredVerse(
          number: 2,
          label: '२',
          sanskrit: 'सर्वं ह्येतद् ब्रह्म अयमात्मा ब्रह्म सोऽयमात्मा चतुष्पात् ॥ २ ॥',
          transliteration: 'sarvaṁ hyetad brahma ayamātmā brahma so\'yamātmā catuṣpāt || 2 ||',
          originalTranslation:
              'All this is indeed Brahman. This Atman (Self) is Brahman (ayam ātmā brahma). This Atman has four quarters.',
        ),
        const SacredVerse(
          number: 7,
          label: '७',
          sanskrit: 'नान्तःप्रज्ञं न बहिष्प्रज्ञं नोभयतःप्रज्ञं न प्रज्ञानघनं न प्रज्ञं नाप्रज्ञम् ।\nअदृष्टमव्यवहार्यमग्राह्यमलक्षणमचिन्त्यमव्यपदेश्यमेकात्मप्रत्ययसारं प्रपञ्चोपशमं शान्तं शिवमद्वैतं चतुर्थं मन्यन्ते स आत्मा स विज्ञेयः ॥ ७ ॥',
          transliteration: 'nāntaḥprajñaṁ na bahiṣprajñaṁ nobhayataḥprajñaṁ na prajñānaghanaṁ na prajñaṁ nāprajñam |\nadṛṣṭamavyavahāryamagrāhyamalakṣaṇamacintyamavyapadeśyamekātmapratyayasāraṁ prapañcopaśamaṁ śāntaṁ śivamadvaitaṁ caturthaṁ manyante sa ātmā sa vijñeyaḥ || 7 ||',
          originalTranslation:
              'Neither inward conscious nor outward conscious, unperceivable, beyond word, peaceful, auspicious, non-dual (advaitam)—this is known as the Fourth (Turiya). It is the Self, and It is to be realized.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // 3. PURANAS (https://sanskritdocuments.org/doc_purana)
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'purana-bhagavatam',
      category: 'puranas',
      title: 'Srimad Bhagavatam (Maha Purana)',
      sanskritTitle: 'श्रीमद्भागवतम्',
      subtitle: 'Skandha 1 · Adhyaya 1 · The Supreme Nectar of Devotion',
      sourceUrl: 'https://sanskritdocuments.org/doc_purana',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१.१',
          sanskrit: 'ॐ नमो भगवते वासुदेवाय ।\nजन्माद्यस्य यतोऽन्वयादितरतश्चार्थेष्वभिज्ञः स्वराट्\nतेने ब्रह्म हृदा य आदिकवये मुह्यन्ति यत्सूरयः ।\nतेजोवारिमृदां यथा विनिमयो यत्र त्रिसर्गोऽमृषा\nधाम्ना स्वेन सदा निरस्तकुहकं सत्यं परं धीमहि ॥ १.१.१',
          transliteration: 'om namo bhagavate vāsudevāya |\njanmādyasya yato\'nvayāditarataścārtheṣvabhijñaḥ svarāṭ\ntene brahma hṛdā ya ādikavaye muhyanti yatsūrayaḥ |\ntejovārimṛdāṁ yathā vinimayo yatra trisargo\'mṛṣā\ndhāmnā svena sadā nirastakuhakaṁ satyaṁ paraṁ dhīmahi || 1.1.1',
          originalTranslation:
              'We meditate upon the Supreme Truth (Satyam Param Dhimahi), from whom creation, sustenance, and dissolution proceed; who is self-effulgent and revealed the Vedas in the heart of Brahma.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.१.२',
          sanskrit: 'धर्मः प्रोज्झितकैतवोऽत्र परमो निर्मत्सराणां सतां\nवेद्यं वास्तवमत्र वस्तु शिवदं तापत्रयोन्मूलनम् ।\nश्रीमद्भागवते महामुनिकृते किं वा परैरीश्वरः\nसद्यो हृद्यवरुध्यतेऽत्र कृतिभिः शुश्रूषुभिस्तत्क्षणात् ॥ १.१.२',
          transliteration: 'dharmaḥ projjhitakaitavo\'tra paramo nirmatsarāṇāṁ satāṁ\nvedyaṁ vāstavamatra vastu śivadaṁ tāpatrayonmūlanam |\nśrīmadbhāgavate mahāmunikṛte kiṁ vā parairīśvaraḥ\nsadyo hṛdyavarudhyate\'tra kṛtibhiḥ śuśrūṣubhistatkṣaṇāt || 1.1.2',
          originalTranslation:
              'In this Bhagavata Purana, pure unmotivated dharma is proclaimed. Here the absolute reality is taught for the welfare of all, uprooting the threefold sufferings.',
        ),
        const SacredVerse(
          number: 3,
          label: '१.१.३',
          sanskrit: 'निगमकल्पतरोर्गलितं फलं शुकमुखादमृतद्रवसंयुतम् ।\nपिबत भागवतं रसमालयं मुहुरहो रसिका भुवि भावुकाः ॥ १.१.३',
          transliteration: 'nigamakalpatarorgalitaṁ phalaṁ śukamukhādamṛtadravasaṁyutam |\npibata bhāgavataṁ rasamālayaṁ muhuraho rasikā bhuvi bhāvukāḥ || 1.1.3',
          originalTranslation:
              'O knowers of divine sweetness, drink deeply again and again of this nectar of Srimad Bhagavatam, the mature fruit of the wish-fulfilling tree of the Vedas.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // 4. ITIHASA: RAMAYANA & MAHABHARATA (https://sanskritdocuments.org/itihasa)
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'itihasa-ramayana-mula',
      category: 'epics',
      title: 'Valmiki Ramayana: Mula Ramayana',
      sanskritTitle: 'श्रीमद्वाल्मीकिरामायणम् - बालकाण्डम्',
      subtitle: 'Bala Kanda · Sarga 1 · The Ideal Human and King',
      sourceUrl: 'https://sanskritdocuments.org/itihasa',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१.१',
          sanskrit: 'तपःस्वाध्यायिरतं तपस्वी वाग्विदां वरम् ।\nनारदं परिपप्रच्छ वाल्मीकिर्मुनिपुङ्गवम् ॥ १.१.१',
          transliteration: 'tapaḥsvādhyāyirataṁ tapasvī vāgvidāṁ varam |\nnāradaṁ paripapraccha vālmīkirmunipuṅgavam || 1.1.1',
          originalTranslation:
              'The ascetic sage Valmiki asked Narada, pre-eminent among the masters of speech and devoted to austerity and self-study:',
        ),
        const SacredVerse(
          number: 2,
          label: '१.१.२',
          sanskrit: 'को न्वस्मिन् साम्प्रतं लोके गुणवान् कश्च वीर्यवान् ।\nधर्मज्ञश्च कृतज्ञश्च सत्यवाक्यो दृढव्रतः ॥ १.१.२',
          transliteration: 'ko nvasmin sāmprataṁ loke guṇavān kaśca vīryavān |\ndharmajñaśca kṛtajñaśca satyavākyo dṛḍhavrataḥ || 1.1.2',
          originalTranslation:
              'Who in this present world is truly virtuous, endowed with valor, knower of righteousness, grateful, truthful in speech, and firm in his vows?',
        ),
        const SacredVerse(
          number: 3,
          label: '१.१.८',
          sanskrit: 'इक्ष्वाकुवंशप्रभवो रामो नाम जनैः श्रुतः ।\nनियतात्मा महावीर्यो द्युतिमान् धृतिमान् वशी ॥ १.१.८',
          transliteration: 'ikṣvākuvaṁśaprabhavo rāmo nāma janaiḥ śrutaḥ |\nniyatātmā mahāvīryo dyutimān dhṛtimān vaśī || 1.1.8',
          originalTranslation:
              'Narada answered: Born in the line of Ikshvaku is Rama, renowned among men; self-controlled, mighty in valor, radiant, steadfast, and master of himself.',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'itihasa-yaksha-prashna',
      category: 'epics',
      title: 'Mahabharata: Yaksha Prashna',
      sanskritTitle: 'यक्षप्रश्नः (महाभारतम्)',
      subtitle: 'Vana Parva · Dharma-Baka Dialogue with Yudhishthira',
      sourceUrl: 'https://sanskritdocuments.org/itihasa',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१',
          sanskrit: 'किंस्विद् गुरुतरं भूमेः किंस्विद् उच्चतरं च खात् ।\nकिंस्विच्छीघ्रतरं वायोः किंस्विद् बहुतरं तृणात् ॥',
          transliteration: 'kiṁsvid gurutaraṁ bhūmeḥ kiṁsvid uccataraṁ ca khāt |\nkiṁsvidchīghrataraṁ vāyoḥ kiṁsvid bahutaraṁ tṛṇāt ||',
          originalTranslation:
              'Yaksha asked: What is heavier than earth? What is higher than heaven? What is swifter than wind? What is more manifold than grass?',
        ),
        const SacredVerse(
          number: 2,
          label: '२',
          sanskrit: 'माता गुरुतरा भूमेः खात् पितोच्चतरस्तथा ।\nमनः शीघ्रतरं वाताच्चिन्ता बहु Muse तृणात् ॥',
          transliteration: 'mātā gurutarā bhūmeḥ khāt pitoccatarastathā |\nmanaḥ śīghrataraṁ vātāccintā bahutarā tṛṇāt ||',
          originalTranslation:
              'Yudhishthira answered: The mother is heavier than earth; the father is higher than heaven; the mind is swifter than wind; worry is more pervasive than grass.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // 5. SHASTRAS (https://sanskritdocuments.org/shastra)
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'shastra-arthashastra',
      category: 'shastras',
      title: 'Kautilya: Artha Shastra',
      sanskritTitle: 'कौटिलीयम् अर्थशास्त्रम्',
      subtitle: 'Adhikarana 1 · Vinayadhikarika · The Foundation of Governance',
      sourceUrl: 'https://sanskritdocuments.org/shastra',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१.१',
          sanskrit: 'ॐ नमः शुक्रबृहस्पतिभ्याम् ।\nपृथिव्या लाभे पालने च यावन्त्यर्थशास्त्राणि पूर्वाचार्यैः प्रस्थापितानि प्रायशस्तानि संहृत्यैकमिदमर्थशास्त्रं कृतम् ॥',
          transliteration: 'om namaḥ śukrabṛhaspatibhyām |\npṛthivyā lābhe pālane ca yāvantyarthaśāstrāṇi pūrvācāryaiḥ prasthāpitāni prāyaśastāni saṁhṛtyaikamidamarthaśāstraṁ kṛtam ||',
          originalTranslation:
              'Salutation to Shukra and Brihaspati. This Arthashastra is made as a compendium of almost all previous treatises composed by early masters on the acquisition and maintenance of the state.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.१९.३४',
          sanskrit: 'प्रजासुखे सुखं राज्ञः प्रजानां च हिते हितम् ।\nनात्मप्रियं हितं राज्ञः प्रजानां तु प्रियं हितम् ॥',
          transliteration: 'prajāsukhe sukhaṁ rājñaḥ prajānāṁ ca hite hitam |\nnātmapriyaṁ hitaṁ rājñaḥ prajānāṁ tu priyaṁ hitam ||',
          originalTranslation:
              'In the happiness of the subjects lies the king\'s happiness; in their welfare his welfare. The king shall consider as good not what pleases himself, but what pleases his people.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // 6. YOGA (https://sanskritdocuments.org/yoga)
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'yoga-patanjali-samadhi',
      category: 'yoga',
      title: 'Patanjali Yoga Sutras: Samadhi Pada',
      sanskritTitle: 'पातञ्जलयोगसूत्राणि - समाधिपादः',
      subtitle: 'Chapter 1 · Sutras 1–12 · The Nature and Stillness of Mind',
      sourceUrl: 'https://sanskritdocuments.org/yoga',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१',
          sanskrit: 'अथ योगानुशासनम् ॥ १.१ ॥',
          transliteration: 'atha yogānuśāsanam || 1.1 ||',
          originalTranslation:
              'Now, therefore, the complete instruction and exposition of Yoga commences.',
          commentary: 'Atha indicates auspicious inception and readiness of the seeker.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.२',
          sanskrit: 'योगश्चित्तवृत्तिनिरोधः ॥ १.२ ॥',
          transliteration: 'yogaścittavṛttinirodhaḥ || 1.2 ||',
          originalTranslation:
              'Yoga is the cessation (stillness) of the modifications and fluctuations of the mind-stuff (chitta).',
          commentary: 'The definitive foundational definition of Yoga.',
        ),
        const SacredVerse(
          number: 3,
          label: '१.३',
          sanskrit: 'तदा द्रष्टुः स्वरूपेऽवस्थानम् ॥ १.३ ॥',
          transliteration: 'tadā draṣṭuḥ svarūpe\'vasthānam || 1.3 ||',
          originalTranslation:
              'Then the Seer (pure consciousness) abides in Its own true nature.',
        ),
        const SacredVerse(
          number: 4,
          label: '१.४',
          sanskrit: 'वृत्तिसारूप्यमितरत्र ॥ १.४ ॥',
          transliteration: 'vṛttisārūpyamitaratra || 1.4 ||',
          originalTranslation:
              'At other times, the Seer identifies with the modifications of the mind.',
        ),
        const SacredVerse(
          number: 12,
          label: '१.१२',
          sanskrit: 'अभ्यासवैराग्याभ्यां तन्निरोधः ॥ १.१२ ॥',
          transliteration: 'abhyāsavairāgyābhyāṁ tannirodhaḥ || 1.12 ||',
          originalTranslation:
              'The cessation of mind modifications is mastered through dedicated practice (abhyasa) and non-attachment (vairagya).',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // 7. VEDANTA (https://sanskritdocuments.org/vedanta)
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'vedanta-brahma-sutras',
      category: 'vedanta',
      title: 'Brahma Sutras: Chatus-Sutri',
      sanskritTitle: 'ब्रह्मसूत्राणि - चतुःसूत्री',
      subtitle: 'Badarayana Vyasa · The 4 Fundamental Pillars of Vedanta',
      sourceUrl: 'https://sanskritdocuments.org/vedanta',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१.१',
          sanskrit: 'अथातो ब्रह्मजिज्ञासा ॥ १.१.१ ॥',
          transliteration: 'athāto brahmajijñāsā || 1.1.1 ||',
          originalTranslation:
              'Henceforward, therefore, arises the profound inquiry into the nature of Brahman (the Ultimate Reality).',
        ),
        const SacredVerse(
          number: 2,
          label: '१.१.२',
          sanskrit: 'जन्माद्यस्य यतः ॥ १.१.२ ॥',
          transliteration: 'janmādyasya yataḥ || 1.1.2 ||',
          originalTranslation:
              'Brahman is that from which the origin, sustenance, and dissolution of this universe proceed.',
        ),
        const SacredVerse(
          number: 3,
          label: '१.१.३',
          sanskrit: 'शास्त्रयोनित्वात् ॥ १.१.३ ॥',
          transliteration: 'śāstrayonitvāt || 1.1.3 ||',
          originalTranslation:
              'Brahman is known through the sacred scriptures, for scripture is the source of right knowledge concerning It.',
        ),
        const SacredVerse(
          number: 4,
          label: '१.१.४',
          sanskrit: 'तत्तु समन्वयात् ॥ १.१.४ ॥',
          transliteration: 'tattu samanvayāt || 1.1.4 ||',
          originalTranslation:
              'All sacred texts in perfect harmony converge upon Brahman as their sole and supreme purport.',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'vedanta-vivekachudamani',
      category: 'vedanta',
      title: 'Vivekachudamani',
      sanskritTitle: 'विवेकचूडामणिः',
      subtitle: 'Adi Shankaracharya · The Crest-Jewel of Discrimination',
      sourceUrl: 'https://sanskritdocuments.org/vedanta',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१',
          sanskrit: 'सर्ववेदान्तसिद्धान्तगोचरं तमगोचरम् ।\nगोविन्दं परमानन्दं सद्गुरुं प्रणतोऽस्म्यहम् ॥ १ ॥',
          transliteration: 'sarvavedāntasiddhāntagocaraṁ tamagocaram |\ngovindaṁ paramānandaṁ sadguruṁ praṇato\'smyaham || 1 ||',
          originalTranslation:
              'I bow to Govinda, the Sadguru who is supreme bliss, knowable through the crest of all Vedanta, yet transcendent to sense perception.',
        ),
        const SacredVerse(
          number: 2,
          label: '२',
          sanskrit: 'जन्तूनां नरजन्म दुर्लभमतः पुंस्त्वं ततो विप्रता\nतस्माद्वैदिकधर्ममार्गपरता विद्वत्त्वमस्मात्परम् ।\nआत्मानात्मविवेचनं स्वनुभवो ब्रह्मात्मना संस्थितिर्मुक्तिर्नो शतकोटिजन्मसु कृतैः पुण्यैर्विना लभ्यते ॥ २ ॥',
          transliteration: 'jantūnāṁ narajanma durlabhamataḥ puṁstvaṁ tato vipratā\ntasmādvaidikadharmamārgaparatā vidvattvamasmātparam |\nātmānātmavivecanaṁ svanubhavo brahmātmanā saṁsthitirmuktirno śatakoṭijanmasu kṛtaiḥ puṇyairvinā labhyate || 2 ||',
          originalTranslation:
              'For all living beings, human birth is rare; rarer still is wisdom, discrimination between the Self and non-Self, and resting in Brahman as Liberation.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // 8. PRASTHANATRAYI (https://sanskritdocuments.org/prasthanatrayi)
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'prasthanatrayi-trio',
      category: 'prasthanatrayi',
      title: 'Prasthanatrayi: The Three Foundations',
      sanskritTitle: 'प्रस्थानत्रयीसमन्वयः',
      subtitle: 'Shruti (Upanishads) · Smriti (Bhagavad Gita) · Nyaya (Brahma Sutras)',
      sourceUrl: 'https://sanskritdocuments.org/prasthanatrayi',
      verses: [
        const SacredVerse(
          number: 1,
          label: 'श्रुतिप्रस्थानम्',
          sanskrit: 'ॐ पूर्णमदः पूर्णमिदं पूर्णात्पूर्णमुदच्यते ।\nपूर्णस्य पूर्णमादाय पूर्णमेवावशिष्यते ॥\nॐ शान्तिः शान्तिः शान्तिः ॥',
          transliteration: 'om pūrṇamadaḥ pūrṇamidaṁ pūrṇātpūrṇamudacyate |\npūrṇasya pūrṇamādāya pūrṇamevāvaśiṣyate ||\nom śāntiḥ śāntiḥ śāntiḥ ||',
          originalTranslation:
              'Shruti Prasthana (Upanishad): That is Fullness, This is Fullness; from Fullness arises Fullness. When Fullness is drawn from Fullness, Fullness alone remains.',
        ),
        const SacredVerse(
          number: 2,
          label: 'स्मृतिप्रस्थानम्',
          sanskrit: 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन ।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि ॥ २.४७ ॥',
          transliteration: 'karmaṇyevādhikāraste mā phaleṣu kadācana |\nmā karmaphalaheturbhūrmā te saṅgo\'stvakarmaṇi || 2.47 ||',
          originalTranslation:
              'Smriti Prasthana (Bhagavad Gita): Thy right is to work only, but never with its fruits; let not the fruits of action be thy motive, nor let thy attachment be to inaction.',
        ),
        const SacredVerse(
          number: 3,
          label: 'न्यायप्रस्थानम्',
          sanskrit: 'अथातो ब्रह्मजिज्ञासा ॥ जन्माद्यस्य यतः ॥ १.१.१-२ ॥',
          transliteration: 'athāto brahmajijñāsā || janmādyasya yataḥ || 1.1.1-2 ||',
          originalTranslation:
              'Nyaya Prasthana (Brahma Sutras): Hence arises the inquiry into Brahman, the source from which the universe originates and sustains.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // 9. TANTRA (https://sanskritdocuments.org/tantra)
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'tantra-shiva-sutras',
      category: 'tantra',
      title: 'Shiva Sutras (Kashmir Shaivism)',
      sanskritTitle: 'शिवसूत्राणि',
      subtitle: 'Sage Vasugupta · The Nature of Universal Consciousness',
      sourceUrl: 'https://sanskritdocuments.org/tantra',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१',
          sanskrit: 'चैतन्यमात्मा ॥ १.१ ॥',
          transliteration: 'caitanyamātmā || 1.1 ||',
          originalTranslation:
              'Consciousness (Caitanya) is the true Self of all existence.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.२',
          sanskrit: 'ज्ञानं बन्धः ॥ १.२ ॥',
          transliteration: 'jñānaṁ bandhaḥ || 1.2 ||',
          originalTranslation:
              'Limited, fragmented, conditional knowledge is the root of bondage.',
        ),
        const SacredVerse(
          number: 3,
          label: '१.३',
          sanskrit: 'योनिवर्गः कलाशरीरम् ॥ १.३ ॥',
          transliteration: 'yonivargaḥ kalāśarīram || 1.3 ||',
          originalTranslation:
              'The illusion of separate embodiment arises from identification with the material womb of elements.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // 10. SMRITI (https://sanskritdocuments.org/smriti)
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'smriti-manusmriti',
      category: 'smriti',
      title: 'Manusmriti: Laws of Manu',
      sanskritTitle: 'मनुस्मृतिः',
      subtitle: 'Adhyaya 2 · The Foundations of Sanatana Dharma',
      sourceUrl: 'https://sanskritdocuments.org/smriti',
      verses: [
        const SacredVerse(
          number: 1,
          label: '२.१',
          sanskrit: 'विद्वद्भिः सेवितः सद्भिर्नित्यमद्वेषरागिभिः ।\nहृदयेनाभ्यनुज्ञातो यो धर्मस्तं निबोधत ॥ २.१ ॥',
          transliteration: 'vidvadbhiḥ sevitaḥ sadbhirnityamadveṣarāgibhiḥ |\nhṛdayenābhyanujñāto yo dharmastaṁ nibodhata || 2.1 ||',
          originalTranslation:
              'Learn that Dharma which is ever practiced by the wise and virtuous who are free from malice and passion, and approved by the pure conscience of the heart.',
        ),
        const SacredVerse(
          number: 2,
          label: '२.६',
          sanskrit: 'वेदोऽखिलो धर्ममूलं स्मृतिशीले च तद्विदाम् ।\nआचारश्चैव साधूनामात्मनस्तुष्टिरेव च ॥ २.६ ॥',
          transliteration: 'vedo\'khilo dharmamūlaṁ smṛtiśīle ca tadvidām |\nācāraścaiva sādhūnāmātmanastuṣṭireva ca || 2.6 ||',
          originalTranslation:
              'The entire Veda is the first source of sacred law; next the tradition and virtuous conduct of those who know the Veda; further the custom of holy men, and finally self-satisfaction (conscience).',
        ),
        const SacredVerse(
          number: 3,
          label: '२.२२४',
          sanskrit: 'धर्मादर्थो प्रभवति धर्मात् प्रभवते सुखम् ।\nधर्मेण लभते सर्वं धर्मसारमिदं जगत् ॥',
          transliteration: 'dharmādartho prabhavati dharmāt prabhavate sukham |\ndharmeṇa labhate sarvaṁ dharmasāramidaṁ jagat ||',
          originalTranslation:
              'From Dharma comes true wealth, from Dharma comes enduring happiness; through Dharma all things are attained, for Dharma is the essence of this universe.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // ADDITIONAL VEDAS
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'sama-veda-gana',
      category: 'vedas',
      title: 'Sama Veda: Chhanda Archika',
      sanskritTitle: 'सामवेदः छन्द आर्चिकम्',
      subtitle: 'Kauthuma Shakha · Agneya Parva & Sacred Melodies',
      sourceUrl: 'https://sanskritdocuments.org/sanskrit/veda',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१.१',
          sanskrit: 'अग्न आ याहि वीतये गृणानो हव्यदातये ।\nनि होता सत्सि बर्हिषि ॥ १.१ ॥',
          transliteration: 'agna ā yāhi vītaye gṛṇāno havyadātaye |\nni hotā satsi barhiṣi || 1.1 ||',
          originalTranslation: 'O Agni, come hither to the feast, praised for the banquet of oblations! Seat thyself as Hotar upon the sacred grass.',
          commentary: 'Rishi: Bharadvaja · Devata: Agni · The opening melody of the Sama Veda Samhita.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.१.२',
          sanskrit: 'तं घेमित्था नमस्विन उप स्वराजमासते ।\nअर्घं चिदस्मै तन्वे गृणन्ति ॥ १.२ ॥',
          transliteration: 'taṁ ghemitthā namasvina upa svarājamāsate |\narghaṁ cidasmai tanve gṛṇanti || 1.2 ||',
          originalTranslation: 'Thus with reverent homage men approach Him who shines by His own light, singing melodies to glorify His splendor.',
        ),
        const SacredVerse(
          number: 3,
          label: '१.१.३',
          sanskrit: 'तत्सवितुर्वरेण्यं भर्गो देवस्य धीमहि ।\nधियो यो नः प्रचोदयात् ॥ १.३ ॥',
          transliteration: 'tatsaviturvareṇyaṁ bhargo devasya dhīmahi |\ndhiyo yo naḥ pracodayāt || 1.3 ||',
          originalTranslation: 'May we meditate on the supreme brilliance of that divine Sun, Savitar; may He illumine our inner consciousness.',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'yajur-shukla-isha',
      category: 'vedas',
      title: 'Shukla Yajur Veda: Vajasaneyi Samhita',
      sanskritTitle: 'शुक्लयजुर्वेदः वाजसनेयिसंहिता (ईशोपनिषत्)',
      subtitle: 'Chapter 40 (Complete Ishavasya) · Madhyandina Shakha',
      sourceUrl: 'https://sanskritdocuments.org/sanskrit/veda',
      verses: [
        const SacredVerse(
          number: 1,
          label: '४०.१',
          sanskrit: 'ईशा वास्यमिदं सर्वं यत्किञ्च जगत्यां जगत् ।\nतेन त्यक्तेन भुञ्जीथा मा गृधः कस्यस्विद्धनम् ॥ ४०.१ ॥',
          transliteration: 'īśā vāsyamidaṁ sarvaṁ yatkiñca jagatyāṁ jagat |\ntena tyaktena bhuñjīthā mā gṛdhaḥ kasyasviddhanam || 40.1 ||',
          originalTranslation: 'All this, whatever moves in this moving world, is enveloped and indwelt by the Lord. Enjoy it through renunciation; do not covet any one\'s wealth.',
        ),
        const SacredVerse(
          number: 2,
          label: '४०.२',
          sanskrit: 'कुर्वन्नेवेह कर्माणि जिजीविषेच्छतं समाः ।\nएवं त्वयि नान्यथेतोऽस्ति न कर्म लिप्यते नरे ॥ ४०.२ ॥',
          transliteration: 'kurvanneveha karmāṇi jijīviṣecchataṁ samāḥ |\nevaṁ tvayi nānyatheto\'sti na karma lipyate nare || 40.2 ||',
          originalTranslation: 'Performing indeed works here, one may wish to live a hundred years. Thus in thee, and not otherwise, work does not cling to man.',
        ),
        const SacredVerse(
          number: 3,
          label: '४०.१५',
          sanskrit: 'वायुरनिलममृतमथेदं भस्मान्तं शरीरम् ।\nॐ क्रतो स्मर कृतं स्मर क्रतो स्मर कृतं स्मर ॥ ४०.१५ ॥',
          transliteration: 'vāyuranilamamṛtamathedaṁ bhasmāntaṁ śarīram |\noṁ krato smara kṛtaṁ smara krato smara kṛtaṁ smara || 40.15 ||',
          originalTranslation: 'May breath merge in immortal Prana, and this body end in ash. Om! O Will, remember what was done! Remember!',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'yajur-krishna-taittiriya',
      category: 'vedas',
      title: 'Krishna Yajur Veda: Sri Rudram',
      sanskritTitle: 'कृष्णयजुर्वेदः तैत्तिरीयसंहिता (रुद्रप्रश्नः)',
      subtitle: 'Taittiriya Samhita 4.5 · Sri Rudram Namakam',
      sourceUrl: 'https://sanskritdocuments.org/sanskrit/veda',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१',
          sanskrit: 'नमस्ते रुद्र मन्यव उतो त इषवे नमः ।\nनमस्ते अस्तु धन्वने बाहुभ्यामुत ते नमः ॥ १ ॥',
          transliteration: 'namaste rudra manyava uto ta iṣave namaḥ |\nnamaste astu dhanvane bāhubhyāmuta te namaḥ || 1 ||',
          originalTranslation: 'Salutations to Thy wrath, O Rudra, and salutations to Thine arrow! Salutations to Thy bow, and to Thy two mighty arms!',
          commentary: 'Rishi: Prajapati · Devata: Sri Rudra · The renowned opening of Sri Rudra Prashna.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.२',
          sanskrit: 'या ते रुद्र शिवा तनूरघोराऽपापकाशिनी ।\nतया नस्तनुवा शंतमया गिरिशन्ताभिचाकशीहि ॥ २ ॥',
          transliteration: 'yā te rudra śivā tanūraghorā\'pāpakāśinī |\ntayā nastanuvā śaṁtamayā giriśantābhicākaśīhi || 2 ||',
          originalTranslation: 'That form of Thine, O Rudra, which is auspicious, terrifying not, shedding holiness—with that most benevolent form, O Dweller on the mountain, look upon us graciously!',
        ),
        const SacredVerse(
          number: 3,
          label: '१.३',
          sanskrit: 'यामिषुं गिरिशन्त हस्ते बिभर्ष्यस्तवे ।\nशिवां गिरित्र तां कुरु मा हिंसीः पुरुषं जगत् ॥ ३ ॥',
          transliteration: 'yāmiṣuṁ giriśanta haste bibharṣyastave |\nśivāṁ giritra tāṁ kuru mā hiṁsīḥ puruṣaṁ jagat || 3 ||',
          originalTranslation: 'The arrow which Thou holdest in Thy hand to discharge, O Protector of the heights, make it auspicious; harm not mankind nor any creature of the universe!',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'atharva-veda-prithvi',
      category: 'vedas',
      title: 'Atharva Veda: Bhumi Suktam',
      sanskritTitle: 'अथर्ववेदः भूमिसूक्तम् (पृथिवीसूक्तम्)',
      subtitle: 'Kanda 12 · Sukta 1 · The Great Earth Hymn of Ecology',
      sourceUrl: 'https://sanskritdocuments.org/sanskrit/veda',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१२.१.१',
          sanskrit: 'सत्यं बृहदृतमुग्रं दीक्षा तपो ब्रह्म यज्ञः पृथिवीं धारयन्ति ।\nसा नो भूतस्य भव्यस्य पत्न्युरुं लोकं पृथिवी नः कृणोतु ॥ १२.१.१ ॥',
          transliteration: 'satyaṁ bṛhadṛtamugraṁ dīkṣā tapo brahma yajñaḥ pṛthivīṁ dhārayanti |\nsā no bhūtasya bhavyasya patnyuruṁ lokaṁ pṛthivī naḥ kṛṇotu || 12.1.1 ||',
          originalTranslation: 'Truth, vast Order, fiery spiritual fervor, consecration, prayer and sacrifice uphold the Earth. May She, the sovereign lady of past and future, open for us an ample realm!',
          commentary: 'Rishi: Atharva · Devata: Bhumi Devi (Mother Earth).',
        ),
        const SacredVerse(
          number: 2,
          label: '१२.१.२',
          sanskrit: 'असंबाधं मध्यतो मानवानां यस्या उद्वतः प्रवतः समं बहु ।\nनानावीर्या ओषधीर्विभर्ति पृथिवी नः प्रथतां राध्यतां नः ॥ १२.१.२ ॥',
          transliteration: 'asaṁbādhaṁ madhyato mānavānāṁ yasyā udvataḥ pravataḥ samaṁ bahu |\nnānāvīryā oṣadhīrvibharti pṛthivī naḥ prathatāṁ rādhyatāṁ naḥ || 12.1.2 ||',
          originalTranslation: 'Free from confinement amidst human beings, possessing highlands, slopes and vast plains, bearing plants of diverse healing virtues—may this Earth spread wide for us and prosper us!',
        ),
        const SacredVerse(
          number: 3,
          label: '१२.१.१२',
          sanskrit: 'माता भूमिः पुत्रो अहं पृथिव्याः पर्जन्यः पिता स उ नः पिपर्तु ॥ १२.१.१२ ॥',
          transliteration: 'mātā bhūmiḥ putro ahaṁ pṛthivyāḥ parjanyaḥ pitā sa u naḥ pipartu || 12.1.12 ||',
          originalTranslation: 'The Earth is my Mother; I am a child of the Earth! Rain and sky are my Father; may He nourish us with life-giving showers!',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'veda-sacred-mantras',
      category: 'vedas',
      title: 'Foundational Vedic Mantras',
      sanskritTitle: 'वेदोक्ताः महामन्त्राः',
      subtitle: 'Gayatri, Mahamrityunjaya, Pavamana & Shanti Mantras',
      sourceUrl: 'https://sanskritdocuments.org/sanskrit/veda',
      verses: [
        const SacredVerse(
          number: 1,
          label: 'गायत्री',
          sanskrit: 'ॐ भूर्भुवः स्वः तत्सवितुर्वरेण्यं भर्गो देवस्य धीमहि ।\nधियो यो नः प्रचोदयात् ॥',
          transliteration: 'oṁ bhūrbhuvaḥ svaḥ tatsaviturvareṇyaṁ bhargo devasya dhīmahi |\ndhiyo yo naḥ pracodayāt ||',
          originalTranslation: 'We meditate on the adorable glory of the radiant divine Sun, the Creator. May He inspire and guide our intellect and inner vision.',
          commentary: 'Rigveda 3.62.10 · Rishi: Vishvamitra · Chhandas: Gayatri · The mother of all mantras.',
        ),
        const SacredVerse(
          number: 2,
          label: 'महामृत्युञ्जय',
          sanskrit: 'ॐ त्र्यम्बकं यजामहे सुगन्धिं पुष्टिवर्धनम् ।\nउर्वारुकमिव बन्धनान्मृत्योर्मुक्षीय मामृतात् ॥',
          transliteration: 'oṁ tryambakaṁ yajāmahe sugandhiṁ puṣṭivardhanam |\nurvārukamiva bandhanānmṛtyormukṣīya māmṛtāt ||',
          originalTranslation: 'We worship the Three-eyed Lord Shiva, fragrant and nourishing all beings. Even as a ripe cucumber is liberated from its stem, so may we be freed from death to Immortality.',
          commentary: 'Rigveda 7.59.12 · Rishi: Vasishtha · Chhandas: Anushtup.',
        ),
        const SacredVerse(
          number: 3,
          label: 'पवमान',
          sanskrit: 'ॐ असतो मा सद्गमय ।\nतमसो मा ज्योतिर्गमय ।\nमृत्योर्मा अमृतं गमय ॥\nॐ शान्तिः शान्तिः शान्तिः ॥',
          transliteration: 'oṁ asato mā sadgamaya |\ntamaso mā jyotirgamaya |\nmṛtyormā amṛtaṁ gamaya ||\noṁ śāntiḥ śāntiḥ śāntiḥ ||',
          originalTranslation: 'Lead me from the unreal to the Real; lead me from darkness to Light; lead me from death to Immortality! Om Peace, Peace, Peace.',
          commentary: 'Brihadaranyaka Upanishad 1.3.28.',
        ),
        const SacredVerse(
          number: 4,
          label: 'शान्तिपाठ',
          sanskrit: 'ॐ सह नाववतु । सह नौ भुनक्तु ।\nसह वीर्यं करवावहै ।\nतेजस्वि नावधीतमस्तु मा विद्विषावहै ॥\nॐ शान्तिः शान्तिः शान्तिः ॥',
          transliteration: 'oṁ saha nāvavatu | saha nau bhunaktu |\nsaha vīryaṁ karavāvahai |\ntejasvi nāvadhītamastu mā vidviṣāvahai ||\noṁ śāntiḥ śāntiḥ śāntiḥ ||',
          originalTranslation: 'May the Divine protect us both together; may He nourish us both; may we work together with great energy; may our study be radiant; may there be no enmity between us! Om Peace, Peace, Peace.',
          commentary: 'Taittiriya Upanishad Shanti Patha.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // ADDITIONAL UPANISHADS
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'upanishad-katha',
      category: 'upanishads',
      title: 'Katha Upanishad',
      sanskritTitle: 'कठोपनिषत्',
      subtitle: 'Valli 1–2 · The Mystery of Death and the Eternal Self',
      sourceUrl: 'https://sanskritdocuments.org/upanishhat',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.२.१',
          sanskrit: 'अन्यच्छ्रेयोऽन्यदुतैव प्रेयस्ते उभे नानार्थे पुरुषं सिनीतः ।\nतयोः श्रेय आददानस्य साधुर्भवति हीयतेऽर्थाद्य उ प्रेयो वृणीते ॥ १.२.१ ॥',
          transliteration: 'anyacchreyo\'nyadutaiva preyaste ubhe nānārthe puruṣaṁ sinītaḥ |\ntayoḥ śreya ādadānasya sādhurbhavati hīyate\'rthādya u preyo vṛṇīte || 1.2.1 ||',
          originalTranslation: 'One thing is the Good (Shreyas), and quite another the Pleasant (Preyas). These two bind a man to diverse goals. Blessed is he who chooses the Good; he who chooses the Pleasant falls away from true fulfillment.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.२.१८',
          sanskrit: 'न जायते म्रियते वा विपश्चिन्नायं कुतश्चिन्न बभूव कश्चित् ।\nअजो नित्यः शाश्वतोऽयं पुराणो न हन्यते हन्यमाने शरीरे ॥ १.२.१८ ॥',
          transliteration: 'na jāyate mriyate vā vipaścinnāyaṁ kutaścinna babhūva kaścit |\najo nityaḥ śāśvato\'yaṁ purāṇo na hanyate hanyamāne śarīre || 1.2.18 ||',
          originalTranslation: 'The knowing Self is never born; nor does it ever die. It sprang from nothing, and nothing sprang from it. Unborn, eternal, everlasting, and ancient, it is not slain when the body is slain.',
        ),
        const SacredVerse(
          number: 3,
          label: '१.३.१४',
          sanskrit: 'उत्तिष्ठत जाग्रत प्राप्य वरान्निबोधत ।\nक्षुरस्य धारा निशिता दुरत्यया दुर्गं पथस्तत्कवयो वदन्ति ॥ १.३.१४ ॥',
          transliteration: 'uttiṣṭhata jāgrata prāpya varānnibodhata |\nkṣurasya dhārā niśitā duratyayā durgaṁ pathastatkavayo vadanti || 1.3.14 ||',
          originalTranslation: 'Arise! Awake! Approach the great teachers and realize the Truth! Sharp as the edge of a razor and hard to cross—difficult is that path, declare the sages.',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'upanishad-kena',
      category: 'upanishads',
      title: 'Kena Upanishad',
      sanskritTitle: 'केनोपनिषत्',
      subtitle: 'Khanda 1 · By Whom? The Eye of the Eye and Mind of the Mind',
      sourceUrl: 'https://sanskritdocuments.org/upanishhat',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१',
          sanskrit: 'केनेषितं पतति प्रेषितं मनः ।\nकेन प्राणः प्रथमः प्रैति युक्तः ।\nकेनेषितां वाचमिमां वदन्ति ।\nचक्षुः श्रोत्रं क उ देवो युनक्ति ॥ १.१ ॥',
          transliteration: 'keneṣitaṁ patati preṣitaṁ manaḥ |\nkena prāṇaḥ prathamaḥ praiti yuktaḥ |\nkeneṣitāṁ vācamimāṁ vadanti |\ncakṣuḥ śrotraṁ ka u devo yunakti || 1.1 ||',
          originalTranslation: 'By whom bidden does the mind soar to its targets? Directed by whom does life\'s first breath go forth? By whom willed do people speak these words? What luminous Power directs the eye and ear?',
        ),
        const SacredVerse(
          number: 2,
          label: '१.२',
          sanskrit: 'श्रोत्रस्य श्रोत्रं मनसो मनो यद्वाचो ह वाचं स उ प्राणस्य प्राणः ।\nचक्षुषश्चक्षुरतिमुच्य धीराः प्रेत्यास्माल्लोकादमृता भवन्ति ॥ १.२ ॥',
          transliteration: 'śrotrasya śrotraṁ manaso mano yadvāco ha vācaṁ sa u prāṇasya prāṇaḥ |\ncakṣuṣaścakṣuratimucya dhīrāḥ pretyāsmāllokādamṛtā bhavanti || 1.2 ||',
          originalTranslation: 'It is the Ear of the ear, the Mind of the mind, the Speech of speech, the Life of life, and the Eye of the eye. Renouncing the senses, the wise become immortal.',
        ),
        const SacredVerse(
          number: 3,
          label: '१.५',
          sanskrit: 'यद्वाचानभ्युदितं येन वागभ्युद्यते ।\nतदेव ब्रह्म त्वं विद्धि नेदं यदिदमुपासते ॥ १.५ ॥',
          transliteration: 'yadvācānabhyuditaṁ yena vāgabhyudyate |\ntadeva brahma tvaṁ viddhi nedaṁ yadidamupāsate || 1.5 ||',
          originalTranslation: 'That which cannot be expressed by speech, but that by which speech is expressed—know That alone as Brahman, and not this which people worship here.',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'upanishad-taittiriya',
      category: 'upanishads',
      title: 'Taittiriya Upanishad',
      sanskritTitle: 'तैत्तिरीयोपनिषत्',
      subtitle: 'Shikshavalli & Brahmanandavalli · Truth, Consciousness & Bliss',
      sourceUrl: 'https://sanskritdocuments.org/upanishhat',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.११.१',
          sanskrit: 'सत्यं वद । धर्मं चर ।\nस्वाध्यायान्मा प्रमदः ।\nआचार्याय प्रियं धनमाहृत्य प्रजातन्तुं मा व्यवच्छेत्सीः ॥ १.११.१ ॥',
          transliteration: 'satyaṁ vada | dharmaṁ cara |\nsvādhyāyānmā pramadaḥ |\nācāryāya priyaṁ dhanamāhṛtya prajātantuṁ mā vyavacchetsīḥ || 1.11.1 ||',
          originalTranslation: 'Speak the Truth. Practice Dharma. Never neglect sacred study. Offer dear gifts to the preceptor and break not the thread of family lineage.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.११.२',
          sanskrit: 'मातृदेवो भव । पितृदेवो भव ।\nआचार्यदेवो भव । अतिथिदेवो भव ॥ १.११.२ ॥',
          transliteration: 'mātṛdevo bhava | pitṛdevo bhava |\nācāryadevo bhava | atithidevo bhava || 1.11.2 ||',
          originalTranslation: 'May your Mother be your God. May your Father be your God. May your Teacher be your God. May your Guest be your God.',
        ),
        const SacredVerse(
          number: 3,
          label: '२.१.१',
          sanskrit: 'ॐ ब्रह्मविदाप्नोति परम् ।\nतदेषाऽभ्युक्ता ।\nसत्यं ज्ञानमनन्तं ब्रह्म ।\nयो वेद निहितं गुहायां परमे व्योमन् ।\nसोऽश्नुते सर्वान् कामान्त्सह । ब्रह्मणा विपश्चितेति ॥ २.१.१ ॥',
          transliteration: 'oṁ brahmavidāpnoti param |\ntadeṣā\'bhyuktā |\nsatyaṁ jñānamanantaṁ brahma |\nyo veda nihitaṁ guhāyāṁ parame vyoman |\nso\'śnute sarvān kāmānttsaha | brahmaṇā vipaściteti || 2.1.1 ||',
          originalTranslation: 'He who knows Brahman attains the Supreme! Brahman is Truth, Knowledge, and Infinity. He who knows It hidden in the secret heart of hearts attains all desires in communion with the all-knowing Brahman.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // ADDITIONAL PURANAS
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'purana-vishnu',
      category: 'puranas',
      title: 'Vishnu Purana',
      sanskritTitle: 'विष्णुपुराणम्',
      subtitle: 'Amsha 1 · Cosmic Manifestation & the Nature of Vishnu',
      sourceUrl: 'https://sanskritdocuments.org/doc_purana',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.२.१',
          sanskrit: 'नमो हिरण्यगर्भाय हरये शङ्कराय च ।\nवासुदेवाय ताराय सृष्टिस्थित्यन्तकारिणे ॥ १.२.१ ॥',
          transliteration: 'namo hiraṇyagarbhāya haraye śaṅkarāya ca |\nvāsudevāya tārāya sṛṣṭisthityantakāriṇe || 1.2.1 ||',
          originalTranslation: 'Salutations to Hiranyagarbha, to Hari, and to Shankara; salutations to Vasudeva, the Deliverer, the Author of creation, preservation, and dissolution.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.२.६९',
          sanskrit: 'यदेतद् दृश्यते सर्वं जगत् स्थावरजङ्गमम् ।\nतदेतत् सर्वमेवैतद्विष्णो रूपं महात्मनः ॥ १.२.६९ ॥',
          transliteration: 'yadetad dṛśyate sarvaṁ jagat sthāvarajaṅgamam |\ntadetat sarvamevaitadviṣṇo rūpaṁ mahātmanaḥ || 1.2.69 ||',
          originalTranslation: 'Whatever is seen in this world, moving or stationary, all that is indeed the cosmic form of the Supreme Being, Vishnu.',
        ),
        const SacredVerse(
          number: 3,
          label: 'विष्णुध्यानम्',
          sanskrit: 'शान्ताकारं भुजगशयनं पद्मनाभं सुरेशं\nविश्वाधारं गगनसदृशं मेघवर्णं शुभाङ्गम् ।\nलक्ष्मीकान्तं कमलनयनं योगिभिर्ध्यानगम्यं\nवन्दे विष्णुं भवभयहरं सर्वलोकैकनाथम् ॥',
          transliteration: 'śāntākāraṁ bhujagaśayanaṁ padmanābhaṁ sureśaṁ\nviśvādhāraṁ gaganasadṛśaṁ meghavarṇaṁ śubhāṅgam |\nlakṣmīkāntaṁ kamalanayanaṁ yogibhirdhyānagamyaṁ\nvande viṣṇuṁ bhavabhayaharaṁ sarvalokaikanātham ||',
          originalTranslation: 'I bow unto Lord Vishnu, the serene one, reclining on the cosmic serpent, from whose navel sprouts the lotus, Lord of gods, support of the universe, vast like the sky, dark-hued like rain clouds, charming in every limb, Beloved of Lakshmi, lotus-eyed, realized by yogis in deep meditation, dispeller of the fears of worldly existence, the sole Sovereign of all worlds.',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'purana-shiva',
      category: 'puranas',
      title: 'Shiva Purana',
      sanskritTitle: 'शिवपुराणम्',
      subtitle: 'Vidyeshvara Samhita · The Supreme Tattva of Shiva',
      sourceUrl: 'https://sanskritdocuments.org/doc_purana',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१',
          sanskrit: 'जय शम्भो विभो सर्वजगद्व्यापिन् सदाशिव ।\nविश्वं त्वयि समाश्रित्य वर्तते सचराचरम् ॥',
          transliteration: 'jaya śambho vibho sarvajagadvyāpin sadāśiva |\nviśvaṁ tvayi samāśritya vartate sacarācaram ||',
          originalTranslation: 'Glory unto Thee, O Shambhu, all-pervading Sovereign of the universe, Sadashiva! Anchored in Thee alone rests the entire cosmic creation, both moving and still.',
        ),
        const SacredVerse(
          number: 2,
          label: 'शिवध्यानम्',
          sanskrit: 'ध्यायेन्नित्यं महेशं रजतगिरिनिभं चारुचन्द्रावतंसं\nरत्नाकल्पोज्ज्वलाङ्गं परशुमृगवराभीतिहस्तं प्रसन्नम् ।\nपद्मासीनं समन्तात् स्तुतममरगणैर्व्याघ्रकृत्तिं वसानं\nविश्वाद्यं विश्वबीजं निखिलभयहरं पञ्चवक्त्रं त्रिनेत्रम् ॥',
          transliteration: 'dhyāyennityaṁ maheśaṁ rajatagirinibhaṁ cārucandrāvataṁsaṁ\nratnākalpojjvalāṅgaṁ paraśumṛgavarābhītihastaṁ prasannam |\npadmāsīnaṁ samantāt stutamamaragaṇairvyāghrakṛttiṁ vasānaṁ\nviśvādyaṁ viśvabījaṁ nikhilabhayaharaṁ pañcavaktraṁ trinetram ||',
          originalTranslation: 'One should ever meditate on Mahesha, shining like a silver mountain, crowned with the crescent moon, adorned with radiant gems, holding the battle-axe, the deer, offering boons and dispelling fear with His hands, serene, seated in lotus posture, praised by hosts of celestials, clad in tiger skin, the primal cause and seed of the cosmos, dispeller of all fear, five-faced and three-eyed.',
        ),
        const SacredVerse(
          number: 3,
          label: 'शिवपञ्चाक्षर',
          sanskrit: 'नागेन्द्रहाराय त्रिलोचनाय\nभस्माङ्गरागाय महेश्वराय ।\nनित्याय शुद्धाय दिगम्बराय\nतस्मै नकाराय नमः शिवाय ॥',
          transliteration: 'nāgendrahārāya trilocanāya\nbhasmāṅgarāgāya maheśvarāya |\nnityāya śuddhāya digambarāya\ntasmai nakārāya namaḥ śivāya ||',
          originalTranslation: 'To Him who wears the king of serpents as garland, the Three-eyed Lord, anointed with holy ash, the Supreme Sovereign, eternal, stainless, robed in the infinite directions—to Him, embodied as the syllable "Na", salutations to Shiva!',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'purana-garuda',
      category: 'puranas',
      title: 'Garuda Purana',
      sanskritTitle: 'गरुडपुराणम् (सारोद्धारः)',
      subtitle: 'Saroddhara · Karma, Liberation & the Eternal Soul',
      sourceUrl: 'https://sanskritdocuments.org/doc_purana',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१',
          sanskrit: 'यथा हि कुर्वतः कर्म तथा तस्य भवेत् फलम् ।\nसुखं वा यदि वा दुःखं प्राप्नोत्येव सुनिश्चितम् ॥',
          transliteration: 'yathā hi kurvataḥ karma tathā tasya bhavet phalam |\nsukhaṁ vā yadi vā duḥkhaṁ prāpnotyeva suniścitam ||',
          originalTranslation: 'As a man sows actions, precisely so does he reap their fruits. Whether joy or sorrow, the harvest of one\'s own deeds inevitably arrives.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.२',
          sanskrit: 'नास्ति विद्यासमं चक्षुर्नास्ति सत्यसमं तपः ।\nनास्ति रागसमं दुःखं नास्ति त्यागसमं सुखम् ॥',
          transliteration: 'nāsti vidyāsamaṁ cakṣurnāsti satyasamaṁ tapaḥ |\nnāsti rāgasamaṁ duḥkhaṁ nāsti tyāgasamaṁ sukham ||',
          originalTranslation: 'There is no eye equal to spiritual knowledge; there is no penance equal to Truth; there is no sorrow equal to attachment; there is no happiness equal to renunciation.',
        ),
        const SacredVerse(
          number: 3,
          label: '१.३',
          sanskrit: 'धर्मेण गम्यते स्वर्गो धर्मेणैव च मुच्यते ।\nअधर्मेण नरकं याति तस्माद् धर्मं समाचरेत् ॥',
          transliteration: 'dharmeṇa gamyate svargo dharmeṇaiva ca mucyate |\nadharmeṇa narakaṁ yāti tasmād dharmaṁ samācaret ||',
          originalTranslation: 'By righteousness one attains higher worlds; through Dharma one attains liberation. By unrighteousness alone is sorrow reaped; therefore let everyone walk in the path of Dharma.',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'purana-devi-mahatmya',
      category: 'puranas',
      title: 'Devi Mahatmya (Markandeya Purana)',
      sanskritTitle: 'मार्कण्डेयपुराणम् (देवीमाहात्म्यम् / दुर्गासप्तशती)',
      subtitle: 'Narayani Stuti · The Cosmic Sovereign & World Mother',
      sourceUrl: 'https://sanskritdocuments.org/doc_purana',
      verses: [
        const SacredVerse(
          number: 1,
          label: '११.९',
          sanskrit: 'सर्वमङ्गलमाङ्गल्ये शिवे सर्वार्थसाधिके ।\nशरण्ये त्र्यम्बके गौरि नारायणि नमोऽस्तु ते ॥ ११.९ ॥',
          transliteration: 'sarvamaṅgalamāṅgalye śive sarvārthasādhike |\nśaraṇye tryambake gauri nārāyaṇi namo\'stu te || 11.9 ||',
          originalTranslation: 'O Auspicious One of all auspiciousness! O Benevolent Giver of all good, fulfiller of all desires, worthy of all refuge, three-eyed Gauri, Narayani—salutations to Thee!',
          commentary: 'The crowning prayer of Devi Mahatmya (Durga Saptashati).',
        ),
        const SacredVerse(
          number: 2,
          label: '११.१०',
          sanskrit: 'सृष्टिस्थितिविनाशानां शक्तिभूते सनातनि ।\nगुणाश्रये गुणमये नारायणि नमोऽस्तु ते ॥ ११.१० ॥',
          transliteration: 'sṛṣṭisthitivināśānāṁ śaktibhūte sanātani |\nguṇāśraye guṇamaye nārāyaṇi namo\'stu te || 11.10 ||',
          originalTranslation: 'O Eternal Energy of cosmic creation, preservation, and dissolution, Abode of all attributes yet beyond them, Narayani—salutations to Thee!',
        ),
        const SacredVerse(
          number: 3,
          label: '११.११',
          sanskrit: 'शरणागतदीनार्तपरित्राणपरायणे ।\nसर्वस्यार्तिहरे देवि नारायणि नमोऽस्तु ते ॥ ११.११ ॥',
          transliteration: 'śaraṇāgatadīnārtaparitrāṇaparāyaṇe |\nsarvasyārtihare devi nārāyaṇi namo\'stu te || 11.11 ||',
          originalTranslation: 'O Thou who art intent on saving the surrendered, the afflicted and the distressed, dispeller of all suffering, O Divine Mother Narayani—salutations to Thee!',
        ),
        const SacredVerse(
          number: 4,
          label: '५.१४',
          sanskrit: 'या देवी सर्वभूतेषु मातृरूपेण संस्थिता ।\nनमस्तस्यै नमस्तस्यै नमस्तस्यै नमो नमः ॥',
          transliteration: 'yā devī sarvabhūteṣu mātṛrūpeṇa saṁsthitā |\nnamastasyai namastasyai namastasyai namo namaḥ ||',
          originalTranslation: 'To that Goddess who in all beings abides in the form of the Mother, salutations to Her, salutations to Her, salutations to Her again and again!',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // ADDITIONAL ITIHASA (RAMAYANA & MAHABHARATA)
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'itihasa-aditya-hridayam',
      category: 'epics',
      title: 'Valmiki Ramayana: Aditya Hridayam',
      sanskritTitle: 'वाल्मीकिरामायणम् (आदित्यहृदयम्)',
      subtitle: 'Yuddha Kanda Sarga 105 · Sage Agastya\'s Secret of Victory',
      sourceUrl: 'https://sanskritdocuments.org/itihasa',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१०५.१',
          sanskrit: 'ततो युद्धपरिश्रान्तं समरे चिन्तया स्थितम् ।\nरावणं चाग्रतो दृष्ट्वा युद्धाय समुपस्थितम् ॥ १०५.१ ॥',
          transliteration: 'tato yuddhaparidhrāntaṁ samare cintayā sthitam |\nrāvaṇaṁ cāgrato dṛṣṭvā yuddhāya samupasthitam || 105.1 ||',
          originalTranslation: 'Rama, standing exhausted on the battlefield and absorbed in deep thought, beheld Ravana advancing eagerly before him prepared for battle.',
        ),
        const SacredVerse(
          number: 2,
          label: '१०५.२',
          sanskrit: 'दैवतैश्च समागम्य द्रष्टुमभ्यागतो रणम् ।\nउपगम्याब्रवीद्राममगस्त्यो भगवानृषिः ॥ १०५.२ ॥',
          transliteration: 'daivataiśca samāgamya draṣṭumabhyāgato raṇam |\nupagamyābravīdrāmamagastyo bhagavānṛṣiḥ || 105.2 ||',
          originalTranslation: 'The venerable sage Agastya, who had arrived with the gods to witness the conflict, approached Rama and spoke these words.',
        ),
        const SacredVerse(
          number: 3,
          label: '१०५.३',
          sanskrit: 'राम राम महाबाहो शृणु गुह्यं सनातनम् ।\nयेन सर्वानरीन्वत्स समरे विजयिष्यसि ॥ १०५.३ ॥',
          transliteration: 'rāma rāma mahābāho śṛṇu guhyaṁ sanātanam |\nyena sarvānarīnvatsa samare vijayiṣyasi || 105.3 ||',
          originalTranslation: 'O Rama, O mighty-armed hero, listen to this eternal secret by which, my child, thou shalt conquer all enemies in battle!',
        ),
        const SacredVerse(
          number: 4,
          label: '१०५.४',
          sanskrit: 'आदित्यहृदयं पुण्यं सर्वशत्रुविनाशनम् ।\nजयावहं जपेत्रित्यमक्षयं परमं शुभम् ॥ १०५.४ ॥',
          transliteration: 'ādityahṛdayaṁ puṇyaṁ sarvaśatruvināśanam |\njayāvahaṁ japennityamakṣayaṁ paramaṁ śubham || 105.4 ||',
          originalTranslation: 'This is the sacred Aditya Hridayam, destroyer of all foes, bringer of complete victory, imperishable and highest auspiciousness—recite it always!',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'itihasa-vidura-niti',
      category: 'epics',
      title: 'Mahabharata: Vidura Niti',
      sanskritTitle: 'महाभारतम् (विदुरनीतिः)',
      subtitle: 'Udyoga Parva · Sage Vidura\'s Counsel on Wisdom & Statesmanship',
      sourceUrl: 'https://sanskritdocuments.org/itihasa',
      verses: [
        const SacredVerse(
          number: 1,
          label: '३३.१६',
          sanskrit: 'यस्य कृत्यं न जानन्ति मन्त्रं वा मन्त्रितं परे ।\nकृतमेवास्य जानन्ति स वै पण्डित उच्यते ॥ ३३.१६ ॥',
          transliteration: 'yasya kṛtyaṁ na jānanti mantraṁ vā mantritaṁ pare |\nkṛtamevāsya jānanti sa vai paṇḍita ucyate || 33.16 ||',
          originalTranslation: 'He whose purposes and counsel remain unperceived by others until they have been successfully accomplished—he alone is called truly wise.',
        ),
        const SacredVerse(
          number: 2,
          label: '३३.१७',
          sanskrit: 'यस्य कृत्यं न विघ्नन्ति शीतमुष्णं भयं रतिः ।\nसमृद्धिरसमृद्धिर्वा स वै पण्डित उच्यते ॥ ३३.१७ ॥',
          transliteration: 'yasya kṛtyaṁ na vighnanti śītamuṣṇaṁ bhayaṁ ratiḥ |\nsamṛddhirasamṛddhirvā sa vai paṇḍita ucyate || 33.17 ||',
          originalTranslation: 'He whose noble actions are not deflected by cold, heat, fear, desire, prosperity, or adversity—he alone is truly wise.',
        ),
        const SacredVerse(
          number: 3,
          label: '३३.४३',
          sanskrit: 'एकाकी न भुञ्जीत नैकश्चार्थान् प्रचिन्तयेत् ।\nनैको गच्छेच्चाध्वानं नैकः सुप्तेषु जागृयात् ॥ ३३.४३ ॥',
          transliteration: 'ekākī na bhuñjīta naikaścārthān pracintayet |\nnaiko gaccheccādhvānaṁ naikaḥ supteṣu jāgṛyāt || 33.43 ||',
          originalTranslation: 'One should not eat dainty delicacies alone, nor ponder affairs of wealth all alone; one should not walk a perilous path solitary, nor stay wakeful in isolation while all around are asleep.',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'itihasa-bhishma-stuti',
      category: 'epics',
      title: 'Mahabharata: Bhishma Stuti',
      sanskritTitle: 'महाभारतम् (भीष्मस्तुतिः)',
      subtitle: 'Shanti Parva · Bhishma\'s Final Hymn of Surrender to Sri Krishna',
      sourceUrl: 'https://sanskritdocuments.org/itihasa',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१',
          sanskrit: 'इति मतिरुपकल्पिता वितृष्णा भगवति सात्वतपुङ्गवे विभूम्नि ।\nस्वसुखमुपगते क्वचिद्विहर्तुं प्रकृतिकमुपेयुषि यद्भवप्रवाहः ॥',
          transliteration: 'iti matirupakalpitā vitṛṣṇā bhagavati sātvatapuṅgave vibhūmni |\nsvasukhamupagate kvacidvihartuṁ prakṛtikamupeyuṣi yadbhavapravāhaḥ ||',
          originalTranslation: 'May my mind, freed from all desires, be fully centered upon the Supreme Lord, the Lord of all, resting in His own eternal bliss, from whom flows the stream of all manifestation.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.२',
          sanskrit: 'त्रिभुवनकमनं तमालवर्णं रविकरगौरवराम्बरं दधाने ।\nवपुरलकवृताननाब्जधारं विजयसखे रतिरस्तु मेऽनवद्या ॥',
          transliteration: 'tribhuvanakamanaṁ tamālavarṇaṁ ravikaragauravarāmbaraṁ dadhāne |\nvapuralakavṛtānanābjadhāraṁ vijayasakhe ratirastu me\'navadyā ||',
          originalTranslation: 'May my unswerving devotion rest in the Friend of Arjuna, whose beauty charms the three worlds, dark like the tamala tree, robed in yellow garments shining like morning sunlight, with locks of hair playing upon His lotus face.',
        ),
        const SacredVerse(
          number: 3,
          label: '१.३',
          sanskrit: 'विजयरथकुटुम्ब आत्ततोत्रे धृतहयरश्मिनि तच्छ्रियेक्षणीये ।\nभगवति रतिरस्तु मे मुमूर्षोर्यमिह निरीक्ष्य हता गताः स्वरूपम् ॥',
          transliteration: 'vijayarathakuṭumba āttatotre dhṛtahayaraśmini tacchriyekṣaṇīye |\nbhagavati ratirastu me mumūrṣoryamiha nirīkṣya hatā gatāḥ svarūpam ||',
          originalTranslation: 'At this hour of departure, may my heart rest upon that Bhagavan who held the whip in one hand and the reins of Arjuna\'s horses in the other, whose radiant presence on the chariot bestowed liberation on all who beheld Him.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // ADDITIONAL SHASTRAS
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'shastra-apastamba',
      category: 'shastras',
      title: 'Apastamba Dharma Sutra',
      sanskritTitle: 'आपस्तम्बधर्मसूत्रम्',
      subtitle: 'Prashna 1 · Sacred Conduct, Morality & Self-Restraint',
      sourceUrl: 'https://sanskritdocuments.org/shastra',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१.१',
          sanskrit: 'अथातः सामयाचारिकान् धर्मान् व्याख्यास्यामः ॥ १.१.१ ॥',
          transliteration: 'athātaḥ sāmayācārikān dharmān vyākhyāsyāmaḥ || 1.1.1 ||',
          originalTranslation: 'Now, therefore, we shall expound the sacred duties and rules of noble conduct agreed upon by the virtuous.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.१.२',
          sanskrit: 'धर्मज्ञसमयः प्रमाणं वेदाश्च ॥ १.१.२ ॥',
          transliteration: 'dharmajñasamayaḥ pramāṇaṁ vedāśca || 1.1.2 ||',
          originalTranslation: 'The authority for Dharma is the consensus of those who know the sacred law, and the eternal Vedas.',
        ),
        const SacredVerse(
          number: 3,
          label: '१.८.२२',
          sanskrit: 'आत्मलाभान्न परं विद्यते ।\nतस्मादात्मनि संस्थितो धर्मं चरेत् ॥',
          transliteration: 'ātmalābhānna paraṁ vidyate |\ntasmādātmani saṁsthito dharmaṁ caret ||',
          originalTranslation: 'There is nothing higher than the attainment of the Self. Anchored in the Self, let one live in righteousness.',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'shastra-nyaya-sutras',
      category: 'shastras',
      title: 'Gautama Nyaya Sutras',
      sanskritTitle: 'न्यायसूत्राणि (गौतममुनिकृतानि)',
      subtitle: 'Adhyaya 1 · The Instruments of True Knowledge and Liberation',
      sourceUrl: 'https://sanskritdocuments.org/shastra',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१.१',
          sanskrit: 'प्रमाणप्रमेयसंशयप्रयोजनदृष्टान्तसिद्धान्तावयवतर्कनिर्णयवादजल्पवितण्डाहेत्वाभासच्छलजातिनिग्रहस्थानानां तत्त्वज्ञानान्निःश्रेयसाधिगमः ॥ १.१.१ ॥',
          transliteration: 'pramāṇaprameyasaṁśayaprayojanadṛṣṭāntasiddhāntāvayavatarkanirṇayavādajalpavitaṇḍāhetvābhāsacchalajātinigrahasthānānāṁ tattvajñānānniḥśreyasādhigamaḥ || 1.1.1 ||',
          originalTranslation: 'Supreme liberation is attained through true knowledge of the instruments of valid cognition, the objects of knowledge, doubt, purpose, example, established doctrine, syllogistic premises, hypothetical reasoning, conclusive judgment, philosophical discussion, disputation, cavil, fallacies, quibbles, futile objections, and vulnerable points.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.१.२',
          sanskrit: 'दुःखजन्मप्रवृत्तिदोषमिथ्याज्ञानानामुत्तरोत्तरापाये तदनन्तरापायादपवर्गः ॥ १.१.२ ॥',
          transliteration: 'duḥkhajanmapravṛttidoṣamithyājñānānāmuttarottarāpāye tadanantarāpāyādapavargaḥ || 1.1.2 ||',
          originalTranslation: 'Liberation results from the progressive destruction in reverse order of suffering, birth, activity, fault, and false knowledge.',
        ),
        const SacredVerse(
          number: 3,
          label: '१.१.३',
          sanskrit: 'प्रत्यक्षानुमानोपमानशब्दाः प्रमाणानि ॥ १.१.३ ॥',
          transliteration: 'pratyakṣānumānopamānaśabdāḥ pramāṇāni || 1.1.3 ||',
          originalTranslation: 'Direct perception, inference, analogy, and authoritative testimony are the valid means of knowledge.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // ADDITIONAL YOGA
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'yoga-patanjali-sadhana',
      category: 'yoga',
      title: 'Patanjali Yoga Sutras: Sadhana Pada',
      sanskritTitle: 'पातञ्जलयोगसूत्राणि (साधनपादः)',
      subtitle: 'Pada 2 · Kriya Yoga and the Eight Limbs of Ashtanga Yoga',
      sourceUrl: 'https://sanskritdocuments.org/yoga',
      verses: [
        const SacredVerse(
          number: 1,
          label: '२.१',
          sanskrit: 'तपःस्वाध्यायेश्वरप्रणिधानानि क्रियायोगः ॥ २.१ ॥',
          transliteration: 'tapaḥsvādhyāyeśvarapraṇidhānāni kriyāyogaḥ || 2.1 ||',
          originalTranslation: 'Austerity (self-discipline), sacred study, and devotion to the Lord constitute Kriya Yoga, the yoga of action.',
        ),
        const SacredVerse(
          number: 2,
          label: '२.२',
          sanskrit: 'समाधिभावनार्थः क्लेशतनूकरणार्थश्च ॥ २.२ ॥',
          transliteration: 'samādhibhāvanārthaḥ kleśatanūkaraṇārthaśca || 2.2 ||',
          originalTranslation: 'Its purpose is to cultivate meditative absorption (Samadhi) and to attenuate the afflictions (Kleshas).',
        ),
        const SacredVerse(
          number: 3,
          label: '२.३',
          sanskrit: 'अविद्यास्मितारागद्वेषाभिनिवेशाः क्लेशाः ॥ २.३ ॥',
          transliteration: 'avidyāsmitārāgadveṣābhiniveśāḥ kleśāḥ || 2.3 ||',
          originalTranslation: 'The afflictions are ignorance, egoism, attraction, aversion, and clinging to life.',
        ),
        const SacredVerse(
          number: 4,
          label: '२.२९',
          sanskrit: 'यमनियमासनप्राणायामप्रत्याहारधारणाध्यानसमाधयोऽष्टावङ्गानि ॥ २.२९ ॥',
          transliteration: 'yamaniyamāsanaprāṇāyāmapratyāhāradhāraṇādhyānasamādhayo\'ṣṭāvaṅgāni || 2.29 ||',
          originalTranslation: 'The eight limbs of yoga are: Yama (ethical restraints), Niyama (observances), Asana (posture), Pranayama (breath control), Pratyahara (sense withdrawal), Dharana (concentration), Dhyana (meditation), and Samadhi (absorption).',
        ),
      ],
    ),
    SacredVerseBook(
      id: 'yoga-hatha-pradipika',
      category: 'yoga',
      title: 'Hatha Yoga Pradipika',
      sanskritTitle: 'हठयोगप्रदीपिका (स्वात्मारामविरचिता)',
      subtitle: 'Upadesha 1 · Foundations of Asana, Energy and Raja Yoga',
      sourceUrl: 'https://sanskritdocuments.org/yoga',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१',
          sanskrit: 'श्रीआदिनाथाय नमोऽस्तु तस्मै येनोपदिष्टा हठयोगविद्या ।\nविभ्राजते प्रोन्नतराजयोगमारोढुमिच्छोरधिरोहिणीव ॥ १.१ ॥',
          transliteration: 'śrīādināthāya namo\'stu tasmai yenopadiṣṭā haṭhayogavidyā |\nvibhrājate pronnatarājayogamāroḍhumicchoradhirohiṇīva || 1.1 ||',
          originalTranslation: 'Salutations to the Primordial Lord Adinatha Shiva who imparted the sacred science of Hatha Yoga, which shines forth as a stairway for the seeker who aspires to ascend to the loftiest heights of Raja Yoga.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.१५',
          sanskrit: 'अत्याहारः प्रयासश्च प्रजल्पो नियमाग्रहः ।\nजनसङ्गश्च लौल्यं च षड्भिर्योगो विनश्यति ॥ १.१५ ॥',
          transliteration: 'atyāhāraḥ prayāsaśca prajalpo niyamāgrahaḥ |\njanasaṅgaśca laulyaṁ ca ṣaḍbhiryogo vinaśyati || 1.15 ||',
          originalTranslation: 'Over-eating, excessive exertion, talkativeness, rigid obstinacy in rules, promiscuous company, and restlessness of mind—by these six is Yoga destroyed.',
        ),
        const SacredVerse(
          number: 3,
          label: '१.१६',
          sanskrit: 'उत्साहात् साहसाद् धैर्यात् तत्त्वज्ञानाच्च निश्चयात् ।\nजनसङ्गपरित्यागात् षड्भिर्योगः प्रसिध्यति ॥ १.१६ ॥',
          transliteration: 'utsāhāt sāhasād dhairyāt tattvajñānācca niścayāt |\njanasaṅgaparityāgāt ṣaḍbhiryogaḥ prasidhyati || 1.16 ||',
          originalTranslation: 'Enthusiasm, bold courage, perseverance, discernment of Truth, unwavering resolve, and avoidance of frivolous company—by these six does Yoga succeed.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // ADDITIONAL VEDANTA
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'vedanta-upadesha-sahasri',
      category: 'vedanta',
      title: 'Upadesha Sahasri (Adi Shankara)',
      sanskritTitle: 'उपदेशसाहस्री (आदिशङ्कराचार्यविरचिता)',
      subtitle: 'Prakarana 1 · A Thousand Teachings on Non-Dual Realization',
      sourceUrl: 'https://sanskritdocuments.org/vedanta',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.१',
          sanskrit: 'चैतन्यं सर्वगं सर्वं सर्वभूतगुहाशयम् ।\nयत्सर्वविषयातीतं तस्मै सर्वविदे नमः ॥ १.१ ॥',
          transliteration: 'caitanyaṁ sarvagaṁ sarvaṁ sarvabhūtaguhāśayam |\nyatsarvaviṣayātītaṁ tasmai sarvavide namaḥ || 1.1 ||',
          originalTranslation: 'Salutations to that all-knowing Consciousness which is all-pervading, the All, residing in the secret cavity of all beings, transcendent over all objects!',
        ),
        const SacredVerse(
          number: 2,
          label: '१.२५',
          sanskrit: 'न मे देहेन संबन्धो न प्राणैर्न मनस्तथा ।\nविशुद्धज्ञानरूपोऽहं नित्यमुक्तः स्वभावतः ॥',
          transliteration: 'na me dehena saṁbandho na prāṇairna manastathā |\nviśuddhajñānarūpo\'haṁ nityamuktaḥ svabhāvataḥ ||',
          originalTranslation: 'I have no relationship with the body, nor with the vital pranas, nor with the mind. I am pure Knowledge, ever-free by my very nature.',
        ),
        const SacredVerse(
          number: 3,
          label: '१.२६',
          sanskrit: 'अहं ब्रह्मास्मीत्यनुभवात् सर्वसंसारविप्रमोक्षः ॥',
          transliteration: 'ahaṁ brahmāsmītyanubhavāt sarvasaṁsāravipramokṣaḥ ||',
          originalTranslation: 'From the immediate, direct living experience "I am Brahman", complete release from the cycle of worldly sorrow is attained.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // ADDITIONAL TANTRA
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'tantra-vijnana-bhairava',
      category: 'tantra',
      title: 'Vijnana Bhairava Tantra',
      sanskritTitle: 'विज्ञानभैरवतन्त्रम्',
      subtitle: 'The 112 Paths of Spontaneous Realization in Kashmir Shaivism',
      sourceUrl: 'https://sanskritdocuments.org/tantra',
      verses: [
        const SacredVerse(
          number: 1,
          label: '२४',
          sanskrit: 'ऊर्ध्वे प्राणो ह्यधो जीवो विसर्गात्मा परोच्चरेत् ।\nउत्पत्तिद्वितयस्थाने भरणाद् भरिता स्थितिः ॥ २४ ॥',
          transliteration: 'ūrdhve prāṇo hyadho jīvo visargātmā paroccaret |\nutpattidvitayasthāne bharaṇād bharitā sthitiḥ || 24 ||',
          originalTranslation: 'The breath of life ascends and descends; at the two points of turning, filled with serene presence, the supreme state of fullness unfolds.',
        ),
        const SacredVerse(
          number: 2,
          label: '२५',
          sanskrit: 'मरुतोऽन्तर्बहिर्वापि वियद्युक्तानुभूतये ।\nभैरव्या भैरवस्येत्थं भैरवि व्यज्यते वपुः ॥ २५ ॥',
          transliteration: 'maruto\'ntarbahirvāpi viyadyuktānubhūtaye |\nbhairavyā bhairavasyetthaṁ bhairavi vyajyate vapuḥ || 25 ||',
          originalTranslation: 'When the breath rests neither within nor without, in that luminous stillness of space, O Bhairavi, the transcendental nature of Bhairava is revealed.',
        ),
        const SacredVerse(
          number: 3,
          label: '३२',
          sanskrit: 'शिखिपक्षैश्चित्ररूपैर्मण्डलैः शून्यपञ्चकम् ।\nध्यायतोऽनुत्तरे शून्ये प्रवेशो हृदये भवेत् ॥ ३२ ॥',
          transliteration: 'śikhipakṣaiścitrarūpairmaṇḍalaiḥ śūnyapañcakam |\ndhyāyato\'nuttare śūnye praveśo hṛdaye bhavet || 32 ||',
          originalTranslation: 'Contemplating the five senses as radiant circular patterns like peacock feathers dissolves duality, opening into the supreme void of the heart.',
        ),
      ],
    ),

    // ------------------------------------------------------------------------
    // ADDITIONAL SMRITI
    // ------------------------------------------------------------------------
    SacredVerseBook(
      id: 'smriti-yajnavalkya',
      category: 'smriti',
      title: 'Yajnavalkya Smriti',
      sanskritTitle: 'याज्ञवल्क्यस्मृतिः',
      subtitle: 'Achara Kanda · The Golden Principles of Virtue & Conduct',
      sourceUrl: 'https://sanskritdocuments.org/smriti',
      verses: [
        const SacredVerse(
          number: 1,
          label: '१.७',
          sanskrit: 'श्रुतिः स्मृतिः सदाचारः स्वस्य च प्रियमात्मनः ।\nसम्यक्सङ्कल्पजः कामो धर्ममूलमिदं स्मृतम् ॥ १.७ ॥',
          transliteration: 'śrutiḥ smṛtiḥ sadācāraḥ svasya ca priyamātmanaḥ |\nsamyaksaṅkalpajaḥ kāmo dharmamūlamidaṁ smṛtam || 1.7 ||',
          originalTranslation: 'The Vedas, sacred tradition, the conduct of the virtuous, what is deeply agreeable to one\'s pure soul, and desire born of wholesome intention—these are the roots of sacred Dharma.',
        ),
        const SacredVerse(
          number: 2,
          label: '१.१२२',
          sanskrit: 'अहिंसा सत्यमस्तेयं शौचमिन्द्रियनिग्रहः ।\nदानं दमो दया शान्तिः सर्वेषां धर्मसाधनम् ॥ १.१२२ ॥',
          transliteration: 'ahiṁsā satyamasteyaṁ śaucamindriyanigrahaḥ |\ndānaṁ damo dayā śāntiḥ sarveṣāṁ dharmasādhanam || 1.122 ||',
          originalTranslation: 'Non-violence, truthfulness, non-stealing, purity, mastery of the senses, charity, self-control, compassion, and inner peace—these are the common path of Dharma for all humanity.',
        ),
      ],
    ),
  ];

  static List<SacredVerseBook> forCategory(String category) {
    return books.where((b) => b.category == category).toList();
  }

  static SacredVerseBook? findBook(String id) {
    for (final b in books) {
      if (b.id == id) return b;
    }
    return null;
  }
}

