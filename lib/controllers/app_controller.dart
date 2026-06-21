import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends ChangeNotifier {
  AppController._(this._preferences, this._themeMode);

  static const _themeKey = 'theme_mode';

  final SharedPreferences _preferences;
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  static Future<AppController> create() async {
    final preferences = await SharedPreferences.getInstance();
    final savedMode = preferences.getString(_themeKey);
    return AppController._(
      preferences,
      savedMode == 'dark' ? ThemeMode.dark : ThemeMode.light,
    );
  }

  Future<void> setDarkMode(bool enabled) async {
    _themeMode = enabled ? ThemeMode.dark : ThemeMode.light;
    await _preferences.setString(_themeKey, enabled ? 'dark' : 'light');
    notifyListeners();
  }
}

class AppControllerScope extends InheritedNotifier<AppController> {
  const AppControllerScope({
    super.key,
    required AppController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppControllerScope>();
    assert(scope != null, 'AppControllerScope is missing above this context.');
    return scope!.notifier!;
  }
}
