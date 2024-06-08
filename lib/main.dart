import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/go_router_service.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';
import 'package:stoodee/utilities/theme/theme.dart';
import 'package:stoodee/localization/locales.dart';

Future<void> initApp() async {
  await SharedPrefs().init();
  await AuthService.firebase().init();

  if (!SharedPrefs().rememberLoginData &&
      AuthService.firebase().currentUser != null) {
    await AuthService.firebase().logOut();
  }

  await LocalDbController().init();

  if (SharedPrefs().preferredTheme == SharedPrefs.lightTheme) {
    usertheme = whitetheme;
  } else {
    usertheme = blacktheme;
  }
}

//TODO: nie wiem czy to wszystko powinno w mainie byc
late String currentLocale;
final FlutterLocalization localization = FlutterLocalization.instance;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    localization.init(
      mapLocales: LOCALES,
      initLanguageCode: SharedPrefs().preferredLang,
    );
    localization.onTranslatedLanguage = onTranslatedLangauge;
    currentLocale = localization.currentLocale!.languageCode;
  }

  void onTranslatedLangauge(Locale? locale) {
    currentLocale = locale!.languageCode.toString();

    SharedPrefs().setPreferredLang(value: currentLocale);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouterService,
      debugShowCheckedModeBanner: false,
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();

  runApp(const MyApp());
}
