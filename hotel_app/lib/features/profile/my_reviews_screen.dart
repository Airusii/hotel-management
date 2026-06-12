import 'package:flutter/material.dart';
import 'package:hotel_app/l10n/app_localizations.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileMyReviews)),
      body: const Center(child: Text('Сиз калтырган пикирлер ушул жерде көрүнөт')),
    );
  }
}
