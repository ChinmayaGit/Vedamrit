import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'models.dart';

class CloudRepo {
  static bool get ready => Firebase.apps.isNotEmpty;

  static FirebaseAuth get auth => FirebaseAuth.instance;

  static FirebaseFirestore get db => FirebaseFirestore.instance;

  static String? get uid => ready ? auth.currentUser?.uid : null;

  static bool _googleReady = false;

  static Future<String?> signInEmail(String email, String password) {
    return _guard(() => auth.signInWithEmailAndPassword(email: email.trim(), password: password));
  }

  static Future<String?> signUpEmail(String email, String password, String displayName) {
    return _guard(() async {
      final credential = await auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      final trimmed = displayName.trim();
      if (trimmed.isNotEmpty) await credential.user?.updateDisplayName(trimmed);
    });
  }

  static Future<String?> signInGoogle() async {
    if (!ready) return 'Firebase is not ready on this phone.';
    try {
      if (!_googleReady) {
        await GoogleSignIn.instance.initialize();
        _googleReady = true;
      }
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        return 'Google sign-in is not available on this device.';
      }
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        return 'Google did not return a sign-in token. Turn on Google in Firebase Authentication.';
      }
      await auth.signInWithCredential(GoogleAuthProvider.credential(idToken: idToken));
      return null;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      return error.description ?? 'Google sign-in could not finish.';
    } on FirebaseAuthException catch (error) {
      return _authMessage(error);
    } catch (error) {
      return 'Google sign-in could not finish.';
    }
  }

  static Future<void> signOut() async {
    if (_googleReady) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}
    }
    if (ready) await auth.signOut();
  }

  static DocumentReference<Map<String, dynamic>> userRef(String uid) => db.collection('users').doc(uid);

  static Stream<DocumentSnapshot<Map<String, dynamic>>> userStream(String uid) => userRef(uid).snapshots();

  static Stream<List<Thought>> thoughts(String uid) {
    return db.collection('thoughts').orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs.map((doc) => _thought(doc.id, doc.data(), uid)).toList(),
        );
  }

  static Stream<List<CircleGroup>> groups(String uid) {
    return db.collection('groups').orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs.map((doc) => _group(doc.id, doc.data(), uid)).toList(),
        );
  }

  static Stream<List<TemplePost>> temples(String uid, Set<String> saved) {
    return db.collection('temples').orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs.map((doc) => _temple(doc.id, doc.data(), uid, saved)).toList(),
        );
  }

  static Future<void> mergeUser(String uid, Map<String, dynamic> data) {
    return userRef(uid).set(data, SetOptions(merge: true));
  }

  static Future<void> addThought({required String authorId, required String author, required String text}) {
    return db.collection('thoughts').add({
      'authorId': authorId,
      'author': author,
      'text': text,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'likedBy': <String>[],
    });
  }

  static Future<void> likeThought(String id, String uid, {required bool alreadyLiked}) {
    return db.collection('thoughts').doc(id).update({
      'likedBy': alreadyLiked ? FieldValue.arrayRemove([uid]) : FieldValue.arrayUnion([uid]),
    });
  }

  static Future<void> deleteThought(String id) => db.collection('thoughts').doc(id).delete();

  static Future<void> createGroup(CircleGroup group) {
    return db.collection('groups').doc(group.id).set({
      'name': group.name,
      'about': group.about,
      'ownerId': group.ownerId,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'channels': group.channels.map(_channelMap).toList(),
    });
  }

  static Future<void> saveGroup(CircleGroup group) {
    return db.collection('groups').doc(group.id).update({
      'channels': group.channels.map(_channelMap).toList(),
    });
  }

  static Future<void> addTemple(TemplePost post, String authorId) {
    return db.collection('temples').doc(post.id).set({
      'authorId': authorId,
      'author': post.author,
      'name': post.name,
      'place': post.place,
      'scripture': post.scripture,
      'meaning': post.meaning,
      'value': post.value,
      'visit': post.visit,
      'imagePath': post.imagePath ?? '',
      'hue': post.hue,
      'createdAt': post.createdAt,
      'likedBy': <String>[],
      'dislikedBy': <String>[],
      'comments': <Map<String, dynamic>>[],
    });
  }

  static Future<void> reactTemple(String id, String uid, {required bool like, required bool wasLiked, required bool wasDisliked}) {
    final data = <String, dynamic>{};
    if (like) {
      data['likedBy'] = wasLiked ? FieldValue.arrayRemove([uid]) : FieldValue.arrayUnion([uid]);
      if (!wasLiked) data['dislikedBy'] = FieldValue.arrayRemove([uid]);
    } else {
      data['dislikedBy'] = wasDisliked ? FieldValue.arrayRemove([uid]) : FieldValue.arrayUnion([uid]);
      if (!wasDisliked) data['likedBy'] = FieldValue.arrayRemove([uid]);
    }
    return db.collection('temples').doc(id).update(data);
  }

  static Future<void> saveComments(TemplePost post) {
    return db.collection('temples').doc(post.id).update({
      'comments': post.comments
          .map((comment) => {
                'id': comment.id,
                'authorId': comment.authorId,
                'author': comment.author,
                'text': comment.text,
                'createdAt': comment.createdAt,
              })
          .toList(),
    });
  }

  static Future<void> deleteTemple(String id) => db.collection('temples').doc(id).delete();

  static Map<String, dynamic> bookmarkMap(Bookmark mark) {
    final json = mark.toJson();
    json.removeWhere((_, value) => value == null);
    return json;
  }

  static List<Bookmark> bookmarksFrom(dynamic raw) {
    if (raw is! List) return [];
    return raw.whereType<Map>().map((item) => Bookmark.fromJson(item.cast<String, dynamic>())).toList();
  }

  static Future<String?> _guard(Future<void> Function() action) async {
    if (!ready) return 'Firebase is not ready on this phone.';
    try {
      await action();
      return null;
    } on FirebaseAuthException catch (error) {
      return _authMessage(error);
    } catch (_) {
      return 'Sign-in could not finish.';
    }
  }

  static String _authMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'That email does not look right.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'That email and password do not match.';
      case 'email-already-in-use':
        return 'An account already uses that email.';
      case 'weak-password':
        return 'Use at least 6 characters for the password.';
      case 'operation-not-allowed':
        return 'Turn on Email/Password and Google in Firebase Authentication.';
      case 'network-request-failed':
        return 'The network did not answer.';
      default:
        return error.message ?? 'Sign-in could not finish.';
    }
  }

  static Thought _thought(String id, Map<String, dynamic> data, String uid) {
    final likedBy = _strings(data['likedBy']);
    return Thought(
      id: id,
      author: '${data['author'] ?? ''}',
      text: '${data['text'] ?? ''}',
      createdAt: _millis(data['createdAt']),
      likes: likedBy.length,
      liked: likedBy.contains(uid),
      mine: data['authorId'] == uid,
    );
  }

  static CircleGroup _group(String id, Map<String, dynamic> data, String uid) {
    final channels = <Channel>[];
    final rawChannels = data['channels'];
    if (rawChannels is List) {
      for (final item in rawChannels.whereType<Map>()) {
        final map = item.cast<String, dynamic>();
        final messages = <ChatMessage>[];
        final rawMessages = map['messages'];
        if (rawMessages is List) {
          for (final message in rawMessages.whereType<Map>()) {
            final row = message.cast<String, dynamic>();
            final authorId = '${row['authorId'] ?? ''}';
            messages.add(ChatMessage(
              id: '${row['id'] ?? ''}',
              author: '${row['author'] ?? ''}',
              text: '${row['text'] ?? ''}',
              createdAt: _millis(row['createdAt']),
              mine: authorId == uid,
              authorId: authorId,
            ));
          }
        }
        channels.add(Channel(id: '${map['id'] ?? ''}', name: '${map['name'] ?? ''}', messages: messages));
      }
    }
    return CircleGroup(
      id: id,
      name: '${data['name'] ?? ''}',
      about: '${data['about'] ?? ''}',
      ownerId: '${data['ownerId'] ?? ''}',
      channels: channels,
    );
  }

  static TemplePost _temple(String id, Map<String, dynamic> data, String uid, Set<String> saved) {
    final likedBy = _strings(data['likedBy']);
    final dislikedBy = _strings(data['dislikedBy']);
    final comments = <TempleComment>[];
    final rawComments = data['comments'];
    if (rawComments is List) {
      for (final item in rawComments.whereType<Map>()) {
        final row = item.cast<String, dynamic>();
        final authorId = '${row['authorId'] ?? ''}';
        comments.add(TempleComment(
          id: '${row['id'] ?? ''}',
          author: '${row['author'] ?? ''}',
          text: '${row['text'] ?? ''}',
          createdAt: _millis(row['createdAt']),
          mine: authorId == uid,
          authorId: authorId,
        ));
      }
    }
    final image = '${data['imagePath'] ?? ''}';
    return TemplePost(
      id: id,
      name: '${data['name'] ?? ''}',
      place: '${data['place'] ?? ''}',
      scripture: '${data['scripture'] ?? ''}',
      meaning: '${data['meaning'] ?? ''}',
      value: '${data['value'] ?? ''}',
      visit: '${data['visit'] ?? ''}',
      imagePath: image.isEmpty ? null : image,
      author: '${data['author'] ?? ''}',
      hue: data['hue'] is int ? data['hue'] as int : 0,
      createdAt: _millis(data['createdAt']),
      mine: data['authorId'] == uid,
      likes: likedBy.length,
      dislikes: dislikedBy.length,
      liked: likedBy.contains(uid),
      disliked: dislikedBy.contains(uid),
      saved: saved.contains(id),
      comments: comments,
    );
  }

  static Map<String, dynamic> _channelMap(Channel channel) => {
        'id': channel.id,
        'name': channel.name,
        'messages': channel.messages
            .map((message) => {
                  'id': message.id,
                  'authorId': message.authorId,
                  'author': message.author,
                  'text': message.text,
                  'createdAt': message.createdAt,
                })
            .toList(),
      };

  static List<String> _strings(dynamic raw) {
    if (raw is! List) return [];
    return raw.map((item) => '$item').toList();
  }

  static int _millis(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }
}
