import 'package:flutter/material.dart';

const kBlack = Color(0xFF393939);
const kMuted = Color(0xFF8F8F8F);
const kSaffron = Color(0xFFF48A37);
const kClay = Color(0xFFBE7066);
const kShadow = Color(0xFFD3D3D3);
const kCream = Color(0xFFFFF6EE);
const kPaper = Color(0xFFF3E6D0);
const kInk = Color(0xFF2C1810);

const coverGradients = <List<Color>>[
  [Color(0xFF8C3A2F), Color(0xFFE39A62)],
  [Color(0xFF214E4B), Color(0xFF7EBEB3)],
  [Color(0xFF3E2A5C), Color(0xFFC48BB8)],
  [Color(0xFF7A3E12), Color(0xFFF0B36A)],
  [Color(0xFF1E3A5F), Color(0xFF8FB4D6)],
  [Color(0xFF5C2A3A), Color(0xFFE0A0A8)],
  [Color(0xFF3F4A1C), Color(0xFFC5C77A)],
  [Color(0xFF4A3428), Color(0xFFD7B59A)],
];

bool darkOf(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

Color creamOf(BuildContext context) => darkOf(context) ? const Color(0xFF322820) : kCream;

Color liftShadow(BuildContext context) =>
    darkOf(context) ? Colors.black.withValues(alpha: 0.55) : kShadow.withValues(alpha: 0.9);

List<BoxShadow> softShadow(BuildContext context) {
  if (darkOf(context)) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.28),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ];
  }
  return [
    BoxShadow(
      color: kShadow.withValues(alpha: 0.84),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];
}

const zoomSteps = <double>[0.85, 1, 1.15, 1.3, 1.5];

Color paperOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2A211C) : kPaper;

Color inkOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? const Color(0xFFF3E6D0) : kInk;

Color cardOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? const Color(0xFF241C18) : Colors.white;

ThemeData buildTheme({bool dark = false}) {
  const darkBg = Color(0xFF161210);
  const darkSurface = Color(0xFF1E1916);
  final ink = dark ? const Color(0xFFF6F0E6) : kBlack;
  final base = ThemeData(
    useMaterial3: true,
    brightness: dark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: dark ? darkBg : Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kSaffron,
      brightness: dark ? Brightness.dark : Brightness.light,
      primary: kSaffron,
      surface: dark ? darkSurface : Colors.white,
    ),
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
    iconTheme: IconThemeData(color: ink),
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? darkBg : Colors.white,
      foregroundColor: ink,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: dark ? darkSurface : Colors.white,
      indicatorColor: kSaffron.withValues(alpha: 0.18),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    dialogTheme: DialogThemeData(backgroundColor: dark ? darkSurface : Colors.white),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: dark ? darkSurface : Colors.white),
    cardTheme: CardThemeData(
      color: dark ? const Color(0xFF241C18) : Colors.white,
      elevation: dark ? 0 : 1,
      shadowColor: dark ? Colors.transparent : kShadow,
    ),
  );
}

String timeAgo(int millis) {
  final when = DateTime.fromMillisecondsSinceEpoch(millis);
  final delta = DateTime.now().difference(when);
  if (delta.inMinutes < 1) return 'just now';
  if (delta.inHours < 1) return '${delta.inMinutes}m';
  if (delta.inDays < 1) return '${delta.inHours}h';
  if (delta.inDays < 21) return '${delta.inDays}d';
  return '${when.day}/${when.month}/${when.year}';
}
