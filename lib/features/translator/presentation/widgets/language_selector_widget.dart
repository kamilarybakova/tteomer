import 'package:flutter/material.dart';
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selected.flag,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Text(
              selected.nativeName,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
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

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Выберите язык',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...languages.map(
                (lang) => ListTile(
              onTap: () => onSelected(lang),
              leading: Text(lang.flag, style: const TextStyle(fontSize: 24)),
              title: Text(lang.nativeName),
              subtitle: Text(lang.name),
              trailing: selected.code == lang.code
                  ? Icon(Icons.check_rounded,
                  color: theme.colorScheme.primary)
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