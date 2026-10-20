import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../catalog.dart';
import '../phrases.dart';
import '../reader_audio.dart';
import '../theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: context.read<AppState>().name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final ui = languageByCode(state.uiLanguage);
    final reading = languageByCode(state.readingLanguage);
    final audio = state.audioLanguage.isEmpty ? null : languageByCode(state.audioLanguage);
    final percent = (state.textScale * 100).round();
    return Scaffold(
      appBar: AppBar(
        title: Text(phrase(state, 'settings')),
        automaticallyImplyLeading: !widget.embedded,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          if (state.usesCloud) ...[
            _Heading(phrase(state, 'account')),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person_outline),
              title: Text(state.signedIn ? state.name : phrase(state, 'signIn')),
              subtitle: Text(state.accountEmail ?? ''),
            ),
            if (state.signedIn)
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: () async {
                    await state.signOut();
                    if (!context.mounted) return;
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(phrase(state, 'signOut')),
                ),
              ),
          ],
          _Heading(phrase(state, 'profile')),
          TextField(
            controller: nameController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: phrase(state, 'yourName'),
              helperText: phrase(state, 'nameHelp'),
            ),
            onSubmitted: state.setName,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: () {
                state.setName(nameController.text);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(phrase(state, 'saved'))));
              },
              child: Text(phrase(state, 'saveName')),
            ),
          ),
          _Heading(phrase(state, 'appearance')),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(phrase(state, 'dark')),
            subtitle: Text(phrase(state, 'darkHelp')),
            value: state.darkMode,
            activeThumbColor: kSaffron,
            onChanged: state.setDarkMode,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(phrase(state, 'textSize')),
            subtitle: Text('$percent%  ·  ${phrase(state, 'textSizeHelp')}'),
            trailing: _ZoomPair(state: state),
          ),
          _Heading(phrase(state, 'reading')),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.language),
            title: Text(phrase(state, 'appUiLanguage')),
            subtitle: Text(ui.label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LanguageScreen(ui: true)));
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.translate),
            title: Text(phrase(state, 'readingLanguage')),
            subtitle: Text(reading.label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LanguageScreen()));
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Open where I left off on launch'),
            subtitle: const Text('Automatically resume your last reading position when opening Vedamrit'),
            value: state.autoResumeRecent,
            activeThumbColor: kSaffron,
            onChanged: state.setAutoResumeRecent,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(phrase(state, 'tapToToggle')),
            subtitle: Text(phrase(state, 'tapToToggleHelp')),
            value: state.tapToToggleUi,
            activeThumbColor: kSaffron,
            onChanged: state.setTapToToggleUi,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(phrase(state, 'transliteration')),
            subtitle: Text(phrase(state, 'translitHelp')),
            value: state.showTransliteration,
            activeThumbColor: kSaffron,
            onChanged: state.setShowTransliteration,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(phrase(state, 'speed')),
            subtitle: Text('${state.speed.toStringAsFixed(1)}×  ·  ${phrase(state, 'speedHelp')}'),
          ),
          Slider(
            min: 0.2,
            max: 3,
            divisions: 28,
            value: state.speed.clamp(0.2, 3),
            activeColor: kSaffron,
            label: '${state.speed.toStringAsFixed(1)}×',
            onChanged: (next) {
              final stepped = (next * 10).round() / 10;
              state.setSpeed(stepped);
              context.read<ReaderAudio>().setSpeed(stepped);
            },
          ),
          _Heading(phrase(state, 'audio')),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.record_voice_over_outlined),
            title: Text(phrase(state, 'audioLanguage')),
            subtitle: Text(audio == null ? '${phrase(state, 'audioSame')} · ${reading.label}' : audio.label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LanguageScreen(audio: true)),
              );
            },
          ),
          _Heading(phrase(state, 'about')),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline),
            title: Text(phrase(state, 'sources')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (dialog) => AlertDialog(
                  title: Text(phrase(state, 'sourcesTitle')),
                  content: const SingleChildScrollView(child: Text(aboutSources)),
                  actions: [TextButton(onPressed: () => Navigator.pop(dialog), child: Text(phrase(state, 'close')))],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key, this.ui = false, this.audio = false, this.mustChoose = false});

  final bool ui;
  final bool audio;
  final bool mustChoose;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          mustChoose
              ? phrase(state, 'chooseLanguage')
              : ui
                  ? phrase(state, 'appUiLanguage')
                  : audio
                      ? phrase(state, 'audioLanguage')
                      : phrase(state, 'readingLanguage'),
        ),
        automaticallyImplyLeading: !mustChoose,
        actions: const [PageTools()],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: Text(
              mustChoose
                  ? phrase(state, 'firstHelp')
                  : ui
                      ? 'The language used for menus, buttons, and app labels.'
                      : audio
                          ? phrase(state, 'audioHelp')
                          : phrase(state, 'readingHelp'),
              style: const TextStyle(color: kMuted, height: 1.4),
            ),
          ),
          if (audio)
            ListTile(
              title: Text(phrase(state, 'audioSame')),
              trailing: state.audioLanguage.isEmpty ? const Icon(Icons.check, color: kSaffron) : null,
              onTap: () {
                state.setAudioLanguage('');
                Navigator.pop(context);
              },
            ),
          for (final language in readingLanguages)
            ListTile(
              title: Text(language.label),
              subtitle: ui
                  ? null
                  : language.assisted
                      ? const Text('Reading aid')
                      : const Text('From the Gita library'),
              trailing: _selected(state, language.code) ? const Icon(Icons.check, color: kSaffron) : null,
              onTap: () {
                if (mustChoose) {
                  state.setUiLanguage(language.code);
                  state.setReadingLanguage(language.code);
                } else if (ui) {
                  state.setUiLanguage(language.code);
                } else if (audio) {
                  state.setAudioLanguage(language.code);
                } else {
                  state.setReadingLanguage(language.code);
                }
                Navigator.pop(context, true);
              },
            ),
        ],
      ),
    );
  }

  bool _selected(AppState state, String code) {
    if (ui) return state.uiLanguage == code;
    if (audio) return state.audioLanguage == code;
    return state.readingLanguage == code;
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 6),
      child: Text(label, style: const TextStyle(color: kSaffron, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.6)),
    );
  }
}

class _ZoomPair extends StatelessWidget {
  const _ZoomPair({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final atMin = state.textScale <= zoomSteps.first + 0.001;
    final atMax = state.textScale >= zoomSteps.last - 0.001;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Smaller text',
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          onPressed: atMin ? null : () => state.nudgeZoom(-1),
          icon: const Icon(Icons.text_decrease),
        ),
        IconButton(
          tooltip: 'Larger text',
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          onPressed: atMax ? null : () => state.nudgeZoom(1),
          icon: const Icon(Icons.text_increase),
        ),
      ],
    );
  }
}

class PageTools extends StatelessWidget {
  const PageTools({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ZoomPair(state: state),
        IconButton(
          tooltip: 'Settings',
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
          },
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}
