import 'package:flutter/material.dart';

const kBlack = Color(0xFF393939);
const kMuted = Color(0xFF8F8F8F);
const kSaffron = Color(0xFFF48A37);
const kClay = Color(0xFFBE7066);
const kShadow = Color(0xFFD3D3D3);
const kCream = Color(0xFFFFF6EE);
const kPaper = Color(0xFFF3E6D0);
const kInk = Color(0xFF2C1810);

class ThemePalette {
  final String id;
  final String name;
  final String sanskrit;
  final Color primary;
  final Color secondary;

  const ThemePalette({
    required this.id,
    required this.name,
    required this.sanskrit,
    required this.primary,
    required this.secondary,
  });
}

const themePalettes = <ThemePalette>[
  ThemePalette(
    id: 'saffron',
    name: 'Saffron',
    sanskrit: 'केशर',
    primary: Color(0xFFF48A37),
    secondary: Color(0xFFBE7066),
  ),
  ThemePalette(
    id: 'kumkum',
    name: 'Kumkum',
    sanskrit: 'कुङ्कुम',
    primary: Color(0xFFC62828),
    secondary: Color(0xFFE57373),
  ),
  ThemePalette(
    id: 'peacock',
    name: 'Peacock Blue',
    sanskrit: 'मयूर नीलम',
    primary: Color(0xFF0288D1),
    secondary: Color(0xFF4FC3F7),
  ),
  ThemePalette(
    id: 'tulsi',
    name: 'Tulsi Green',
    sanskrit: 'तुलसी',
    primary: Color(0xFF2E7D32),
    secondary: Color(0xFF81C784),
  ),
  ThemePalette(
    id: 'lotus',
    name: 'Lotus Pink',
    sanskrit: 'पद्म',
    primary: Color(0xFFD81B60),
    secondary: Color(0xFFF06292),
  ),
  ThemePalette(
    id: 'krishna',
    name: 'Shyama Purple',
    sanskrit: 'श्याम',
    primary: Color(0xFF7B1FA2),
    secondary: Color(0xFFBA68C8),
  ),
  ThemePalette(
    id: 'gold',
    name: 'Chandan Gold',
    sanskrit: 'चन्दन',
    primary: Color(0xFFD4AF37),
    secondary: Color(0xFFFFD54F),
  ),
  ThemePalette(
    id: 'clay',
    name: 'Vedic Terracotta',
    sanskrit: 'मृत्तिका',
    primary: Color(0xFFBE7066),
    secondary: Color(0xFFE5A199),
  ),
];

ThemePalette paletteById(String id) {
  for (final p in themePalettes) {
    if (p.id == id) return p;
  }
  return themePalettes.first;
}

Color primaryOf(BuildContext context) => Theme.of(context).colorScheme.primary;

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

bool amoledOf(BuildContext context) =>
    darkOf(context) && Theme.of(context).scaffoldBackgroundColor == Colors.black;

Color creamOf(BuildContext context) {
  if (darkOf(context)) {
    return amoledOf(context) ? const Color(0xFF141414) : const Color(0xFF322820);
  }
  return kCream;
}

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

Color paperOf(BuildContext context) {
  if (darkOf(context)) {
    return amoledOf(context) ? const Color(0xFF000000) : const Color(0xFF2A211C);
  }
  return kPaper;
}

Color inkOf(BuildContext context) {
  if (darkOf(context)) {
    return amoledOf(context) ? const Color(0xFFEDEDED) : const Color(0xFFF3E6D0);
  }
  return kInk;
}

Color cardOf(BuildContext context) {
  if (darkOf(context)) {
    return amoledOf(context) ? const Color(0xFF0D0D0D) : const Color(0xFF241C18);
  }
  return Colors.white;
}

ThemeData buildTheme({
  bool dark = false,
  bool amoled = false,
  Color? primary,
}) {
  final primaryColor = primary ?? kSaffron;
  final isAmoled = dark && amoled;
  final darkBg = isAmoled ? const Color(0xFF000000) : const Color(0xFF161210);
  final darkSurface = isAmoled ? const Color(0xFF0A0A0A) : const Color(0xFF1E1916);
  final darkCard = isAmoled ? const Color(0xFF121212) : const Color(0xFF241C18);
  final ink = dark ? (isAmoled ? const Color(0xFFFFFFFF) : const Color(0xFFF6F0E6)) : kBlack;

  final base = ThemeData(
    useMaterial3: true,
    brightness: dark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: dark ? darkBg : Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: dark ? Brightness.dark : Brightness.light,
      primary: primaryColor,
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
      indicatorColor: primaryColor.withValues(alpha: 0.18),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    dialogTheme: DialogThemeData(backgroundColor: dark ? darkSurface : Colors.white),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: dark ? darkSurface : Colors.white),
    cardTheme: CardThemeData(
      color: dark ? darkCard : Colors.white,
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
