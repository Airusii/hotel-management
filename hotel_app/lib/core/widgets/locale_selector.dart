import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
import 'package:hotel_app/core/providers/locale_provider.dart';

/// Компактная кнопка выбора языка для AppBar или Settings
///
/// Использование в AppBar:
/// ```dart
/// actions: [const LocaleSelectorButton()],
/// ```
class LocaleSelectorButton extends ConsumerWidget {
  const LocaleSelectorButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final flag = localeFlags[currentLocale.languageCode] ?? '🌐';

    return IconButton(
      tooltip: 'Change language',
      icon: Text(flag, style: const TextStyle(fontSize: 20)),
      onPressed: () => _showLanguageDialog(context, ref, currentLocale),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    Locale currentLocale,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🌐'),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: supportedLocales.map((locale) {
            final isSelected = locale.languageCode == currentLocale.languageCode;
            final flag = localeFlags[locale.languageCode] ?? '';
            final name = localeNames[locale.languageCode] ?? locale.languageCode;

            return ListTile(
              leading: Text(flag, style: const TextStyle(fontSize: 24)),
              title: Text(name),
              trailing: isSelected
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              selected: isSelected,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(locale);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Виджет выбора языка в виде карточки — для страницы настроек
class LocaleSelectorCard extends ConsumerWidget {
  const LocaleSelectorCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              '🌐  Language / Язык / Тил',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...supportedLocales.map((locale) {
            final isSelected = locale.languageCode == currentLocale.languageCode;
            final flag = localeFlags[locale.languageCode] ?? '';
            final name = localeNames[locale.languageCode] ?? locale.languageCode;

            return RadioListTile<String>(
              value: locale.languageCode,
              groupValue: currentLocale.languageCode,
              title: Text('$flag  $name'),
              onChanged: (_) =>
                  ref.read(localeProvider.notifier).setLocale(locale),
              selected: isSelected,
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
