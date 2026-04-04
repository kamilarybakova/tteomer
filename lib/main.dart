import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/core/widgets/language_picker_sheet.dart';

import 'auth_gate.dart';
import 'core/storage/shared_prefs_service.dart';
import 'core/utils/locale_state.dart';
import 'l10n/app_localizations.dart';

void main() async {
  // await NoScreenshot.instance.screenshotOff();
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService.getInstance();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ru');

  void _setLocale(Locale locale) {
    LocaleState.current = locale;
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return LocaleController(
      setLocale: (Locale locale) {
        _setLocale(locale);
      },
      child: MaterialApp(
        title: 'TTOM',
        theme: ThemeData(
          fontFamily: 'SFProDisplay',
        ),
        debugShowCheckedModeBanner: false,
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AuthGate(),
      ),
    );
  }
}
