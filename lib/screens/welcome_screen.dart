import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../phrases.dart';
import '../theme.dart';
import '../widgets.dart';
import 'auth_screen.dart';
import 'settings_screen.dart';
import 'shell_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kInk, Color(0xFF6B2D3C), kClay, kSaffron],
            stops: [0, 0.35, 0.7, 1],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned(top: -40, right: -30, child: _Glow(size: 220)),
              const Positioned(bottom: 80, left: -50, child: _Glow(size: 180)),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.menu_book, color: Colors.white, size: 42),
                      const SizedBox(height: 18),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(fontSize: 52, color: Colors.white, height: 1),
                          children: [
                            TextSpan(text: 'Veda'),
                            TextSpan(text: 'mrit.', style: TextStyle(fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Gita, Vedas, and the road to the temple',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 36),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.62,
                        child: PillButton(
                          label: phrase(state, 'start'),
                          light: true,
                          onPressed: () async {
                            final state = context.read<AppState>();
                            if (state.usesCloud && !state.signedIn) {
                              final signed = await Navigator.of(context).push<bool>(
                                MaterialPageRoute(builder: (_) => const AuthScreen()),
                              );
                              if (signed != true || !context.mounted) return;
                            }
                            if (!context.mounted) return;
                            if (!state.languageChosen) {
                              final chosen = await Navigator.of(context).push<bool>(
                                MaterialPageRoute(builder: (_) => const LanguageScreen(mustChoose: true)),
                              );
                              if (chosen != true || !context.mounted) return;
                            }
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShellScreen()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.08),
      ),
    );
  }
}
