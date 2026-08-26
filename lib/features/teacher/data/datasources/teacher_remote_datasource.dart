import 'package:dio/dio.dart';

import '../models/group_student_model.dart';
import '../models/pending_student_model.dart';
import '../models/teacher_group_model.dart';

abstract class TeacherRemoteDataSource {
  Future<List<TeacherGroupModel>> fetchGroups();
  Future<List<PendingStudentModel>> fetchPendingStudents(int groupId);
  Future<List<GroupStudentModel>> fetchGroupStudents(int groupId);
  Future<void> approveStudent({required int groupId, required int studentId});
  Future<void> rejectStudent({required int groupId, required int studentId});
}

class TeacherRemoteDataSourceImpl implements TeacherRemoteDataSource {
  final Dio dio;

  TeacherRemoteDataSourceImpl(this.dio);

  @override
  Future<List<TeacherGroupModel>> fetchGroups() async {
    final response = await dio.get('/api/v1/system/teacher/groups/');
    final results = _extractList(response.data as Map<String, dynamic>);

    return results
        .map((item) => TeacherGroupModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PendingStudentModel>> fetchPendingStudents(int groupId) async {
    final response = await dio.get(
      '/api/v1/system/teacher/groups/$groupId/pending-students/',
    );
    final results = _extractList(response.data as Map<String, dynamic>);

    return results
        .map(
          (item) => PendingStudentModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<GroupStudentModel>> fetchGroupStudents(int groupId) async {
    final response = await dio.get(
      '/api/v1/system/teacher/group-students/',
      queryParameters: {'group_id': groupId},
    );
    final results = _extractList(response.data as Map<String, dynamic>);

    return results
        .map((item) => GroupStudentModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> approveStudent({
    required int groupId,
    required int studentId,
  }) async {
    await dio.post(
      '/api/v1/system/teacher/groups/$groupId/students/$studentId/approve/',
    );
  }

  @override
  Future<void> rejectStudent({
    required int groupId,
    required int studentId,
  }) async {
    await dio.post(
      '/api/v1/system/teacher/groups/$groupId/students/$studentId/reject/',
    );
  }

  List<dynamic> _extractList(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is List) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      final results = data['results'];
      if (results is List) {
        return results;
      }
      final items = data['items'];
      if (items is List) {
        return items;
      }
      final students = data['students'];
      if (students is List) {
        return students;
      }
    }

    return const [];
  }
}
