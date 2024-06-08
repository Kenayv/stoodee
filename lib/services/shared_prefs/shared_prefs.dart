import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoodee/localization/locales.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs_exceptions.dart';

class SharedPrefs {
  late final SharedPreferences _prefs;
  bool _initialized = false;

  //ToDoService should be only used via singleton //
  static final SharedPrefs _shared = SharedPrefs._sharedInstance();
  factory SharedPrefs() => _shared;
  SharedPrefs._sharedInstance();
  //ToDoService should be only used via singleton //

  static const _hasSeenIntroKey = 'has_seen_intro';
  static const _rememberLoginDataKey = 'remember_login_data';
  static const _preferredThemeKey = 'preferred_theme';
  static const _preferredLangKey = 'preferred_lang';

  static const lightTheme = 'light_theme';
  static const darkTheme = 'dark_theme';

  late bool _rememberLoginData;
  late bool _hasSeenIntro;
  late String _preferredTheme;
  late String _preferredLang;

  Future<void> init() async {
    if (_initialized) throw PrefsAlreadyInitialized();

    _prefs = await SharedPreferences.getInstance();
    _rememberLoginData = _prefs.getBool(_rememberLoginDataKey) ?? false;
    _hasSeenIntro = _prefs.getBool(_hasSeenIntroKey) ?? false;
    _preferredTheme = _prefs.getString(_preferredThemeKey) ?? lightTheme;
    _preferredLang =
        _prefs.getString(_preferredLangKey) ?? LocaleData.polishLang;

    _initialized = true;
  }

  Future<void> setRememberLogin({required bool value}) async {
    if (!_initialized) throw PrefsNotInitialized();

    _rememberLoginData = value;
    await _prefs.setBool(_rememberLoginDataKey, value);
  }

  Future<void> setPreferredTheme({required String value}) async {
    if (!_initialized) throw PrefsNotInitialized();
    if (value != lightTheme && value != darkTheme) {
      throw Exception('not existing theme argument!');
    }

    await _prefs.setString(_preferredThemeKey, value);
    _preferredTheme = value;
  }

  Future<void> setPreferredLang({required String value}) async {
    if (!_initialized) throw PrefsNotInitialized();
    if (value != LocaleData.englishLang && value != LocaleData.polishLang) {
      throw Exception('not existing lang argument!');
    }

    await _prefs.setString(_preferredLang, value);
    _preferredLang = value;
  }

  Future<void> setHasSeenIntro({required bool value}) async {
    if (!_initialized) throw PrefsNotInitialized();

    _hasSeenIntro = value;
    await _prefs.setBool(_hasSeenIntroKey, value);
  }

  bool get rememberLoginData => _rememberLoginData;
  bool get rememberHasSeenIntro => _hasSeenIntro;
  String get preferredTheme => _preferredTheme;
  String get preferredLang => _preferredLang;
}
