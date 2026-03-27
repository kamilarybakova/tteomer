import '../../data/model/news_response_model.dart';
import '../repository/main_repository.dart';

class FetchNewsUseCase {
  final MainRepository repository;

  FetchNewsUseCase(this.repository);

  Future<NewsResponseModel> call() async {
    return await repository.fetchNews();
  }
}