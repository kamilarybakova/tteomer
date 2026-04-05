import '../../data/model/news_response_model.dart';

enum NewsStatus { initial, loading, success, error }

class NewsState {
  final NewsStatus status;
  final List<NewsItemModel> news;
  final String? error;
  final bool? isRegistrationOpen;

  const NewsState({
    this.status = NewsStatus.initial,
    this.news = const [],
    this.error,
    this.isRegistrationOpen,
  });

  NewsState copyWith({
    NewsStatus? status,
    List<NewsItemModel>? news,
    String? error,
    bool? isRegistrationOpen,
  }) {
    return NewsState(
      status: status ?? this.status,
      news: news ?? this.news,
      error: error,
      isRegistrationOpen: isRegistrationOpen ?? this.isRegistrationOpen,
    );
  }
}