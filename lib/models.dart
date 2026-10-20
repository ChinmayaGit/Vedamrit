class ReadingLanguage {
  final String code;
  final String label;
  final bool assisted;

  const ReadingLanguage(this.code, this.label, this.assisted);
}

class Chapter {
  final int number;
  final int verses;
  final String name;
  final String transliteration;
  final String translation;
  final String summary;
  final String hindiSummary;

  const Chapter({
    required this.number,
    required this.verses,
    required this.name,
    required this.transliteration,
    required this.translation,
    required this.summary,
    this.hindiSummary = '',
  });

  String headingFor(String language) {
    if (language == 'en' && translation.isNotEmpty) return translation;
    if (name.isNotEmpty) return name;
    return transliteration;
  }

  String blurbFor(String language) {
    if (language == 'hi' && hindiSummary.isNotEmpty) return hindiSummary;
    if (language == 'en') return summary;
    return '';
  }
}

class Voice {
  final String author;
  final String language;
  final String? translation;
  final String? commentary;

  const Voice({
    required this.author,
    required this.language,
    this.translation,
    this.commentary,
  });

  bool get hasTranslation => _useful(translation);
  bool get hasCommentary => _useful(commentary);
  bool get hasText => hasTranslation || hasCommentary;
}

bool _useful(String? value) {
  if (value == null) return false;
  final text = value.trim();
  if (text.isEmpty) return false;
  return !text.toLowerCase().contains('did not comment');
}

class Shloka {
  final int chapter;
  final int verse;
  final String sanskrit;
  final String transliteration;
  final List<Voice> voices;
  final String raw;

  const Shloka({
    required this.chapter,
    required this.verse,
    required this.sanskrit,
    required this.transliteration,
    required this.voices,
    required this.raw,
  });

  List<Voice> inLanguage(String code) =>
      voices.where((voice) => voice.language == code && voice.hasText).toList();

  String? get englishSource {
    final options = inLanguage('en')
        .map((voice) => voice.translation)
        .whereType<String>()
        .where(_useful)
        .toList();
    if (options.isEmpty) return null;
    options.sort((a, b) => a.length.compareTo(b.length));
    return options.first;
  }

  String? get englishAuthor {
    final source = englishSource;
    if (source == null) return null;
    for (final voice in inLanguage('en')) {
      if (voice.translation == source) return voice.author;
    }
    return null;
  }
}

class DailyQuote {
  final int chapter;
  final int verse;
  final String sanskrit;
  final String transliteration;
  final String gloss;
  final String? author;

  const DailyQuote({
    required this.chapter,
    required this.verse,
    required this.sanskrit,
    required this.transliteration,
    required this.gloss,
    this.author,
  });

  Map<String, dynamic> toJson() => {
        'chapter': chapter,
        'verse': verse,
        'sanskrit': sanskrit,
        'transliteration': transliteration,
        'gloss': gloss,
        'author': author,
      };

  factory DailyQuote.fromJson(Map<String, dynamic> json) => DailyQuote(
        chapter: _asInt(json['chapter']),
        verse: _asInt(json['verse']),
        sanskrit: _asString(json['sanskrit']),
        transliteration: _asString(json['transliteration']),
        gloss: _asString(json['gloss']),
        author: json['author']?.toString(),
      );
}

class Passage {
  final String id;
  final String title;
  final String sanskrit;
  final String transliteration;
  final String meaning;

  const Passage({
    required this.id,
    required this.title,
    required this.sanskrit,
    required this.transliteration,
    required this.meaning,
  });
}

class Veda {
  final String id;
  final String name;
  final String sanskrit;
  final String summary;
  final String query;
  final List<Passage> passages;

  const Veda({
    required this.id,
    required this.name,
    required this.sanskrit,
    required this.summary,
    required this.query,
    required this.passages,
  });
}

class Canto {
  final int number;
  final String name;
  final String sanskrit;
  final String summary;
  final String query;

  const Canto({
    required this.number,
    required this.name,
    required this.sanskrit,
    required this.summary,
    required this.query,
  });
}

class ReadingSpot {
  final String title;
  final String subtitle;
  final int chapter;
  final int verse;
  final double progress;
  final String kind;
  final String? bookId;
  final String? bookPath;
  final String? bookKind;

