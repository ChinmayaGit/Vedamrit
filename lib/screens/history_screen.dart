import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models.dart';
import '../phrases.dart';
import '../theme.dart';
import '../widgets.dart';
import 'settings_screen.dart';

String _initial(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '?';
  return String.fromCharCode(trimmed.runes.first);
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool savedOnly = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final posts = savedOnly ? state.posts.where((post) => post.saved).toList() : state.posts;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButton: FloatingActionButton(
          heroTag: 'history',
          backgroundColor: kSaffron,
          foregroundColor: Colors.white,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComposeHistoryScreen())),
          child: const Icon(Icons.add_a_photo),
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 90),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(phrase(state, 'history'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const PageTools(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Text(
                state.usesCloud
                    ? 'Temple notes, likes, and comments are shared. A photo stays on the phone that added it.'
                    : 'Temple inscriptions, what the place means, and how to reach it. Likes and notes stay on this phone.',
                style: const TextStyle(color: kMuted, height: 1.35),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(label: const Text('All'), selected: !savedOnly, onSelected: (_) => setState(() => savedOnly = false)),
                  ChoiceChip(
                    label: const Text('Saved'),
                    selected: savedOnly,
                    selectedColor: kSaffron.withValues(alpha: 0.25),
                    onSelected: (_) => setState(() => savedOnly = true),
                  ),
                ],
              ),
            ),
            if (posts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('Nothing saved yet. Add a temple from the round button.'),
              ),
            for (final post in posts) _PostCard(post: post),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final TemplePost post;

  @override
  Widget build(BuildContext context) {
    final colors = coverGradients[post.hue % coverGradients.length];
    final path = post.imagePath;
    final remote = path != null && path.startsWith('http');
    final hasPhoto = remote || (path != null && File(path).existsSync());
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors.first,
                  child: Text(_initial(post.name), style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text(post.place, style: const TextStyle(color: kMuted, fontSize: 12)),
                    ],
                  ),
                ),
                Text(timeAgo(post.createdAt), style: const TextStyle(color: kMuted, fontSize: 12)),
                if (post.mine)
                  IconButton(
                    tooltip: 'Delete',
                    onPressed: () => context.read<AppState>().deletePost(post.id),
                    icon: const Icon(Icons.more_horiz),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onDoubleTap: () => context.read<AppState>().reactPost(post.id, like: true),
            child: SizedBox(
              height: 320,
              width: double.infinity,
              child: remote
                  ? Image.network(path, fit: BoxFit.cover)
                  : hasPhoto
                  ? Image.file(File(path), fit: BoxFit.cover)
                  : Container(
                      decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        post.scripture,
                        textAlign: TextAlign.center,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.4, fontWeight: FontWeight.w600),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Like',
                  onPressed: () => context.read<AppState>().reactPost(post.id, like: true),
                  icon: Icon(post.liked ? Icons.favorite : Icons.favorite_border, color: post.liked ? kClay : null),
                ),
                Text('${post.likes}'),
                IconButton(
                  tooltip: 'Dislike',
                  onPressed: () => context.read<AppState>().reactPost(post.id, like: false),
                  icon: Icon(post.disliked ? Icons.thumb_down : Icons.thumb_down_outlined, color: post.disliked ? null : kMuted),
                ),
                Text('${post.dislikes}'),
                IconButton(
                  tooltip: 'Comments',
                  onPressed: () => _comments(context, post.id),
                  icon: const Icon(Icons.chat_bubble_outline),
                ),
                Text('${post.comments.length}'),
                const Spacer(),
                IconButton(
                  tooltip: post.saved ? 'Unsave' : 'Save',
                  onPressed: () => context.read<AppState>().toggleSavePost(post.id),
                  icon: Icon(post.saved ? Icons.bookmark : Icons.bookmark_border, color: post.saved ? kSaffron : null),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Text(post.meaning, style: const TextStyle(height: 1.35)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Why it matters  ·  ${post.value}', style: const TextStyle(color: kMuted, height: 1.35)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Text('How to go  ·  ${post.visit}', style: const TextStyle(height: 1.35)),
          ),
          if (post.comments.isNotEmpty)
            TextButton(
              onPressed: () => _comments(context, post.id),
              child: Text('View all ${post.comments.length} comments'),
            ),
        ],
      ),
    );
  }

  void _comments(BuildContext context, String id) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => CommentSheet(postId: id),
    );
  }
}

