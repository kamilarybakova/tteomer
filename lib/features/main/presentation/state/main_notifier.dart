import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/features/main/domain/usecase/fetch_registration_status.dart';

import '../../domain/usecase/fetch_news_usecase.dart';
import 'main_state.dart';

class MainNotifier extends StateNotifier<NewsState> {
  final FetchNewsUseCase fetchNewsUseCase;
  final FetchRegistrationStatus fetchRegistrationStatus;

  MainNotifier(this.fetchNewsUseCase, this.fetchRegistrationStatus)
      : super(const NewsState());

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

  Future<void> checkRegistrationStatus() async {
    try {
      final response = await fetchRegistrationStatus();
      print('DEBUG isRegistrationOpen: ${response.data}');

      final isOpen = response.data?['data']?['is_registration_opened'] as bool? ?? false;
      print('DEBUG isOpen parsed: $isOpen');

      state = state.copyWith(isRegistrationOpen: isOpen);
      print('DEBUG state.isRegistrationOpen: ${state.isRegistrationOpen}');
    } catch (e) {
      print('DEBUG error: $e');
      state = state.copyWith(isRegistrationOpen: false);
    }
  }
}