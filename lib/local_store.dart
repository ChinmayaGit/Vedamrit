import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  SharedPreferences? _prefs;
  Directory? root;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (Platform.environment['FLUTTER_TEST'] == 'true') return;
    try {
      root = await getApplicationDocumentsDirectory();
    } catch (_) {
      root = null;
    }
  }

  bool contains(String key) => _prefs?.containsKey(key) ?? false;

  String? getString(String key) => _prefs?.getString(key);

  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  File? file(String relative) {
    final base = root;
    if (base == null) return null;
    return File('${base.path}/$relative');
  }

  Future<String?> readText(String relative) async {
    final target = file(relative);
    if (target == null || !await target.exists()) return null;
    return target.readAsString();
  }

  Future<bool> exists(String relative) async {
    final target = file(relative);
    if (target == null) return false;
    return target.exists();
  }

  Future<void> writeText(String relative, String text) async {
    final target = file(relative);
    if (target == null) return;
    await target.parent.create(recursive: true);
    await target.writeAsString(text);
  }

  Future<String?> writeBytes(String relative, List<int> bytes) async {
    final target = file(relative);
    if (target == null) return null;
    await target.parent.create(recursive: true);
    await target.writeAsBytes(bytes, flush: true);
    return target.path;
  }
}
