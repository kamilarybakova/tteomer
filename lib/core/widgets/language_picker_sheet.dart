import 'package:flutter/material.dart';
import 'package:tteomer/core/theme/app_colors.dart';

import '../../../../l10n/app_localizations.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text(l10n.language),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _LanguageOption(
            title: l10n.langRussian,
            localeCode: 'ru',
            isSelected: currentLocale == 'ru',
          ),
          _LanguageOption(
            title: l10n.langKyrgyz,
            localeCode: 'ky',
            isSelected: currentLocale == 'ky',
          ),
          _LanguageOption(
            title: l10n.langTurkish,
            localeCode: 'tr',
            isSelected: currentLocale == 'tr',
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String title;
  final String localeCode;
  final bool isSelected;

  const _LanguageOption({
    required this.title,
    required this.localeCode,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.accent)
          : null,
      onTap: () {
        LocaleController.of(context).setLocale(Locale(localeCode));
        Navigator.pop(context);
      },
    );
  }
}

class LocaleController extends InheritedWidget {
  final void Function(Locale locale) setLocale;

  const LocaleController({
    super.key,
    required this.setLocale,
    required super.child,
  });

  static LocaleController of(BuildContext context) {
    final LocaleController? result =
    context.dependOnInheritedWidgetOfExactType<LocaleController>();
    assert(result != null, 'No LocaleController found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(LocaleController oldWidget) => true;
}
