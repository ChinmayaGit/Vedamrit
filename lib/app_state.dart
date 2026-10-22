import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'catalog.dart';
import 'cloud_repo.dart';
import 'gita_api.dart';
import 'gita_text.dart';
import 'library_api.dart';
import 'local_store.dart';
import 'models.dart';
import 'theme.dart';

class AppState extends ChangeNotifier {
  final store = LocalStore();
  late final GitaApi api = GitaApi(store);
  final library = LibraryApi();

  List<Chapter> chapters = bundledChapters;
  String uiLanguage = 'en';
  String readingLanguage = 'en';
  String language = 'en';
  String audioLanguage = '';
  String name = 'Seeker';
  double speed = 1;
  double textScale = 1;
  bool darkMode = false;
  bool amoledDark = false;
  String themePaletteId = 'saffron';
  bool showTransliteration = true;
  bool languageChosen = false;
  bool tapToToggleUi = true;
  bool autoResumeRecent = false;
  DailyQuote? quote;
  bool quoteLoading = false;
  String? quoteNote;
  ReadingSpot? spot;
  List<Bookmark> bookmarks = [];
  List<SavedBook> savedBooks = [];
  List<Thought> thoughts = [];
  List<CircleGroup> groups = [];
  List<TemplePost> posts = [];
  TaskProgress? activeTask;
  final Set<int> keptChapters = {};
  String? accountEmail;
  String? _boundUid;
  bool _applying = false;
  final Set<String> _savedPostIds = {};
  StreamSubscription<User?>? _authSub;
  StreamSubscription? _userSub;
  StreamSubscription? _thoughtSub;
  StreamSubscription? _groupSub;
  StreamSubscription? _templeSub;

  bool get usesCloud => CloudRepo.ready;

  bool get signedIn => !usesCloud || CloudRepo.uid != null;

