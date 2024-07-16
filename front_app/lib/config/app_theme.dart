import 'package:barassage_app/core/classes/theme_provider.dart';
import 'package:barassage_app/core/classes/theme_manager.dart';

class ThemeProvider extends BaseThemeProvider {
  int _index = 0;

  get index => _index;

  setNavIndex(int index) {
    _index = index;
    if (index != 0) {
      notifyListeners();
    }
  }
}

class MyTheme extends AppTheme {}
