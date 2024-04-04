import 'package:shared_preferences/shared_preferences.dart';
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

  late bool _rememberLoginData;
  late bool _hasSeenIntro;

  Future<void> init() async {
    if (_initialized) throw PrefsAlreadyInitialized();

    _prefs = await SharedPreferences.getInstance();
    _rememberLoginData = _prefs.getBool(_rememberLoginDataKey) ?? false;
    _hasSeenIntro = _prefs.getBool(_hasSeenIntroKey) ?? false;

    _initialized = true;
  }

  Future<void> setRememberLogin({required bool? value}) async {
    if (!_initialized) throw PrefsNotInitialized();

    await _prefs.setBool(_rememberLoginDataKey, value!);
  }

  Future<void> setHasSeenIntro({required bool value}) async {
    if (!_initialized) throw PrefsNotInitialized();

    await _prefs.setBool(_hasSeenIntroKey, value);
  }

  bool get rememberLoginData => _rememberLoginData;
  bool get rememberHasSeenIntro => _hasSeenIntro;
}
