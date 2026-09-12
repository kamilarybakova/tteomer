import 'package:flutter_test/flutter_test.dart';
import 'package:tteomer/features/shared_dictionary/data/models/shared_dictionary_word_model.dart';

void main() {
  test('parses a shared dictionary word response', () {
    final word = SharedDictionaryWordModel.fromJson({
      'id': 7,
      'turkish': 'merhaba',
      'translation': 'привет',
      'level': 'A1',
      'part_of_speech': 'interjection',
      'topic': 'Приветствия',
      'example': 'Merhaba, nasılsın?',
      'order': 3,
    });

    expect(word.id, 7);
    expect(word.turkish, 'merhaba');
    expect(word.translation, 'привет');
    expect(word.level, 'A1');
    expect(word.partOfSpeech, 'interjection');
    expect(word.topic, 'Приветствия');
    expect(word.example, 'Merhaba, nasılsın?');
    expect(word.order, 3);
  });

  test('uses safe defaults for optional fields', () {
    final word = SharedDictionaryWordModel.fromJson({'id': 1, 'turkish': 'ev'});

    expect(word.translation, isEmpty);
    expect(word.topic, isEmpty);
    expect(word.order, 0);
  });
}
