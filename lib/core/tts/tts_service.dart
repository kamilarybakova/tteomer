import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;

    try {
      await _tts.setSharedInstance(true);
      await _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ],
        IosTextToSpeechAudioMode.defaultMode,
      );

      await _tts.awaitSpeakCompletion(true);
      await _tts.setVolume(1.0);

      _initialized = true;
    } catch (e) {
      debugPrint('TTS init error: $e');
    }
  }

  Future<List<Map<String, String>>> getVoices() async {
    await _init();

    try {
      final voices = await _tts.getVoices;
      if (voices is List) {
        return voices.map((voice) {
          return {
            'name': voice['name']?.toString() ?? '',
            'locale': voice['locale']?.toString() ?? '',
          };
        }).toList();
      }
    } catch (e) {
      debugPrint('Error getting voices: $e');
    }

    return [];
  }

  Future<void> speak({
    required String text,
    required String languageCode,
    String? voiceName,
    double? speed,
    double? pitch,
  }) async {
    await _init();

    if (text.trim().isEmpty) return;

    try {
      await _tts.setLanguage(languageCode);

      if (voiceName != null && voiceName.isNotEmpty) {
        await _tts.setVoice({"name": voiceName, "locale": languageCode});
      }

      await _tts.setSpeechRate(speed ?? 0.45);
      await _tts.setPitch(pitch ?? 1.0);

      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e) {
      debugPrint('TTS stop error: $e');
    }
  }

  void dispose() {
    _tts.stop();
  }
}