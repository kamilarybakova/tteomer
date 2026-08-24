import '../../data/model/news_response_model.dart';
import '../../data/model/daily_learning_content.dart';

enum NewsStatus { initial, loading, success, error }

enum DailyLearningStatus { initial, loading, success, error }

class NewsState {
  final NewsStatus status;
  final DailyLearningStatus dailyLearningStatus;
  final List<NewsItemModel> news;
  final DailyLearningContent? dailyLearningContent;
  final String? error;
  final bool? isRegistrationOpen;
  final String? userLevel;
  final String? contentLocaleCode;
  final DateTime? contentDate;

  const NewsState({
    this.status = NewsStatus.initial,
    this.dailyLearningStatus = DailyLearningStatus.initial,
    this.news = const [],
    this.dailyLearningContent,
    this.error,
    this.isRegistrationOpen,
    this.userLevel,
    this.contentLocaleCode,
    this.contentDate,
  });

  NewsState copyWith({
    NewsStatus? status,
    DailyLearningStatus? dailyLearningStatus,
    List<NewsItemModel>? news,
    DailyLearningContent? dailyLearningContent,
    String? error,
    bool? isRegistrationOpen,
    String? userLevel,
    String? contentLocaleCode,
    DateTime? contentDate,
    bool clearDailyLearningContent = false,
  }) {
    return NewsState(
      status: status ?? this.status,
      dailyLearningStatus: dailyLearningStatus ?? this.dailyLearningStatus,
      news: news ?? this.news,
      dailyLearningContent: clearDailyLearningContent
          ? null
          : (dailyLearningContent ?? this.dailyLearningContent),
      error: error,
      isRegistrationOpen: isRegistrationOpen ?? this.isRegistrationOpen,
      userLevel: userLevel ?? this.userLevel,
      contentLocaleCode: contentLocaleCode ?? this.contentLocaleCode,
      contentDate: contentDate ?? this.contentDate,
    );
  }
}
