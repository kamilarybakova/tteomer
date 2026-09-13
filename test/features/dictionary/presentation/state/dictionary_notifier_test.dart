import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tteomer/features/dictionary/presentation/pages/dictionary_screen.dart';
import 'package:tteomer/features/dictionary/presentation/state/dictionary_provider.dart';
import 'package:tteomer/features/dictionary/domain/entities/word.dart';
import 'package:tteomer/features/dictionary/domain/repositories/dictionary_repository.dart';
import 'package:tteomer/features/dictionary/domain/usecases/delete_all_words.dart';
import 'package:tteomer/features/dictionary/domain/usecases/delete_word.dart';
import 'package:tteomer/features/dictionary/domain/usecases/get_dictionary.dart';
import 'package:tteomer/features/dictionary/presentation/state/dictionary_notifier.dart';
import 'package:tteomer/features/dictionary/presentation/state/dictionary_state.dart';
import 'package:tteomer/l10n/app_localizations.dart';

void main() {
  test('refresh keeps the active search and replaces the first page', () async {
    final repository = _FakeDictionaryRepository();
    final notifier = WordsVM(
      GetWords(repository),
      DeleteAllWords(repository),
      DeleteWord(repository),
    );

    repository.nextWords = [_word(1, 'kitap')];
    await notifier.loadWords();
    repository.nextWords = [_word(2, 'ev')];
    await notifier.searchWords('ev');
    repository.nextWords = [_word(3, 'evler')];

    await notifier.refreshWords();

    expect(repository.lastSearch, 'ev');
    expect(repository.lastPage, 1);
    final state = notifier.state as DictionaryData;
    expect(state.words.map((word) => word.wordId), [3]);
    expect(state.currentPage, 1);
  });

  testWidgets('pulling the short dictionary page refreshes its words', (
    tester,
  ) async {
    final repository = _FakeDictionaryRepository()
      ..nextWords = [_word(1, 'ev')];
    final notifier = WordsVM(
      GetWords(repository),
      DeleteAllWords(repository),
      DeleteWord(repository),
    );
    await notifier.loadWords();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [wordsVmProvider.overrideWith((ref) => notifier)],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: DictionaryBody()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    repository.nextWords = [_word(2, 'kitap')];

    await tester.drag(find.byType(CustomScrollView), const Offset(0, 350));
    await tester.pumpAndSettle();

    expect(repository.requestCount, 2);
    final state = notifier.state as DictionaryData;
    expect(state.words.single.wordId, 2);
  });
}

Word _word(int id, String value) {
  return Word(
    wordId: id,
    word: value,
    translation: value,
    partOfSpeech: null,
    level: null,
    topic: 'Test',
    example: null,
    createdAt: DateTime(2026),
  );
}

class _FakeDictionaryRepository implements DictionaryRepository {
  List<Word> nextWords = [];
  String? lastSearch;
  int? lastPage;
  int requestCount = 0;

  @override
  Future<({bool hasMore, List<Word> words})> getWords({
    String? status,
    String? topic,
    String? search,
    int page = 1,
    int pageSize = 5,
  }) async {
    requestCount++;
    lastSearch = search;
    lastPage = page;
    return (words: nextWords, hasMore: false);
  }

  @override
  Future<void> clearDictionary() async {}

  @override
  Future<void> deleteWord(int id) async {}
}
