import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vedamrit/app_state.dart';
import 'package:vedamrit/main.dart';
import 'package:vedamrit/models.dart';
import 'package:vedamrit/reader_audio.dart';
import 'package:vedamrit/screens/book_reader_screen.dart';
import 'package:vedamrit/screens/gita_book_screen.dart';
import 'package:vedamrit/screens/home_screen.dart';
import 'package:vedamrit/screens/scripture_screen.dart';
import 'package:vedamrit/screens/settings_screen.dart';
import 'package:vedamrit/screens/shell_screen.dart';
import 'package:vedamrit/theme.dart';
import 'package:vedamrit/widgets.dart';

void main() {
  testWidgets('shell screen has 5 bottom navigation tabs: home, bookmarks, history, library, settings', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();
    await tester.pumpWidget(_wrap(state, const ShellScreen()));
    await tester.pump();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Bookmarks'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('home screen has recent floating action button and sastra grid', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();
    await tester.pumpWidget(_wrap(state, const HomeScreen()));
    await tester.pump();
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Resume Reading'), findsOneWidget);
    expect(find.text('Vedas'), findsOneWidget);
    expect(find.text('Gita'), findsOneWidget);
    expect(find.text('Puranas'), findsOneWidget);
  });

  testWidgets('scripture screen contains Puranas grid card and opens shelf', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();
    await tester.pumpWidget(_wrap(state, const ScriptureScreen()));
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('Puranas'), findsWidgets);
    await tester.tap(find.text('Puranas').first);
    await tester.pumpAndSettle();
    expect(find.text('The sacred Puranas'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('Srimad Bhagavatam'), findsOneWidget);
  });

  testWidgets('book reader tap once toggles fullscreen mode', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();
    await tester.pumpWidget(
      _wrap(
        state,
        const BookReaderScreen(
          id: 'test-book',
          title: 'Test Book',
          path: 'assets/scripture/yoga_sutras.txt',
          kind: 'txt',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(ReaderDock), findsOneWidget);

    // Tap once to hide controls (fullscreen mode)
    await tester.tap(find.byType(ListView));
    await tester.pumpAndSettle();
    expect(find.byType(AppBar), findsNothing);
    expect(find.byType(ReaderDock), findsNothing);

    // Wait past double-tap timeout
    await tester.pump(const Duration(milliseconds: 600));

    // Tap once again to restore controls
    await tester.tap(find.byType(ListView));
    await tester.pumpAndSettle();
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(ReaderDock), findsOneWidget);
  });

  testWidgets('settings screen offers app UI language, reading language, and auto-resume toggle', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();
    await tester.pumpWidget(_wrap(state, const SettingsScreen()));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Tap to hide controls'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.text('App language'), findsOneWidget);
    expect(find.text('Reading language'), findsOneWidget);
    expect(find.text('Open where I left off on launch'), findsOneWidget);
    expect(find.text('Tap to hide controls'), findsOneWidget);
  });

  testWidgets('welcome offers reading', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: state),
          ChangeNotifierProvider(create: (_) => ReaderAudio()),
        ],
        child: const VedamritApp(),
      ),
    );
    expect(find.text('Vedamrit.', findRichText: true), findsOneWidget);
    expect(find.text('start reading'), findsOneWidget);
  });

  testWidgets('scripture shelf opens from grid for vedas and gita', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();
    await tester.pumpWidget(_wrap(state, const ScriptureScreen()));
    await tester.pump();
    expect(find.text('Śāstra'), findsOneWidget);
    expect(find.text('Vedas'), findsOneWidget);
    await tester.tap(find.text('Vedas'));
    await tester.pumpAndSettle();
    expect(find.text('The Rig Veda'), findsOneWidget);
  });

  testWidgets('a gita chapter opens as a centered book', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();
    await tester.pumpWidget(_wrap(state, const GitaChapterBookScreen(chapter: 1)));
    await tester.pump();
    expect(find.byType(GitaChapterBookScreen), findsOneWidget);
    expect(find.byType(ReaderDock), findsOneWidget);
  });

  test('book reader bookmarking normalizes id and avoids book-book duplicate prefix', () async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();
    const mark = Bookmark(
      id: 'book-rig-veda',
      kind: 'book',
      title: 'Rig Veda',
      subtitle: 'Griffith',
      bookPath: 'assets/scripture/rig_veda.txt',
      bookKind: 'txt',
    );
    state.toggleBookmark(mark);
    expect(state.bookmarked('book-rig-veda'), isTrue);
    expect(state.bookmarks.first.id, 'book-rig-veda');

    // Toggling again removes it
    state.toggleBookmark(mark);
    expect(state.bookmarked('book-rig-veda'), isFalse);
    expect(state.bookmarks, isEmpty);
  });
}

Widget _wrap(AppState state, Widget home) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: state),
      ChangeNotifierProvider(create: (_) => ReaderAudio()),
    ],
    child: MaterialApp(theme: buildTheme(), home: home),
  );
}
