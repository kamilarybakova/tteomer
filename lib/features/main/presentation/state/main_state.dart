import '../../data/model/news_response_model.dart';

enum NewsStatus { initial, loading, success, error }

class NewsState {
  final NewsStatus status;
  final List<NewsItemModel> news;
  final String? error;

  const NewsState({
    this.status = NewsStatus.initial,
    this.news = const [],
    this.error,
  });

  NewsState copyWith({
    NewsStatus? status,
    List<NewsItemModel>? news,
    String? error,
  }) {
    return NewsState(
      status: status ?? this.status,
      news: news ?? this.news,
      error: error,
    );
  }
}