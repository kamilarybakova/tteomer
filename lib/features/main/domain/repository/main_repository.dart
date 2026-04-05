import 'package:dio/dio.dart';

import '../../data/model/news_response_model.dart';

abstract class MainRepository {
  Future<NewsResponseModel> fetchNews();
  Future<Response<dynamic>> isRegistrationOpened();
}