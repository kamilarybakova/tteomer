import '../../data/model/news_response_model.dart';

abstract class MainRepository {
  Future<NewsResponseModel> fetchNews();
}