  const ReadingSpot({
    required this.title,
    required this.subtitle,
    required this.chapter,
    required this.verse,
    required this.progress,
    this.kind = 'shloka',
    this.bookId,
    this.bookPath,
    this.bookKind,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'chapter': chapter,
        'verse': verse,
        'progress': progress,
        'kind': kind,
        'bookId': bookId,
        'bookPath': bookPath,
        'bookKind': bookKind,
      };

  factory ReadingSpot.fromJson(Map<String, dynamic> json) => ReadingSpot(
        title: _asString(json['title']),
        subtitle: _asString(json['subtitle']),
        chapter: _asInt(json['chapter']),
        verse: _asInt(json['verse']),
        progress: json['progress'] is num ? (json['progress'] as num).toDouble() : 0,
        kind: json['kind']?.toString() ?? 'shloka',
        bookId: json['bookId']?.toString(),
        bookPath: json['bookPath']?.toString(),
        bookKind: json['bookKind']?.toString(),
      );
}

class Bookmark {
  final String id;
  final String kind;
  final String title;
  final String subtitle;
  final int? chapter;
  final int? verse;
  final String? passageId;
  final String? sanskrit;
  final String? transliteration;
  final String? meaning;
  final String? bookPath;
  final String? bookKind;

  const Bookmark({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    this.chapter,
    this.verse,
    this.passageId,
    this.sanskrit,
    this.transliteration,
    this.meaning,
    this.bookPath,
    this.bookKind,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind,
        'title': title,
        'subtitle': subtitle,
        'chapter': chapter,
        'verse': verse,
        'passageId': passageId,
        'sanskrit': sanskrit,
        'transliteration': transliteration,
        'meaning': meaning,
        'bookPath': bookPath,
        'bookKind': bookKind,
      };

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        id: _asString(json['id']),
        kind: _asString(json['kind']),
        title: _asString(json['title']),
        subtitle: _asString(json['subtitle']),
        chapter: json['chapter'] == null ? null : _asInt(json['chapter']),
        verse: json['verse'] == null ? null : _asInt(json['verse']),
        passageId: json['passageId']?.toString(),
        sanskrit: json['sanskrit']?.toString(),
        transliteration: json['transliteration']?.toString(),
        meaning: json['meaning']?.toString(),
        bookPath: json['bookPath']?.toString(),
        bookKind: json['bookKind']?.toString(),
      );
}

class SavedBook {
  final String id;
  final String title;
  final String author;
  final String source;
  final String path;
  final String kind;

  const SavedBook({
    required this.id,
    required this.title,
    required this.author,
    required this.source,
    required this.path,
    required this.kind,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'source': source,
        'path': path,
        'kind': kind,
      };

  factory SavedBook.fromJson(Map<String, dynamic> json) => SavedBook(
        id: _asString(json['id']),
        title: _asString(json['title']),
        author: _asString(json['author']),
        source: _asString(json['source']),
        path: _asString(json['path']),
        kind: _asString(json['kind']),
      );
}

class RemoteBook {
  final String id;
  final String title;
  final String author;
  final String source;
  final String? coverUrl;
  final String? downloadUrl;
  final String? archiveId;
  final String kind;

  const RemoteBook({
    required this.id,
    required this.title,
    required this.author,
    required this.source,
    this.coverUrl,
    this.downloadUrl,
    this.archiveId,
    this.kind = '',
  });

  bool get canKeep => downloadUrl != null || archiveId != null;
}

class TaskProgress {
  final String id;
  final String label;
  final double? value;

  const TaskProgress({required this.id, required this.label, this.value});
}

class Thought {
  final String id;
  final String author;
  final String text;
  final int createdAt;
  int likes;
  bool liked;
  final bool mine;

  Thought({
    required this.id,
    required this.author,
    required this.text,
    required this.createdAt,
    this.likes = 0,
    this.liked = false,
    this.mine = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'text': text,
        'createdAt': createdAt,
        'likes': likes,
        'liked': liked,
        'mine': mine,
      };

  factory Thought.fromJson(Map<String, dynamic> json) => Thought(
        id: _asString(json['id']),
        author: _asString(json['author']),
        text: _asString(json['text']),
        createdAt: _asInt(json['createdAt']),
        likes: _asInt(json['likes']),
        liked: json['liked'] == true,
        mine: json['mine'] == true,
      );
}

class ChatMessage {
  final String id;
  final String author;
  final String text;
  final int createdAt;
  final bool mine;

  const ChatMessage({
    required this.id,
    required this.author,
    required this.text,
    required this.createdAt,
    required this.mine,
    this.authorId = '',
  });

