import 'package:dio/dio.dart';
import 'package:tteomer/features/teacher/data/models/teacher_homework_model.dart';

abstract class StudentHomeworkRemoteDataSource {
  Future<List<TeacherHomeworkModel>> getStudentHomework({
    int? groupId,
    int page = 1,
    int pageSize = 20,
    String? search,
    String? ordering,
  });
}

class StudentHomeworkRemoteDataSourceImpl
    implements StudentHomeworkRemoteDataSource {
  final Dio dio;

  StudentHomeworkRemoteDataSourceImpl(this.dio);

  @override
  Future<List<TeacherHomeworkModel>> getStudentHomework({
    int? groupId,
    int page = 1,
    int pageSize = 20,
    String? search,
    String? ordering,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (search != null && search.isNotEmpty) 'search': search,
      if (ordering != null && ordering.isNotEmpty) 'ordering': ordering,
    };
    if (groupId != null) {
      queryParameters['group_id'] = groupId;
    }

    final response = await dio.get(
      '/api/v1/homework/student/',
      queryParameters: queryParameters,
    );

    final results = _extractResults(response.data);
    return results
        .whereType<Map<String, dynamic>>()
        .map(TeacherHomeworkModel.fromJson)
        .toList();
  }

  List<dynamic> _extractResults(dynamic response) {
    if (response is List) {
      return response;
    }

    if (response is Map<String, dynamic>) {
      final results = response['results'];
      if (results is List) return results;

      final data = response['data'];
      if (data != null) {
        return _extractResults(data);
      }
    }

    return const [];
  }
}