class CommentSheet extends StatefulWidget {
  const CommentSheet({super.key, required this.postId});

  final String postId;

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    TemplePost? post;
    for (final item in state.posts) {
      if (item.id == widget.postId) post = item;
    }
    if (post == null) return const SizedBox(height: 120, child: Center(child: Text('This post is gone.')));
    final current = post;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.6,
        child: Column(
          children: [
            const Text('Comments', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (current.comments.isEmpty) const Text('Be the first to write.', style: TextStyle(color: kMuted)),
                  for (final comment in current.comments)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${comment.author}  ·  ${timeAgo(comment.createdAt)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          Text(comment.text),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: 'Add a comment', border: OutlineInputBorder()),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Send',
                    onPressed: () {
                      state.addComment(current.id, controller.text);
                      controller.clear();
                    },
                    icon: const Icon(Icons.send, color: kSaffron),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ComposeHistoryScreen extends StatefulWidget {
  const ComposeHistoryScreen({super.key});

  @override
  State<ComposeHistoryScreen> createState() => _ComposeHistoryScreenState();
}

class _ComposeHistoryScreenState extends State<ComposeHistoryScreen> {
  final name = TextEditingController();
  final place = TextEditingController();
  final scripture = TextEditingController();
  final meaning = TextEditingController();
  final value = TextEditingController();
  final visit = TextEditingController();
  String? photoPath;
  bool saving = false;

  @override
  void dispose() {
    name.dispose();
    place.dispose();
    scripture.dispose();
    meaning.dispose();
    value.dispose();
    visit.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final file = await ImagePicker().pickImage(source: source, maxWidth: 1600, imageQuality: 82);
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      final path = await context.read<AppState>().store.writeBytes(
            'temples/${DateTime.now().microsecondsSinceEpoch}.jpg',
            bytes,
          );
      if (!mounted) return;
      setState(() => photoPath = path);
    } catch (_) {
      if (!mounted) return;
      showNotice(context, 'The photo could not be opened.');
    }
  }

  Future<void> _save() async {
    if (name.text.trim().isEmpty || meaning.text.trim().isEmpty) {
      showNotice(context, 'Add the temple name and what it means.');
      return;
    }
    setState(() => saving = true);
    context.read<AppState>().addPost(
          temple: name.text,
          place: place.text,
          scripture: scripture.text,
          meaning: meaning.text,
          value: value.text,
          visit: visit.text,
          imagePath: photoPath,
        );
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a temple'), actions: const [PageTools()]),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (photoPath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(File(photoPath!), height: 180, width: double.infinity, fit: BoxFit.cover),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: OutlinedButton.icon(onPressed: () => _pick(ImageSource.gallery), icon: const Icon(Icons.photo), label: const Text('Gallery'))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton.icon(onPressed: () => _pick(ImageSource.camera), icon: const Icon(Icons.photo_camera), label: const Text('Camera'))),
            ],
          ),
          const SizedBox(height: 12),
          _field(name, 'Temple'),
          _field(place, 'Place'),
          _field(scripture, 'Inscription or scripture', lines: 3),
          _field(meaning, 'Meaning', lines: 3),
          _field(value, 'Why it matters', lines: 3),
          _field(visit, 'How to go', lines: 3),
          const SizedBox(height: 12),
          PillButton(label: saving ? 'Saving' : 'Share', onPressed: saving ? null : _save),
        ],
      ),
    );
  }

  Widget _field(TextEditingController controller, String label, {int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        minLines: lines,
        maxLines: lines,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