  final String authorId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'text': text,
        'createdAt': createdAt,
        'mine': mine,
        'authorId': authorId,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: _asString(json['id']),
        author: _asString(json['author']),
        text: _asString(json['text']),
        createdAt: _asInt(json['createdAt']),
        mine: json['mine'] == true,
        authorId: _asString(json['authorId']),
      );
}

class Channel {
  final String id;
  final String name;
  final List<ChatMessage> messages;

  Channel({required this.id, required this.name, List<ChatMessage>? messages})
      : messages = messages ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'messages': messages.map((message) => message.toJson()).toList(),
      };

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: _asString(json['id']),
        name: _asString(json['name']),
        messages: _maps(json['messages']).map(ChatMessage.fromJson).toList(),
      );
}

class CircleGroup {
  final String id;
  final String name;
  final String about;
  final List<Channel> channels;

  CircleGroup({
    required this.id,
    required this.name,
    required this.about,
    this.ownerId = '',
    List<Channel>? channels,
  }) : channels = channels ?? [];

  final String ownerId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'about': about,
        'ownerId': ownerId,
        'channels': channels.map((channel) => channel.toJson()).toList(),
      };

  factory CircleGroup.fromJson(Map<String, dynamic> json) => CircleGroup(
        id: _asString(json['id']),
        name: _asString(json['name']),
        about: _asString(json['about']),
        ownerId: _asString(json['ownerId']),
        channels: _maps(json['channels']).map(Channel.fromJson).toList(),
      );
}

class TempleComment {
  final String id;
  final String author;
  final String text;
  final int createdAt;
  final bool mine;

  const TempleComment({
    required this.id,
    required this.author,
    required this.text,
    required this.createdAt,
    required this.mine,
    this.authorId = '',
  });

  final String authorId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'text': text,
        'createdAt': createdAt,
        'mine': mine,
        'authorId': authorId,
      };

  factory TempleComment.fromJson(Map<String, dynamic> json) => TempleComment(
        id: _asString(json['id']),
        author: _asString(json['author']),
        text: _asString(json['text']),
        createdAt: _asInt(json['createdAt']),
        mine: json['mine'] == true,
        authorId: _asString(json['authorId']),
      );
}

class TemplePost {
  final String id;
  final String name;
  final String place;
  final String scripture;
  final String meaning;
  final String value;
  final String visit;
  final String? imagePath;
  final String author;
  final int hue;
  final int createdAt;
  final bool mine;
  int likes;
  int dislikes;
  bool liked;
  bool disliked;
  bool saved;
  final List<TempleComment> comments;

  TemplePost({
    required this.id,
    required this.name,
    required this.place,
    required this.scripture,
    required this.meaning,
    required this.value,
    required this.visit,
    required this.author,
    required this.createdAt,
    this.imagePath,
    this.hue = 0,
    this.mine = false,
    this.likes = 0,
    this.dislikes = 0,
    this.liked = false,
    this.disliked = false,
    this.saved = false,
    List<TempleComment>? comments,
  }) : comments = comments ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'place': place,
        'scripture': scripture,
        'meaning': meaning,
        'value': value,
        'visit': visit,
        'imagePath': imagePath,
        'author': author,
        'hue': hue,
        'createdAt': createdAt,
        'mine': mine,
        'likes': likes,
        'dislikes': dislikes,
        'liked': liked,
        'disliked': disliked,
        'saved': saved,
        'comments': comments.map((comment) => comment.toJson()).toList(),
      };

  factory TemplePost.fromJson(Map<String, dynamic> json) => TemplePost(
        id: _asString(json['id']),
        name: _asString(json['name']),
        place: _asString(json['place']),
        scripture: _asString(json['scripture']),
        meaning: _asString(json['meaning']),
        value: _asString(json['value']),
        visit: _asString(json['visit']),
        imagePath: json['imagePath']?.toString(),
        author: _asString(json['author']),
        hue: _asInt(json['hue']),
        createdAt: _asInt(json['createdAt']),
        mine: json['mine'] == true,
        likes: _asInt(json['likes']),
        dislikes: _asInt(json['dislikes']),
        liked: json['liked'] == true,
        disliked: json['disliked'] == true,
        saved: json['saved'] == true,
        comments: _maps(json['comments']).map(TempleComment.fromJson).toList(),
      );
}

class SpeechBit {
  final String text;
  final String locale;

  const SpeechBit(this.text, this.locale);
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? 0;
}

String _asString(dynamic value) => value?.toString() ?? '';

List<Map<String, dynamic>> _maps(dynamic value) {
  if (value is! List) return [];
  return value.whereType<Map>().map((item) => item.cast<String, dynamic>()).toList();
}
