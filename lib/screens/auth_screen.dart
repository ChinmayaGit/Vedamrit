import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../phrases.dart';
import '../theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool creating = false;
  bool busy = false;
  String? error;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text(creating ? phrase(state, 'signUp') : phrase(state, 'signIn'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        children: [
          Text(phrase(state, 'authHelp'), style: const TextStyle(color: kMuted, height: 1.4)),
          const SizedBox(height: 20),
          if (creating) ...[
            TextField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: phrase(state, 'yourName')),
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: phrase(state, 'email')),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: phrase(state, 'password')),
            onSubmitted: (_) => _email(state),
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: const TextStyle(color: kClay, height: 1.3)),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: busy ? null : () => _email(state),
            child: Text(creating ? phrase(state, 'signUp') : phrase(state, 'signIn')),
          ),
          TextButton(
            onPressed: busy ? null : () => setState(() { creating = !creating; error = null; }),
            child: Text(creating ? phrase(state, 'signIn') : phrase(state, 'signUp')),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: busy ? null : () => _google(state),
            icon: const Icon(Icons.g_mobiledata, size: 28),
            label: Text(phrase(state, 'google')),
          ),
        ],
      ),
    );
  }

  Future<void> _email(AppState state) async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => error = phrase(state, 'authHelp'));
      return;
    }
    setState(() { busy = true; error = null; });
    final message = creating
        ? await state.signUpEmail(email, password, nameController.text)
        : await state.signInEmail(email, password);
    if (!mounted) return;
    if (message != null) {
      setState(() { busy = false; error = message; });
      return;
    }
    Navigator.pop(context, true);
  }

  Future<void> _google(AppState state) async {
    setState(() { busy = true; error = null; });
    final message = await state.signInGoogle();
    if (!mounted) return;
    if (message != null) {
      setState(() { busy = false; error = message; });
      return;
    }
    if (!state.signedIn) {
      setState(() => busy = false);
      return;
    }
    Navigator.pop(context, true);
  }
}
