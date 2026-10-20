import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../phrases.dart';
import '../gita_api.dart';
import '../library_api.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'book_reader_screen.dart';
import 'settings_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key, this.initialQuery, this.embedded = false});

  final String? initialQuery;
  final bool embedded;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final controller = TextEditingController();
  List<RemoteBook> books = [];
  bool loading = false;
  String? error;
  String selectedCategoryId = 'all';

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      controller.text = widget.initialQuery!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBooks());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    final query = controller.text.trim();
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final found = await context.read<AppState>().library.fetchDli(
            categoryId: selectedCategoryId,
            searchQuery: query.isEmpty ? null : query,
            rows: 35,
          );
      if (!mounted) return;
      setState(() {
        books = found;
        loading = false;
        if (found.isEmpty) {
          error = query.isEmpty
              ? 'No books found in this category from Digital Library of India.'
              : 'No books came back for “$query” in Digital Library of India.';
        }
      });
    } catch (err) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = err.toString();
      });
    }
  }

  Future<void> _readOrDownload(RemoteBook book) async {
    final state = context.read<AppState>();
    final already = state.savedBook(book.id);
    if (already != null) {
      _openSaved(context, already);
      return;
    }
    if (state.activeTask != null) {
      showNotice(context, 'Another download is still running.');
      return;
    }
    try {
      await state.keepBook(book);
      if (!mounted) return;
      final newlySaved = state.savedBook(book.id);
      if (newlySaved != null) {
        _openSaved(context, newlySaved);
      } else {
        showNotice(context, 'Book kept on this phone.');
      }
    } on GitaException catch (err) {
      if (!mounted) return;
      showNotice(context, err.message);
    } catch (_) {
      if (!mounted) return;
      showNotice(context, 'The file could not be downloaded.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final body = Column(
      children: [
        if (!widget.embedded && state.activeTask != null)
          SafeArea(bottom: false, child: TaskBar(label: state.activeTask!.label, value: state.activeTask!.value)),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.embedded)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4, top: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(phrase(state, 'library'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                            const Text(
                              'Digital Library of India (archive.org/details/digitallibraryindia)',
                              style: TextStyle(color: kMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const PageTools(),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search Digital Library of India (570k+ books)',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    tooltip: 'Search',
                    onPressed: _loadBooks,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                ),
                onSubmitted: (_) => _loadBooks(),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final cat in dliCategories)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          avatar: Icon(cat.icon, size: 16),
                          label: Text(cat.label),
                          selected: selectedCategoryId == cat.id,
                          selectedColor: kSaffron.withValues(alpha: 0.25),
                          checkmarkColor: kSaffron,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => selectedCategoryId = cat.id);
                              _loadBooks();
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (loading) const LinearProgressIndicator(color: kSaffron),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              if (state.savedBooks.isNotEmpty) ...[
                const SectionLabel('Kept on this phone'),
                for (final book in state.savedBooks)
                  _SavedTile(book: book),
                const SizedBox(height: 12),
                const SectionLabel('Digital Library of India collection'),
              ],
              if (error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Column(
                      children: [
                        Text(error!, textAlign: TextAlign.center, style: const TextStyle(color: kMuted)),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _loadBooks,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reload'),
                        ),
                      ],
                    ),
                  ),
                ),
              for (final book in books)
                _RemoteTile(
                  book: book,
                  onRead: () => _readOrDownload(book),
                ),
            ],
          ),
        ),
      ],
    );
    if (widget.embedded) {
      return SafeArea(bottom: false, child: body);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(phrase(state, 'library')),
        actions: const [PageTools()],
      ),
      body: body,
    );
  }
}

class _RemoteTile extends StatelessWidget {
  const _RemoteTile({required this.book, required this.onRead});

  final RemoteBook book;
  final VoidCallback onRead;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final saved = state.savedBook(book.id);
    final busy = state.activeTask?.id == book.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardOf(context),
        borderRadius: BorderRadius.circular(18),
        boxShadow: softShadow(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Cover(url: book.coverUrl, title: book.title),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 4),
                Text(book.author, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: kMuted, fontSize: 13)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: kSaffron.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('DLI Archive', style: TextStyle(color: kSaffron, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 8),
                    if (saved != null)
                      const Row(
                        children: [
                          Icon(Icons.check_circle, size: 14, color: Colors.green),
                          SizedBox(width: 4),
                          Text('Downloaded', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600)),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                if (busy) ...[
                  const LinearProgressIndicator(color: kClay),
                  const SizedBox(height: 6),
                  const Text('Downloading from DLI...', style: TextStyle(fontSize: 12, color: kMuted)),
                ] else ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: saved != null
                        ? FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: kSaffron,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                            onPressed: () => _openSaved(context, saved),
                            icon: const Icon(Icons.menu_book, size: 16),
                            label: const Text('Read Now'),
                          )
                        : FilledButton.tonalIcon(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                            onPressed: state.activeTask == null ? onRead : null,
                            icon: const Icon(Icons.download_for_offline, size: 16),
                            label: const Text('Download & Read'),
                          ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedTile extends StatelessWidget {
  const _SavedTile({required this.book});

  final SavedBook book;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.menu_book, color: kSaffron),
      title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('${book.source} · ${book.kind}'),
      trailing: IconButton(
        tooltip: 'Remove from this phone',
        onPressed: () => context.read<AppState>().removeBook(book.id),
        icon: const Icon(Icons.delete_outline),
      ),
      onTap: () => _openSaved(context, book),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.url, required this.title});

  final String? url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 60,
        height: 86,
        child: url == null
            ? Container(
                color: creamOf(context),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                child: Text(
                  title,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: inkOf(context)),
                ),
              )
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: creamOf(context),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.menu_book, color: kMuted),
                ),
              ),
      ),
    );
  }
}

void _openSaved(BuildContext context, SavedBook book) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => BookReaderScreen(id: book.id, title: book.title, path: book.path, kind: book.kind),
    ),
  );
}
