import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeModeProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final String _themeModeKey = 'themeMode';
  late ThemeMode _themeMode = ThemeMode.values[GetStorage().read(_themeModeKey) ?? 1];

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void changeMode() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }

    notifyListeners();

    GetStorage().write(_themeModeKey, _themeMode.index);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    // TODO: implement debugFillProperties
    super.debugFillProperties(properties);
    properties.add(EnumProperty(_themeModeKey, themeMode));
  }
}
