import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models.dart';
import '../phrases.dart';
import '../theme.dart';
import 'settings_screen.dart';

class SanghaScreen extends StatefulWidget {
  const SanghaScreen({super.key});

  @override
  State<SanghaScreen> createState() => _SanghaScreenState();
}

class _SanghaScreenState extends State<SanghaScreen> with SingleTickerProviderStateMixin {
  late final TabController tabs;

  @override
  void initState() {
    super.initState();
    tabs = TabController(length: 2, vsync: this);
    tabs.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButton: FloatingActionButton(
          heroTag: 'sangha',
          backgroundColor: kSaffron,
          foregroundColor: Colors.white,
          onPressed: () => tabs.index == 0 ? _thought(state) : _group(state),
          child: Icon(tabs.index == 0 ? Icons.edit : Icons.group_add),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
              child: Row(
                children: [
                  Expanded(child: Text(phrase(state, 'sangha'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800))),
                  const PageTools(),
                  TextButton(onPressed: () => _name(state), child: Text(state.name)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                state.usesCloud ? 'Thoughts and circles are shared in your account.' : 'Thoughts, circles, and channels stay on this phone.',
                style: const TextStyle(color: kMuted),
              ),
            ),
            TabBar(
              controller: tabs,
              labelColor: kSaffron,
              unselectedLabelColor: kMuted,
              indicatorColor: kSaffron,
              tabs: const [Tab(text: 'Thoughts'), Tab(text: 'Circles')],
            ),
            Expanded(
              child: TabBarView(
                controller: tabs,
                children: [
                  ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
                    children: [
                      if (state.thoughts.isEmpty) const Text('Share a thought from the round button.'),
                      for (final thought in state.thoughts) _ThoughtCard(thought: thought),
                    ],
                  ),
                  ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
                    children: [
                      if (state.groups.isEmpty) const Text('Create a circle, then add a channel.'),
                      for (final group in state.groups)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(backgroundColor: creamOf(context), child: const Icon(Icons.groups, color: kSaffron)),
                          title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                          subtitle: Text(group.about.isEmpty ? '${group.channels.length} channels' : group.about),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => GroupScreen(groupId: group.id)));
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _thought(AppState state) async {
    final text = await _ask(context, title: 'Share a thought', hint: 'What are you sitting with?', action: 'Share');
    if (text != null) state.addThought(text);
  }

  Future<void> _group(AppState state) async {
    final name = await _ask(context, title: 'New circle', hint: 'Circle name', action: 'Create');
    if (name == null || !mounted) return;
    final about = await _ask(context, title: 'What is it for?', hint: 'A short line', action: 'Save');
    if (!mounted) return;
    state.addGroup(name, about ?? '');
  }

  Future<void> _name(AppState state) async {
    final next = await _ask(context, title: 'Your name in the sangha', hint: state.name, action: 'Save', initial: state.name);
    if (next != null) state.setName(next);
  }
}

class _ThoughtCard extends StatelessWidget {
  const _ThoughtCard({required this.thought});

  final Thought thought;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: creamOf(context), borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(thought.author, style: const TextStyle(fontWeight: FontWeight.w800))),
              Text(timeAgo(thought.createdAt), style: const TextStyle(color: kMuted, fontSize: 12)),
              if (thought.mine)
                IconButton(
                  tooltip: 'Delete',
                  onPressed: () => context.read<AppState>().deleteThought(thought.id),
                  icon: const Icon(Icons.close, size: 18),
                ),
            ],
          ),
          Text(thought.text, style: const TextStyle(fontSize: 16, height: 1.4)),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => context.read<AppState>().likeThought(thought.id),
              icon: Icon(thought.liked ? Icons.favorite : Icons.favorite_border, color: kClay),
              label: Text('${thought.likes}'),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    CircleGroup? group;
    for (final item in state.groups) {
      if (item.id == groupId) group = item;
    }
    if (group == null) {
      return Scaffold(appBar: AppBar(actions: const [PageTools()]), body: const Center(child: Text('This circle is gone.')));
    }
    final current = group;
    return Scaffold(
      appBar: AppBar(title: Text(current.name), actions: const [PageTools()]),
      floatingActionButton: FloatingActionButton(
        heroTag: 'channel',
        backgroundColor: kSaffron,
        foregroundColor: Colors.white,
        onPressed: () async {
          final name = await _ask(context, title: 'New channel', hint: 'Channel name', action: 'Create');
          if (name != null) state.addChannel(current.id, name);
        },
        child: const Icon(Icons.tag),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (current.about.isNotEmpty) Text(current.about, style: const TextStyle(color: kMuted)),
          const SizedBox(height: 12),
          const Text('Channels', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          for (final channel in current.channels)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.tag, color: kSaffron),
              title: Text(channel.name),
              subtitle: Text('${channel.messages.length} messages'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ChatScreen(groupId: current.id, channelId: channel.id)),
                );
              },
            ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.groupId, required this.channelId});

  final String groupId;
  final String channelId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    CircleGroup? group;
    for (final item in state.groups) {
      if (item.id == widget.groupId) group = item;
    }
    Channel? channel;
    for (final item in group?.channels ?? <Channel>[]) {
      if (item.id == widget.channelId) channel = item;
    }
    if (channel == null) {
      return Scaffold(appBar: AppBar(actions: const [PageTools()]), body: const Center(child: Text('This channel is gone.')));
    }
    final messages = channel.messages;
    return Scaffold(
      appBar: AppBar(title: Text(channel.name), actions: const [PageTools()]),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text('Say the first word.', style: TextStyle(color: kMuted)))
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      return Align(
                        alignment: message.mine ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
                          decoration: BoxDecoration(
                            color: message.mine ? kSaffron : creamOf(context),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!message.mine)
                                Text(message.author, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kClay)),
                              Text(message.text, style: TextStyle(color: message.mine ? Colors.white : inkOf(context), height: 1.3)),
                              const SizedBox(height: 4),
                              Text(
                                timeAgo(message.createdAt),
                                style: TextStyle(fontSize: 11, color: message.mine ? Colors.white70 : kMuted),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Message',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Send',
                    onPressed: () {
                      state.sendMessage(widget.groupId, widget.channelId, controller.text);
                      controller.clear();
                    },
                    icon: const Icon(Icons.send, color: kSaffron),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String?> _ask(
  BuildContext context, {
  required String title,
  required String hint,
  required String action,
  String? initial,
}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (dialog) => AlertDialog(
      title: Text(title),
      content: TextField(controller: controller, autofocus: true, decoration: InputDecoration(hintText: hint), maxLines: 4),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialog), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(dialog, controller.text), child: Text(action)),
      ],
    ),
  ).whenComplete(controller.dispose);
}
