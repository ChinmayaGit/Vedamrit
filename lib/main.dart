import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'firebase_options.dart';
import 'reader_audio.dart';
import 'screens/welcome_screen.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final state = AppState();
  await state.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: state),
        ChangeNotifierProvider(create: (_) => ReaderAudio()..speed = state.speed),
      ],
      child: const VedamritApp(),
    ),
  );
}

class VedamritApp extends StatelessWidget {
  const VedamritApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final palette = paletteById(state.themePaletteId);
    return MaterialApp(
      title: 'Vedamrit',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(primary: palette.primary),
      darkTheme: buildTheme(
        dark: true,
        amoled: state.amoledDark,
        primary: palette.primary,
      ),
      themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(state.textScale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const WelcomeScreen(),
    );
  }
}
