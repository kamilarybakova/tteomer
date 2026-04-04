import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/core/theme/app_colors.dart';
import 'package:tteomer/features/add_words/presentation/widgets/word_item.dart';

import '../../../../l10n/app_localizations.dart';
import '../state/add_words_notifier.dart';
import '../widgets/drag_handle.dart';

class AddManuallyBottomSheet extends ConsumerStatefulWidget {
  const AddManuallyBottomSheet({super.key});

  @override
  ConsumerState<AddManuallyBottomSheet> createState() =>
      _AddManuallyBottomSheetState();
}

class _AddManuallyBottomSheetState
    extends ConsumerState<AddManuallyBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _words = [];

  void _parseWords() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final parsed = text
        .split(RegExp(r'[\n,;]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    setState(() {
      _words
        ..clear()
        ..addAll(parsed);
    });
  }

  void _removeWord(int index) {
    setState(() {
      _words.removeAt(index);
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    ref.read(addWordsProvider.notifier).setWords(_words);
    await ref.read(submitAddWordsProvider)();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F3F3),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DragHandle(),
                  const SizedBox(height: 16),

                  Text(
                    l10n?.addManually ?? 'Add manually',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _controller,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText:
                      l10n?.manualInputHint ??
                          'Enter one or multiple words\n(one per line)',
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _parseWords,
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: Text(l10n?.check ?? 'Check'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (_words.isNotEmpty) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n?.detectedWords ?? 'Detected words',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _words.length,
                      itemBuilder: (context, index) {
                        return WordItem(
                          word: _words[index],
                          onDelete: () => _removeWord(index),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submit,
                        label: Text(l10n?.save ?? 'Save'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
