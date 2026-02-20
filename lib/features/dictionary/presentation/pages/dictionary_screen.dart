import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';

class DictionaryScreen extends ConsumerStatefulWidget {
  const DictionaryScreen({super.key});

  @override
  ConsumerState<DictionaryScreen> createState() =>
      _DictionaryScreenState();
}

class _DictionaryScreenState
    extends ConsumerState<DictionaryScreen> {


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabDictionary),
        automaticallyImplyLeading: false,
      ),
      body: const Placeholder(),
    );
  }
}

