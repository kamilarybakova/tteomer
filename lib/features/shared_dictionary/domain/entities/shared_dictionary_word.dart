class SharedDictionaryWord {
  final int id;
  final String turkish;
  final String translation;
  final String level;
  final String partOfSpeech;
  final String topic;
  final String example;
  final int order;

  const SharedDictionaryWord({
    required this.id,
    required this.turkish,
    required this.translation,
    required this.level,
    required this.partOfSpeech,
    required this.topic,
    required this.example,
    required this.order,
  });
}
