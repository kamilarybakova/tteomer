import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/tts/tts_service.dart';
import '../../domain/entities/word.dart';

final ttsLanguageProvider = StateProvider<String>((ref) => 'tr-TR');
final ttsVoiceProvider = StateProvider<String?>((ref) => null);
final ttsSpeedProvider = StateProvider<double>((ref) => 0.45);
final ttsPitchProvider = StateProvider<double>((ref) => 1.0);

class WordTile extends ConsumerStatefulWidget {
  const WordTile({super.key, required this.word});

  final Word word;

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

    setState(() => isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.word;

    return GestureDetector(
      onTap: () => _play(word.word),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
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
            /// ИКОНКА СЛЕВА
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

            /// ТЕКСТ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word.word,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    word.translation,
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
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => _play(word.word),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}