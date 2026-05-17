import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_gate.dart';
import 'core/storage/shared_prefs_service.dart';
import 'core/utils/locale_state.dart';
import 'core/widgets/language_picker_sheet.dart';
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

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final saved = await LocaleService.getSavedLocale();
    if (saved != null) {
      setState(() {
        _locale = saved;
        LocaleState.current = saved;
      });
    }
  }

  void _setLocale(Locale locale) {
    LocaleState.current = locale;
    LocaleService.saveLocale(locale);
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return LocaleController(
      setLocale: _setLocale,
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