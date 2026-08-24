import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tteomer/features/main/domain/usecase/fetch_registration_status.dart';

import '../../data/datasource/daily_learning_datasource.dart';
import '../../domain/usecase/fetch_news_usecase.dart';
import 'main_state.dart';

class MainNotifier extends StateNotifier<NewsState> {
  final FetchNewsUseCase fetchNewsUseCase;
  final FetchRegistrationStatus fetchRegistrationStatus;
  final DailyLearningDatasource dailyLearningDatasource;
  final FlutterSecureStorage storage;

  MainNotifier(
    this.fetchNewsUseCase,
    this.fetchRegistrationStatus,
    this.dailyLearningDatasource,
    this.storage,
  ) : super(const NewsState());

  Future<void> fetchNews() async {
    try {
      state = state.copyWith(status: NewsStatus.loading);

      final response = await fetchNewsUseCase();

      state = state.copyWith(
        status: NewsStatus.success,
        news: response.results,
      );
    } catch (e) {
      state = state.copyWith(status: NewsStatus.error, error: e.toString());
    }
  }

  Future<void> checkRegistrationStatus() async {
    try {
      final response = await fetchRegistrationStatus();
      final isOpen =
          response.data?['data']?['is_registration_opened'] as bool? ?? false;

      state = state.copyWith(isRegistrationOpen: isOpen);
    } catch (e) {
      state = state.copyWith(isRegistrationOpen: false);
    }
  }

  Future<void> fetchDailyLearning({required String localeCode}) async {
    final now = DateTime.now();
    final normalizedDate = DateTime(now.year, now.month, now.day);
    final userLevel = await _readUserLevel();

    final isSameRequest =
        state.dailyLearningContent != null &&
        state.contentLocaleCode == localeCode &&
        state.userLevel == userLevel &&
        state.contentDate == normalizedDate;
    if (isSameRequest) return;

    state = state.copyWith(
      dailyLearningStatus: DailyLearningStatus.loading,
      userLevel: userLevel,
      contentLocaleCode: localeCode,
      contentDate: normalizedDate,
      clearDailyLearningContent: true,
    );

    try {
      final content = await dailyLearningDatasource.getDailyContent(
        localeCode: localeCode,
        level: userLevel,
        date: normalizedDate,
      );

      state = state.copyWith(
        dailyLearningStatus: DailyLearningStatus.success,
        dailyLearningContent: content,
        userLevel: content.level,
      );
    } catch (e) {
      state = state.copyWith(
        dailyLearningStatus: DailyLearningStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<String> _readUserLevel() async {
    final level = await storage.read(key: 'user_level');
    const supported = {'A1', 'A2', 'B1', 'B2', 'C1', 'C2'};
    final normalized = level?.trim().toUpperCase();
    if (normalized != null && supported.contains(normalized)) {
      return normalized;
    }
    return 'A1';
  }
}
