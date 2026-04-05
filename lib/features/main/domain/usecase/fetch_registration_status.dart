import 'package:dio/dio.dart';

import '../repository/main_repository.dart';

class FetchRegistrationStatus {
  final MainRepository repository;

  FetchRegistrationStatus(this.repository);

  Future<Response<dynamic>> call() async {
    return await repository.isRegistrationOpened();
  }
}