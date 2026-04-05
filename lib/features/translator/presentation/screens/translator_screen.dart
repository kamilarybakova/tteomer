import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../add_words/presentation/state/add_words_notifier.dart';
import '../../domain/entities/language_entity.dart';
import '../state/translator_notifier.dart';
import '../state/translator_state.dart';
import '../widgets/language_selector_widget.dart';

class TranslatorScreen extends ConsumerStatefulWidget {
  const TranslatorScreen({super.key});

  @override
  ConsumerState<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends ConsumerState<TranslatorScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String? _getTurkishWord(TranslatorState state) {
    if (state.translation == null) return null;
    final src = state.sourceLanguage.code;
    final tgt = state.targetLanguage.code;

    if (src == 'tr') {
      return state.translation!.originalText.trim();
    } else if (tgt == 'tr') {
      return state.translation!.translatedText.trim();
    }
    return null;
  }

  Future<void> _addToWordList(String turkishWord) async {
    final l10n = AppLocalizations.of(context)!;

    final addWord = ref.read(submitAddWordsProvider);
    ref.read(addWordsProvider.notifier).setWords([turkishWord]);
    await addWord();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.added_to_dictionary(turkishWord)),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF6C63FF),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(translatorNotifierProvider);
    final notifier = ref.read(translatorNotifierProvider.notifier);
    final turkishWord = _getTurkishWord(state);
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          title: Text(
            l10n.translator_title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF8E7BFF)],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.translate_rounded,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.instant_translation,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.ai_translator,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _LanguageBar(state: state, notifier: notifier),

            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.sourceLanguage.nativeName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF8E7BFF))),

                    const SizedBox(height: 10),

                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: l10n.enter_text_hint,
                        border: InputBorder.none,
                      ),
                      onChanged: notifier.onTextChanged,
                    ),

                    if (state.inputText.isNotEmpty) ...[
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.symbols_count(state.inputText.length),
                          ),
                          GestureDetector(
                            onTap: () {
                              _controller.clear();
                              notifier.clearInput();
                            },
                            child: Text(l10n.clear),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            _ResultCard(state: state),

            if (turkishWord != null && turkishWord.isNotEmpty) ...[
              const SizedBox(height: 12),
              _AddToDictionaryButton(
                turkishWord: turkishWord,
                onTap: () => _addToWordList(turkishWord),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LanguageBar extends StatelessWidget {
  final TranslatorState state;
  final TranslatorNotifier notifier;

  const _LanguageBar({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: LanguageSelectorWidget(
              selected: state.sourceLanguage,
              languages: LanguageEntity.supportedLanguages,
              onSelected: notifier.setSourceLanguage,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: notifier.swapLanguages,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                color: Color(0xFF6C63FF),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: LanguageSelectorWidget(
              selected: state.targetLanguage,
              languages: LanguageEntity.supportedLanguages,
              onSelected: notifier.setTargetLanguage,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final TranslatorState state;

  const _ResultCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (state.status) {
        TranslatorStatus.idle => const SizedBox.shrink(),

        TranslatorStatus.loading => Container(
          key: const ValueKey('loading'),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),

        TranslatorStatus.error => Container(
          key: const ValueKey('error'),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.translation_error,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),

        TranslatorStatus.success => Container(
          key: const ValueKey('success'),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.targetLanguage.nativeName,
                      style: const TextStyle(
                        color: Color(0xFF8E7BFF),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: state.translation!.translatedText,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.copied),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.copy_rounded, size: 16, color: Color(0xFF6C63FF)),
                          SizedBox(width: 4),
                          Text(
                            l10n.copy,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6C63FF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SelectableText(state.translation!.translatedText, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      },
    );
  }
}

class _AddToDictionaryButton extends StatefulWidget {
  final String turkishWord;
  final VoidCallback onTap;

  const _AddToDictionaryButton({
    required this.turkishWord,
    required this.onTap,
  });

  @override
  State<_AddToDictionaryButton> createState() =>
      _AddToDictionaryButtonState();
}

class _AddToDictionaryButtonState extends State<_AddToDictionaryButton> {
  bool _loading = false;
  bool _added = false;

  Future<void> _handle() async {
    if (_loading || _added) return;
    setState(() => _loading = true);
    try {
      widget.onTap();
      setState(() => _added = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void didUpdateWidget(_AddToDictionaryButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.turkishWord != widget.turkishWord) {
      _added = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: _handle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _added ? const Color(0xFFE8F5E9) : Colors.white,
          border: Border.all(
            color: _added
                ? const Color(0xFF4CAF50)
                : const Color(0xFF6C63FF),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_loading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                _added
                    ? Icons.check_circle_outline_rounded
                    : Icons.bookmark_add_outlined,
                size: 20,
                color: _added
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFF6C63FF),
              ),

            const SizedBox(width: 8),
            Text(
              _added
                  ? l10n.added(widget.turkishWord)
                  : l10n.add_to_dictionary(widget.turkishWord),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _added
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFF6C63FF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}