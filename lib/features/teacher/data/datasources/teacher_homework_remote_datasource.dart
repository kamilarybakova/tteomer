import 'package:dio/dio.dart';

import '../models/teacher_homework_model.dart';

abstract class TeacherHomeworkRemoteDataSource {
  Future<List<TeacherHomeworkModel>> getTeacherHomework({
    int page = 1,
    int pageSize = 50,
    String? search,
    String? ordering,
  });

  Future<TeacherHomeworkModel> createTeacherHomework({
    required int groupId,
    required String title,
    required String description,
    String? filePath,
    required DateTime dueDate,
    required String targetType,
    required List<int> assignedStudentIds,
    required bool isActive,
  });

  Future<TeacherHomeworkModel> updateTeacherHomework({
    required int homeworkId,
    required int groupId,
    required String title,
    required String description,
    String? filePath,
    required DateTime dueDate,
    required String targetType,
    required List<int> assignedStudentIds,
    required bool isActive,
  });

  Future<void> deleteTeacherHomework(int homeworkId);
}

class TeacherHomeworkRemoteDataSourceImpl
    implements TeacherHomeworkRemoteDataSource {
  final Dio dio;

  TeacherHomeworkRemoteDataSourceImpl(this.dio);

  @override
  Future<List<TeacherHomeworkModel>> getTeacherHomework({
    int page = 1,
    int pageSize = 50,
    String? search,
    String? ordering,
  }) async {
    final response = await dio.get(
      '/api/v1/homework/teacher/',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (search != null && search.isNotEmpty) 'search': search,
        if (ordering != null && ordering.isNotEmpty) 'ordering': ordering,
      },
    );

    final results = _extractResults(response.data as Map<String, dynamic>);
    return results
        .map(
          (item) => TeacherHomeworkModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<TeacherHomeworkModel> createTeacherHomework({
    required int groupId,
    required String title,
    required String description,
    String? filePath,
    required DateTime dueDate,
    required String targetType,
    required List<int> assignedStudentIds,
    required bool isActive,
  }) async {
    final formMap = <String, dynamic>{
      'group_id': groupId.toString(),
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'target_type': targetType,
      'assigned_student_ids': assignedStudentIds.map((id) => id.toString()).toList(),
      'is_active': isActive.toString(),
    };

    if (filePath != null && filePath.isNotEmpty) {
      formMap['file'] = await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      );
    }

    final response = await dio.post(
      '/api/v1/homework/teacher/',
      data: FormData.fromMap(formMap),
      options: Options(contentType: 'multipart/form-data'),
    );

    final payload = _extractItem(response.data as Map<String, dynamic>);
    return TeacherHomeworkModel.fromJson(payload);
  }

  @override
  Future<TeacherHomeworkModel> updateTeacherHomework({
    required int homeworkId,
    required int groupId,
    required String title,
    required String description,
    String? filePath,
    required DateTime dueDate,
    required String targetType,
    required List<int> assignedStudentIds,
    required bool isActive,
  }) async {
    final formMap = <String, dynamic>{
      'group_id': groupId.toString(),
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'target_type': targetType,
      'assigned_student_ids': assignedStudentIds
          .map((id) => id.toString())
          .toList(),
      'is_active': isActive.toString(),
    };

    if (filePath != null && filePath.isNotEmpty) {
      formMap['file'] = await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      );
    }

    final response = await dio.patch(
      '/api/v1/homework/teacher/$homeworkId/',
      data: FormData.fromMap(formMap),
      options: Options(contentType: 'multipart/form-data'),
    );

    final payload = _extractItem(response.data as Map<String, dynamic>);
    return TeacherHomeworkModel.fromJson(payload);
  }

  @override
  Future<void> deleteTeacherHomework(int homeworkId) async {
    await dio.delete('/api/v1/homework/teacher/$homeworkId/');
  }

  List<dynamic> _extractResults(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is Map<String, dynamic>) {
      final results = data['results'];
      if (results is List) return results;
    }

    final results = response['results'];
    if (results is List) return results;

    return const [];
  }

  Map<String, dynamic> _extractItem(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    return response;
  }
}
