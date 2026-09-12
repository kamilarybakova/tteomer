import '../../domain/entities/shared_dictionary_word.dart';

class SharedDictionaryWordModel extends SharedDictionaryWord {
  const SharedDictionaryWordModel({
    required super.id,
    required super.turkish,
    required super.translation,
    required super.level,
    required super.partOfSpeech,
    required super.topic,
    required super.example,
    required super.order,
  });

  factory SharedDictionaryWordModel.fromJson(Map<String, dynamic> json) {
    return SharedDictionaryWordModel(
      id: (json['id'] as num).toInt(),
      turkish: json['turkish'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
      level: json['level'] as String? ?? '',
      partOfSpeech: json['part_of_speech'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      example: json['example'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }
}
