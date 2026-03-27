import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecase/fetch_news_usecase.dart';
import 'main_state.dart';

class MainNotifier extends StateNotifier<NewsState> {
  final FetchNewsUseCase fetchNewsUseCase;

  MainNotifier(this.fetchNewsUseCase) : super(const NewsState());

  Future<void> fetchNews() async {
    try {
      state = state.copyWith(status: NewsStatus.loading);

      final response = await fetchNewsUseCase();

      state = state.copyWith(
        status: NewsStatus.success,
        news: response.results,
      );
    } catch (e) {
      state = state.copyWith(
        status: NewsStatus.error,
        error: e.toString(),
      );
    }
  }
}