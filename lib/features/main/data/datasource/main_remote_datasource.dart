import 'package:dio/dio.dart';
import '../model/news_response_model.dart';

abstract class MainRemoteDatasource {
  Future<NewsResponseModel> fetchNews();
  Future<Response<dynamic>> isRegistrationOpened();
}

class MainRemoteDatasourceImpl implements MainRemoteDatasource {
  final Dio dio;

  MainRemoteDatasourceImpl(this.dio);

  @override
  Future<NewsResponseModel> fetchNews() async {
    final response = await dio.get(
      '/api/v1/news/'
    );

    return NewsResponseModel.fromJson(response.data);
  }

  @override
  Future<Response<dynamic>> isRegistrationOpened() async {
    final response = await dio.get(
        '/api/v1/system/'
    );

    return response;
  }
}