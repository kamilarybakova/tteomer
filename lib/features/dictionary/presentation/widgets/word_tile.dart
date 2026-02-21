import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/tts/tts_service.dart';
import '../../domain/entities/word.dart';

final ttsLanguageProvider = StateProvider<String>((ref) => 'tr-TR');
final ttsVoiceProvider = StateProvider<String?>((ref) => null);
final ttsSpeedProvider = StateProvider<double>((ref) => 0.45);
final ttsPitchProvider = StateProvider<double>((ref) => 1.0);

class WordTile extends ConsumerWidget {
  const WordTile({super.key, required this.word});

  final Word word;

  static final TtsService _tts = TtsService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(ttsLanguageProvider);
    final voice = ref.watch(ttsVoiceProvider);
    final speed = ref.watch(ttsSpeedProvider);
    final pitch = ref.watch(ttsPitchProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.word,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  word.translation,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(
              Icons.volume_up_rounded,
              color: AppColors.accent,
            ),
            onPressed: () async {
              await _tts.stop();

              await _tts.speak(
                text: word.word,
                languageCode: language,
                voiceName: voice,
                speed: speed,
                pitch: pitch,
              );
            },
          ),
        ],
      ),
    );
  }
}