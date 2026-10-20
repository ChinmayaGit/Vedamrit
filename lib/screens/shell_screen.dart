import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../phrases.dart';
import '../shell_scope.dart';
import '../widgets.dart';
import 'bookmarks_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'settings_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final task = state.activeTask;
    return ShellScope(
      index: _index,
      goTo: (i) => setState(() => _index = i),
      child: Scaffold(
        body: Column(
          children: [
            if (task != null)
              SafeArea(
                bottom: false,
                child: TaskBar(label: task.label, value: task.value),
              ),
            Expanded(
              child: IndexedStack(
                index: _index,
                children: const [
                  HomeScreen(),
                  BookmarksScreen(embedded: true),
                  HistoryScreen(),
                  LibraryScreen(embedded: true),
                  SettingsScreen(embedded: true),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: phrase(state, 'home'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.bookmark_outline),
              selectedIcon: const Icon(Icons.bookmark),
              label: phrase(state, 'bookmarks'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.history_edu_outlined),
              selectedIcon: const Icon(Icons.history_edu),
              label: phrase(state, 'history'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.local_library_outlined),
              selectedIcon: const Icon(Icons.local_library),
              label: phrase(state, 'library'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: phrase(state, 'settings'),
            ),
          ],
        ),
      ),
    );
  }
}
