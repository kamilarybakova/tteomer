import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tteomer/features/translator/presentation/screens/translator_screen.dart';
import '../../l10n/app_localizations.dart';
import 'features/dictionary/presentation/pages/dictionary_screen.dart';
import 'features/documents/presentation/pages/documents_screen.dart';
import 'features/main/presentation/pages/home_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int index = 0;

  late final pages = [
    const HomeScreen(),
    const DictionaryScreen(),
    const DocumentsScreen(),
    const TranslatorScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF3F3F3),
      body: IndexedStack(
        index: index,
        children: pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: SizedBox(
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: BottomNavigationBar(
                    selectedFontSize: 11,
                    unselectedFontSize: 11,
                    iconSize: 22,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: index,
                    onTap: (i) => setState(() => index = i),
                    selectedItemColor: const Color(0xFF4C63D2),
                    items: [
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.home_outlined),
                        activeIcon: const Icon(Icons.home),
                        label: l10n.tabHome,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.menu_book_outlined),
                        activeIcon: const Icon(Icons.menu_book),
                        label: l10n.tabDictionary,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.description_outlined),
                        activeIcon: const Icon(Icons.description),
                        label: l10n.tabDocs,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.wordpress_outlined),
                        activeIcon: const Icon(Icons.wordpress),
                        label: l10n.tabTranslator,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
