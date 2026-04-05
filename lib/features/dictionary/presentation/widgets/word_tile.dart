import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/tts/tts_service.dart';
import '../../domain/entities/word.dart';

final ttsLanguageProvider = StateProvider<String>((ref) => 'tr-TR');
final ttsVoiceProvider = StateProvider<String?>((ref) => null);
final ttsSpeedProvider = StateProvider<double>((ref) => 0.45);
final ttsPitchProvider = StateProvider<double>((ref) => 1.0);

class WordTile extends ConsumerStatefulWidget {
  const WordTile({
    super.key,
    required this.word,
    required this.onDelete,
  });

  final Word word;
  final Future<void> Function() onDelete;

  @override
  ConsumerState<WordTile> createState() => _WordTileState();
}

class _WordTileState extends ConsumerState<WordTile>
    with SingleTickerProviderStateMixin {
  static final TtsService _tts = TtsService();

  late AnimationController _controller;
  late Animation<double> _scale;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = Tween(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _play(String text) async {
    final language = ref.read(ttsLanguageProvider);
    final voice = ref.read(ttsVoiceProvider);
    final speed = ref.read(ttsSpeedProvider);
    final pitch = ref.read(ttsPitchProvider);

    setState(() => isPlaying = true);
    _controller.repeat(reverse: true);

    await _tts.stop();
    await _tts.speak(
      text: text,
      languageCode: language,
      voiceName: voice,
      speed: speed,
      pitch: pitch,
    );

    _controller.stop();
    _controller.reset();
    if (mounted) setState(() => isPlaying = false);
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.deleteWord),
        content: Text(l10n.deleteWordContent(widget.word.word)),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.onDelete();
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dismissible(
      key: ValueKey(widget.word.wordId),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (_) => _confirmDelete(context),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFFF3B30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
            SizedBox(width: 8),
            Text(
              l10n.delete,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () => _play(widget.word.word),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.translate_rounded,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.word.word,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.word.translation,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ScaleTransition(
                scale: _scale,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.volume_up_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => _play(widget.word.word),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}