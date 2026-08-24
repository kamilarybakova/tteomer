import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/language_entity.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final LanguageEntity selected;
  final List<LanguageEntity> languages;
  final ValueChanged<LanguageEntity> onSelected;

  const LanguageSelectorWidget({
    super.key,
    required this.selected,
    required this.languages,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showLanguagePicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _LanguageBadge(language: selected),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selected.nativeName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _LanguagePickerSheet(
        languages: languages,
        selected: selected,
        onSelected: (lang) {
          Navigator.pop(context);
          onSelected(lang);
        },
      ),
    );
  }
}

class _LanguagePickerSheet extends StatelessWidget {
  final List<LanguageEntity> languages;
  final LanguageEntity selected;
  final ValueChanged<LanguageEntity> onSelected;

  const _LanguagePickerSheet({
    required this.languages,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.selectLanguage,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...languages.map(
            (lang) => ListTile(
              onTap: () => onSelected(lang),
              leading: _LanguageBadge(language: lang, compact: false),
              title: Text(lang.nativeName),
              subtitle: Text(lang.name),
              trailing: selected.code == lang.code
                  ? Icon(Icons.check_rounded, color: theme.colorScheme.primary)
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageBadge extends StatelessWidget {
  final LanguageEntity language;
  final bool compact;

  const _LanguageBadge({required this.language, this.compact = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = language.code.toUpperCase();
    final horizontalPadding = compact ? 8.0 : 10.0;
    final verticalPadding = compact ? 6.0 : 8.0;

    return Container(
      constraints: const BoxConstraints(minWidth: 42),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.primary,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
