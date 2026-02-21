import '../../../dictionary/domain/entities/word.dart';

sealed class AddWordState {
  const AddWordState();
}

class AddWordIdle extends AddWordState {
  const AddWordIdle();
}

class AddWordLoading extends AddWordState {
  const AddWordLoading();
}

class AddWordSuccess extends AddWordState {
  final List<Word> words;
  const AddWordSuccess(this.words);
}

class AddWordError extends AddWordState {
  final String message;
  const AddWordError(this.message);
}