  Future<void> load() async {
    await store.init();
    final legacyLang = store.getString('language') ?? 'en';
    uiLanguage = store.getString('uiLanguage') ?? legacyLang;
    readingLanguage = store.getString('readingLanguage') ?? legacyLang;
    language = readingLanguage;
    audioLanguage = store.getString('audioLanguage') ?? '';
    name = store.getString('name') ?? 'Seeker';
    speed = _storedSpeed(store.getString('speed'));
    textScale = _storedZoom(store.getString('zoom'));
    darkMode = store.getString('dark') == '1';
    amoledDark = store.getString('amoledDark') == '1';
    themePaletteId = store.getString('themePalette') ?? 'saffron';
    showTransliteration = store.getString('transliteration') != '0';
    tapToToggleUi = store.getString('tapToToggleUi') != '0';
    autoResumeRecent = store.getString('autoResumeRecent') == '1';
    languageChosen = store.getString('languageChosen') == '1';
    spot = _one('spot', ReadingSpot.fromJson);
    bookmarks = _list('bookmarks', Bookmark.fromJson);
    savedBooks = _list('books', SavedBook.fromJson);
    if (usesCloud) {
      thoughts = [];
      groups = [];
      posts = [];
      _authSub ??= CloudRepo.auth.authStateChanges().listen(_onAccount);
    } else {
      thoughts = store.contains('thoughts') ? _list('thoughts', Thought.fromJson) : seedThoughts();
      groups = store.contains('groups') ? _list('groups', CircleGroup.fromJson) : seedGroups();
      posts = store.contains('temples') ? _list('temples', TemplePost.fromJson) : seedTemples();
      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    final cachedQuote = store.getString('quote');
    if (store.getString('quoteDay') == dayKey() && cachedQuote != null) {
      try {
        quote = DailyQuote.fromJson((jsonDecode(cachedQuote) as Map).cast<String, dynamic>());
      } catch (_) {}
    }
    final cachedChapters = await store.readText('gita/chapters.json');
    if (cachedChapters != null) {
      try {
        final parsed = GitaApi.parseChapters(cachedChapters);
        if (parsed.isNotEmpty) chapters = parsed;
      } catch (_) {}
    }
    for (final chapter in chapters) {
      if (await api.hasChapter(chapter.number)) keptChapters.add(chapter.number);
    }
    if (!usesCloud) {
      if (!store.contains('thoughts')) await _saveThoughts();
      if (!store.contains('groups')) await _saveGroups();
      if (!store.contains('temples')) await _saveTemples();
    }
    notifyListeners();
  }

  Future<void> refreshChapters() async {
    try {
      final fresh = await api.fetchChapters();
      if (fresh.isNotEmpty) {
        chapters = fresh;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> loadQuoteOfDay() async {
    quoteLoading = quote == null;
    quoteNote = null;
    notifyListeners();
    final (chapter, verse) = locateVerse(dayIndex(chapters), chapters);
    try {
      final shloka = await openShloka(chapter, verse);
      quote = DailyQuote(
        chapter: shloka.chapter,
        verse: shloka.verse,
        sanskrit: shloka.sanskrit,
        transliteration: shloka.transliteration,
        gloss: shloka.englishSource ?? offlineQuote.gloss,
        author: shloka.englishAuthor,
      );
      await store.setString('quote', jsonEncode(quote!.toJson()));
      await store.setString('quoteDay', dayKey());
    } catch (_) {
      quote ??= offlineQuote;
      quoteNote = 'Showing a verse kept in the app. The Gita library did not answer.';
    }
    quoteLoading = false;
    notifyListeners();
  }

  Chapter? chapterOf(int number) {
    for (final chapter in chapters) {
      if (chapter.number == number) return chapter;
    }
    return null;
  }

  (int, int)? neighbor(int chapter, int verse, int delta) {
    final current = chapterOf(chapter);
    if (current == null || delta == 0) return null;
    if (delta > 0) {
      if (verse < current.verses) return (chapter, verse + 1);
      final next = chapterOf(chapter + 1);
      if (next == null) return null;
      return (next.number, 1);
    }
    if (verse > 1) return (chapter, verse - 1);
    final previous = chapterOf(chapter - 1);
    if (previous == null) return null;
    return (previous.number, previous.verses);
  }

  Future<Shloka> openShloka(int chapter, int verse) async {
    final cached = await api.cachedShloka(chapter, verse);
    if (cached != null) return cached;
    try {
      return await api.fetchShloka(chapter, verse);
    } catch (_) {
      await GitaText.ensure();
      final leaf = GitaText.leaf(chapter, verse);
      final sa = leaf?.sanskrit ?? '';
      final tr = leaf?.transliteration ?? '';
      final eng = GitaText.englishChapter(chapter);
      return Shloka(
        chapter: chapter,
        verse: verse,
        sanskrit: sa,
        transliteration: tr,
        voices: [
          if (sa.isNotEmpty) Voice(author: 'Sanskrit', language: 'sa', translation: sa),
          if (eng.isNotEmpty) Voice(author: 'Edwin Arnold', language: 'en', translation: eng),
        ],
        raw: jsonEncode({
          'chapter': chapter,
          'verse': verse,
          'slok': sa,
          'transliteration': tr,
        }),
      );
    }
  }

  Future<void> keepShloka(Shloka shloka) => api.persistShloka(shloka);

  Future<bool> shlokaKept(int chapter, int verse) => api.hasShloka(chapter, verse);

  Future<void> keepChapter(int number) async {
    if (activeTask != null) return;
    final chapter = chapterOf(number);
    if (chapter == null) return;
    var saved = 0;
    for (var verse = 1; verse <= chapter.verses; verse++) {
      activeTask = TaskProgress(
        id: 'chapter-$number',
        label: 'Keeping chapter $number · shloka $verse of ${chapter.verses}',
        value: (verse - 1) / chapter.verses,
      );
      notifyListeners();
      try {
        final shloka = await openShloka(number, verse);
        await api.persistShloka(shloka);
        saved += 1;
      } catch (_) {}
    }
    if (saved == chapter.verses) {
      await api.markChapter(number);
      keptChapters.add(number);
    }
    activeTask = null;
    notifyListeners();
  }

  Future<void> keepEntireGita() async {
    if (activeTask != null) return;
    for (final chapter in chapters) {
      if (keptChapters.contains(chapter.number)) continue;
      var saved = 0;
      for (var verse = 1; verse <= chapter.verses; verse++) {
        activeTask = TaskProgress(
          id: 'gita-all',
          label: 'Keeping the Gita · chapter ${chapter.number} of ${chapters.length}',
          value: (chapter.number - 1 + (verse / chapter.verses)) / chapters.length,
        );
        notifyListeners();
        try {
          final shloka = await openShloka(chapter.number, verse);
          await api.persistShloka(shloka);
          saved += 1;
        } catch (_) {}
      }
      if (saved == chapter.verses) {
        await api.markChapter(chapter.number);
        keptChapters.add(chapter.number);
      }
    }
    activeTask = null;
    notifyListeners();
  }

  void remember(ReadingSpot next) {
    spot = next;
    store.setString('spot', jsonEncode(next.toJson()));
    _pushUser({'spot': next.toJson()});
    notifyListeners();
  }

  String get audioCode => audioLanguage.isEmpty ? readingLanguage : audioLanguage;

  String get spokenLocale => ttsLocale(audioCode);

  void setUiLanguage(String code) {
    uiLanguage = code;
    languageChosen = true;
    store.setString('uiLanguage', code);
    store.setString('languageChosen', '1');
    _pushUser({'uiLanguage': code});
    notifyListeners();
  }

  void setReadingLanguage(String code) {
    readingLanguage = code;
    language = code;
    languageChosen = true;
    store.setString('readingLanguage', code);
    store.setString('language', code);
    store.setString('languageChosen', '1');
    _pushUser({'readingLanguage': code, 'language': code});
    notifyListeners();
  }

  void setLanguage(String code) {
    setReadingLanguage(code);
  }

  void setTapToToggleUi(bool value) {
    tapToToggleUi = value;
    store.setString('tapToToggleUi', value ? '1' : '0');
    notifyListeners();
  }

  void setAutoResumeRecent(bool value) {
    autoResumeRecent = value;
    store.setString('autoResumeRecent', value ? '1' : '0');
    notifyListeners();
  }

  void setAudioLanguage(String code) {
    audioLanguage = code;
    store.setString('audioLanguage', code);
    _pushUser({'audioLanguage': code});
    notifyListeners();
  }

  void setDarkMode(bool value) {
    darkMode = value;
    store.setString('dark', value ? '1' : '0');
    notifyListeners();
  }

  void setAmoledDark(bool value) {
    amoledDark = value;
    store.setString('amoledDark', value ? '1' : '0');
    notifyListeners();
  }

  void setThemePalette(String id) {
    themePaletteId = id;
    store.setString('themePalette', id);
    notifyListeners();
  }

  void setShowTransliteration(bool value) {
    showTransliteration = value;
    store.setString('transliteration', value ? '1' : '0');
    notifyListeners();
  }

  void setTextScale(double value) {
    textScale = _storedZoom(value.toString());
    store.setString('zoom', textScale.toString());
    notifyListeners();
  }

  void nudgeZoom(int delta) {
    final index = zoomSteps.indexWhere((step) => (step - textScale).abs() < 0.02);
    final next = (index < 0 ? 1 : index) + delta;
    if (next < 0 || next >= zoomSteps.length) return;
    setTextScale(zoomSteps[next]);
  }

  double _storedZoom(String? raw) {
    final parsed = double.tryParse(raw ?? '');
    if (parsed == null) return 1;
    for (final step in zoomSteps) {
      if ((step - parsed).abs() < 0.02) return step;
    }
    return 1;
  }

  void setName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    name = trimmed;
    store.setString('name', trimmed);
    final user = CloudRepo.ready ? CloudRepo.auth.currentUser : null;
    if (user != null) user.updateDisplayName(trimmed);
    _pushUser({'name': trimmed});
    notifyListeners();
  }

  void setSpeed(double value) {
    speed = _storedSpeed(value.toString());
    store.setString('speed', speed.toString());
    notifyListeners();
  }

  double _storedSpeed(String? raw) {
    final parsed = double.tryParse(raw ?? '');
    if (parsed == null) return 1;
    final stepped = (parsed.clamp(0.2, 3.0) * 10).round() / 10;
    return stepped;
  }

  bool bookmarked(String id) => bookmarks.any((mark) => mark.id == id);

  void toggleBookmark(Bookmark mark) {
    final index = bookmarks.indexWhere((item) => item.id == mark.id);
    if (index >= 0) {
      bookmarks.removeAt(index);
    } else {
      bookmarks.insert(0, mark);
    }
    _saveBookmarks();
    _pushUser({'bookmarks': bookmarks.map(CloudRepo.bookmarkMap).toList()});
    notifyListeners();
  }

  bool bookKept(String id) => savedBooks.any((book) => book.id == id);

  SavedBook? savedBook(String id) {
    for (final book in savedBooks) {
      if (book.id == id) return book;
    }
    return null;
  }

  Future<void> keepBook(RemoteBook book) async {
    if (activeTask != null) {
      throw const GitaException('Another download is still running.');
    }
    final root = store.root;
    if (root == null) {
      throw const GitaException('This phone has no place to keep the file.');
    }
    final file = await resolveDownload(library, book);
    if (file == null) {
      throw const GitaException('This listing has no public file to keep.');
    }
    activeTask = TaskProgress(id: book.id, label: 'Keeping “${book.title}”', value: null);
    notifyListeners();
    final client = http.Client();
    IOSink? sink;
    try {
      final request = http.Request('GET', Uri.parse(file.url));
      request.headers.addAll(apiHeaders);
      final response = await client.send(request).timeout(const Duration(minutes: 3));
      if (response.statusCode != 200) {
        throw GitaException('The file answered ${response.statusCode}.');
      }
      final safe = book.id.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
      final target = File('${root.path}/books/$safe.${file.kind}');
      await target.parent.create(recursive: true);
      sink = target.openWrite();
      var received = 0;
      var reported = 0;
      final total = response.contentLength ?? 0;
      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        if (received - reported > 80000) {
          reported = received;
          activeTask = TaskProgress(
            id: book.id,
            label: 'Keeping “${book.title}”',
            value: total > 0 ? received / total : null,
          );
          notifyListeners();
        }
      }
      await sink.close();
      sink = null;
      savedBooks.removeWhere((item) => item.id == book.id);
      savedBooks.insert(
        0,
        SavedBook(
          id: book.id,
          title: book.title,
          author: book.author,
          source: book.source,
          path: target.path,
          kind: file.kind,
        ),
      );
      await _saveBooks();
    } finally {
      await sink?.close();
      client.close();
      activeTask = null;
      notifyListeners();
    }
  }

  Future<void> removeBook(String id) async {
    final book = savedBook(id);
    savedBooks.removeWhere((item) => item.id == id);
    if (book != null) {
      final file = File(book.path);
      if (await file.exists()) await file.delete();
    }
    await _saveBooks();
    notifyListeners();
  }

  Future<String?> signInEmail(String email, String password) => CloudRepo.signInEmail(email, password);

  Future<String?> signUpEmail(String email, String password, String displayName) => CloudRepo.signUpEmail(email, password, displayName);

  Future<String?> signInGoogle() => CloudRepo.signInGoogle();

  Future<void> signOut() => CloudRepo.signOut();

  void addThought(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    if (usesCloud) {
      final authorId = CloudRepo.uid;
      if (authorId == null) return;
      CloudRepo.addThought(authorId: authorId, author: name, text: trimmed);
      return;
    }
    thoughts.insert(
      0,
      Thought(
        id: 'thought-${DateTime.now().microsecondsSinceEpoch}',
        author: name,
        text: trimmed,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        mine: true,
      ),
    );
    _saveThoughts();
    notifyListeners();
  }

  void likeThought(String id) {
    Thought? thought;
    for (final item in thoughts) {
      if (item.id == id) thought = item;
    }
    if (thought == null) return;
    if (usesCloud) {
      final authorId = CloudRepo.uid;
      if (authorId == null) return;
      CloudRepo.likeThought(id, authorId, alreadyLiked: thought.liked);
      return;
    }
    thought.liked = !thought.liked;
    thought.likes += thought.liked ? 1 : -1;
    if (thought.likes < 0) thought.likes = 0;
    _saveThoughts();
    notifyListeners();
  }

  void deleteThought(String id) {
    if (usesCloud) {
      Thought? thought;
      for (final item in thoughts) {
        if (item.id == id) thought = item;
      }
      if (thought == null || !thought.mine) return;
      CloudRepo.deleteThought(id);
      return;
    }
    thoughts.removeWhere((thought) => thought.id == id && thought.mine);
    _saveThoughts();
    notifyListeners();
  }

  void addGroup(String title, String about) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    final id = 'group-${DateTime.now().microsecondsSinceEpoch}';
    final group = CircleGroup(
      id: id,
      name: trimmed,
      about: about.trim(),
      ownerId: CloudRepo.uid ?? '',
      channels: [Channel(id: '$id-general', name: 'general')],
    );
    if (usesCloud) {
      if (CloudRepo.uid == null) return;
      CloudRepo.createGroup(group);
      return;
    }
    groups.insert(0, group);
    _saveGroups();
    notifyListeners();
  }

  void addChannel(String groupId, String title) {
    final group = _group(groupId);
    final trimmed = title.trim();
    if (group == null || trimmed.isEmpty) return;
    group.channels.add(Channel(id: 'channel-${DateTime.now().microsecondsSinceEpoch}', name: trimmed));
    if (usesCloud) {
      CloudRepo.saveGroup(group);
      notifyListeners();
      return;
    }
    _saveGroups();
    notifyListeners();
  }

  void sendMessage(String groupId, String channelId, String text) {
    final group = _group(groupId);
    if (group == null) return;
    Channel? channel;
    for (final item in group.channels) {
      if (item.id == channelId) channel = item;
    }
    final trimmed = text.trim();
    if (channel == null || trimmed.isEmpty) return;
    channel.messages.add(
      ChatMessage(
        id: 'msg-${DateTime.now().microsecondsSinceEpoch}',
        author: name,
        text: trimmed,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        mine: true,
        authorId: CloudRepo.uid ?? '',
      ),
    );
    if (usesCloud) {
      CloudRepo.saveGroup(group);
      notifyListeners();
      return;
    }
    _saveGroups();
    notifyListeners();
  }

  void addPost({
    required String temple,
    required String place,
    required String scripture,
    required String meaning,
    required String value,
    required String visit,
    String? imagePath,
  }) {
    if (temple.trim().isEmpty || meaning.trim().isEmpty) return;
    posts.insert(
      0,
      TemplePost(
        id: 'temple-${DateTime.now().microsecondsSinceEpoch}',
        name: temple.trim(),
        place: place.trim(),
        scripture: scripture.trim(),
        meaning: meaning.trim(),
        value: value.trim(),
        visit: visit.trim(),
        imagePath: imagePath,
        author: name,
        hue: posts.length % 8,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        mine: true,
      ),
    );
    if (usesCloud) {
      final authorId = CloudRepo.uid;
      if (authorId == null) {
        posts.removeAt(0);
        return;
      }
      CloudRepo.addTemple(posts.first, authorId);
      notifyListeners();
      return;
    }
    _saveTemples();
    notifyListeners();
  }

  void reactPost(String id, {required bool like}) {
    final post = _post(id);
    if (post == null) return;
    if (usesCloud) {
      final authorId = CloudRepo.uid;
      if (authorId == null) return;
      CloudRepo.reactTemple(id, authorId, like: like, wasLiked: post.liked, wasDisliked: post.disliked);
      return;
    }
    if (like) {
      if (post.liked) {
        post.liked = false;
        post.likes = _down(post.likes);
      } else {
        post.liked = true;
        post.likes += 1;
        if (post.disliked) {
          post.disliked = false;
          post.dislikes = _down(post.dislikes);
        }
      }
    } else if (post.disliked) {
      post.disliked = false;
      post.dislikes = _down(post.dislikes);
    } else {
      post.disliked = true;
      post.dislikes += 1;
      if (post.liked) {
        post.liked = false;
        post.likes = _down(post.likes);
      }
    }
    _saveTemples();
    notifyListeners();
  }

  void toggleSavePost(String id) {
    final post = _post(id);
    if (post == null) return;
    post.saved = !post.saved;
    if (post.saved) {
      _savedPostIds.add(id);
    } else {
      _savedPostIds.remove(id);
    }
    if (usesCloud) {
      _pushUser({'savedPostIds': _savedPostIds.toList()});
      notifyListeners();
      return;
    }
    _saveTemples();
    notifyListeners();
  }

  void addComment(String id, String text) {
    final post = _post(id);
    final trimmed = text.trim();
    if (post == null || trimmed.isEmpty) return;
    post.comments.add(
      TempleComment(
        id: 'note-${DateTime.now().microsecondsSinceEpoch}',
        author: name,
        text: trimmed,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        mine: true,
        authorId: CloudRepo.uid ?? '',
      ),
    );
    if (usesCloud) {
      CloudRepo.saveComments(post);
      notifyListeners();
      return;
    }
    _saveTemples();
    notifyListeners();
  }

  void deletePost(String id) {
    final post = _post(id);
    if (post == null || !post.mine) return;
    final path = post.imagePath;
    posts.removeWhere((item) => item.id == id);
    if (path != null && !path.startsWith('http')) {
      final file = File(path);
      if (file.existsSync()) file.deleteSync();
    }
    if (usesCloud) {
      CloudRepo.deleteTemple(id);
      return;
    }
    _saveTemples();
    notifyListeners();
  }

  Future<void> _onAccount(User? user) async {
    final next = user?.uid;
    if (next == _boundUid && next != null) {
      accountEmail = user?.email;
      notifyListeners();
      return;
    }
    await _userSub?.cancel();
    await _thoughtSub?.cancel();
    await _groupSub?.cancel();
    await _templeSub?.cancel();
    _userSub = null;
    _thoughtSub = null;
    _groupSub = null;
    _templeSub = null;
    final previous = _boundUid;
    _boundUid = next;
    accountEmail = user?.email;
    if (user == null) {
      thoughts = [];
      groups = [];
      posts = [];
      if (previous != null) {
        bookmarks = [];
        spot = null;
        _savedPostIds.clear();
        await _saveBookmarks();
      }
      notifyListeners();
      return;
    }
    final display = user.displayName;
    if (display != null && display.trim().isNotEmpty) name = display.trim();
    final ref = CloudRepo.userRef(user.uid);
    final existing = await ref.get();
    if (!existing.exists) {
      await CloudRepo.mergeUser(user.uid, {
        'name': name,
        'email': user.email ?? '',
        'language': language,
        'audioLanguage': audioLanguage,
        'bookmarks': bookmarks.map(CloudRepo.bookmarkMap).toList(),
        if (spot != null) 'spot': spot!.toJson(),
        'savedPostIds': <String>[],
      });
    }
    _userSub = CloudRepo.userStream(user.uid).listen((snap) {
      final data = snap.data();
      if (data != null) _applyUser(data);
    });
    _thoughtSub = CloudRepo.thoughts(user.uid).listen((nextThoughts) {
      thoughts = nextThoughts;
      notifyListeners();
    });
    _groupSub = CloudRepo.groups(user.uid).listen((nextGroups) {
      groups = nextGroups;
      notifyListeners();
    });
    _templeSub = CloudRepo.temples(user.uid, _savedPostIds).listen((nextPosts) {
      posts = nextPosts;
      notifyListeners();
    });
    notifyListeners();
  }

  void _applyUser(Map<String, dynamic> data) {
    _applying = true;
    final remoteName = data['name'];
    if (remoteName is String && remoteName.trim().isNotEmpty) name = remoteName.trim();
    final remoteUi = data['uiLanguage'];
    if (remoteUi is String && remoteUi.isNotEmpty && remoteUi != uiLanguage) {
      uiLanguage = remoteUi;
      store.setString('uiLanguage', uiLanguage);
    }
    final remoteReading = data['readingLanguage'] ?? data['language'];
    if (remoteReading is String && remoteReading.isNotEmpty && remoteReading != readingLanguage) {
      readingLanguage = remoteReading;
      language = readingLanguage;
      store.setString('readingLanguage', readingLanguage);
      store.setString('language', language);
      languageChosen = true;
      store.setString('languageChosen', '1');
    }
    if (data['audioLanguage'] is String) {
      audioLanguage = data['audioLanguage'] as String;
      store.setString('audioLanguage', audioLanguage);
    }
    if (data['bookmarks'] is List) {
      bookmarks = CloudRepo.bookmarksFrom(data['bookmarks']);
      _saveBookmarks();
    }
    final remoteSpot = data['spot'];
    if (remoteSpot is Map) {
      spot = ReadingSpot.fromJson(remoteSpot.cast<String, dynamic>());
      store.setString('spot', jsonEncode(spot!.toJson()));
    }
    _savedPostIds
      ..clear()
      ..addAll(data['savedPostIds'] is List ? (data['savedPostIds'] as List).map((item) => '$item') : const []);
    for (final post in posts) {
      post.saved = _savedPostIds.contains(post.id);
    }
    _applying = false;
    notifyListeners();
  }

  void _pushUser(Map<String, dynamic> data) {
    final uid = CloudRepo.uid;
    if (!usesCloud || uid == null || _applying) return;
    CloudRepo.mergeUser(uid, data);
  }

  CircleGroup? _group(String id) {
    for (final group in groups) {
      if (group.id == id) return group;
    }
    return null;
  }

  TemplePost? _post(String id) {
    for (final post in posts) {
      if (post.id == id) return post;
    }
    return null;
  }

  int _down(int value) => value > 0 ? value - 1 : 0;

  List<T> _list<T>(String key, T Function(Map<String, dynamic>) parse) {
    final raw = store.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded.whereType<Map>().map((item) => parse(item.cast<String, dynamic>())).toList();
    } catch (_) {
      return [];
    }
  }

  T? _one<T>(String key, T Function(Map<String, dynamic>) parse) {
    final raw = store.getString(key);
    if (raw == null) return null;
    try {
      return parse((jsonDecode(raw) as Map).cast<String, dynamic>());
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveBookmarks() => store.setString('bookmarks', jsonEncode(bookmarks.map((item) => item.toJson()).toList()));

  Future<void> _saveBooks() => store.setString('books', jsonEncode(savedBooks.map((item) => item.toJson()).toList()));

  Future<void> _saveThoughts() => store.setString('thoughts', jsonEncode(thoughts.map((item) => item.toJson()).toList()));

  Future<void> _saveGroups() => store.setString('groups', jsonEncode(groups.map((item) => item.toJson()).toList()));

  Future<void> _saveTemples() => store.setString('temples', jsonEncode(posts.map((item) => item.toJson()).toList()));
}
