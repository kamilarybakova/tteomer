import 'package:dio/src/response.dart';

import '../../domain/repository/main_repository.dart';
import '../datasource/main_remote_datasource.dart';
import '../model/news_response_model.dart';

class MainRepositoryImpl implements MainRepository {
  final MainRemoteDatasource remoteDatasource;

  MainRepositoryImpl(this.remoteDatasource);

  @override
  Future<NewsResponseModel> fetchNews() async {
    try {
      final result = await remoteDatasource.fetchNews();
      return result;
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }

  @override
  Future<Response<dynamic>> isRegistrationOpened() async {
    try {
      final result = await remoteDatasource.isRegistrationOpened();
      return result;
    } catch (e) {
      throw Exception('Failed to fetch registration status: $e');
    }
  }
}