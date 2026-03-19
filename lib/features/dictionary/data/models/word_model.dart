import '../../domain/entities/word.dart';

class WordModel extends Word {
  const WordModel({
    required super.word,
    required super.translation,
    required super.partOfSpeech,
    required super.level,
    required super.topic,
    required super.example,
    required super.createdAt,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      word: json['turkish'] as String,
      translation: (json['translation'] as String?) ?? '',
      partOfSpeech: (json['part_of_speech'] as String?) ?? '',
      level: (json['level'] as String?) ?? '',
      topic: (json['topic'] as String?) ?? '',
      example: (json['example'] as String?) ?? '',
      createdAt: DateTime.parse(json['added_at'] as String),
    );
  }
}