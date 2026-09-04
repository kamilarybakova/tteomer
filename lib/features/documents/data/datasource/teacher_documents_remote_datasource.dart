import 'package:dio/dio.dart';

import '../model/teacher_document_model.dart';

abstract class TeacherDocumentsRemoteDataSource {
  Future<List<TeacherDocumentModel>> getTeacherDocuments({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? ordering,
  });

  Future<TeacherDocumentModel> createTeacherDocument({
    required int groupId,
    required String title,
    required String filePath,
    String? description,
    required bool isVisibleToStudents,
  });

  Future<TeacherDocumentModel> updateTeacherDocument({
    required int documentId,
    int? groupId,
    String? title,
    String? description,
    String? filePath,
    bool? isVisibleToStudents,
  });

  Future<void> deleteTeacherDocument(int documentId);
}

class TeacherDocumentsRemoteDataSourceImpl
    implements TeacherDocumentsRemoteDataSource {
  final Dio dio;

  TeacherDocumentsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<TeacherDocumentModel>> getTeacherDocuments({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? ordering,
  }) async {
    final response = await dio.get(
      '/api/v1/materials/teacher-documents/',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (search != null && search.isNotEmpty) 'search': search,
        if (ordering != null && ordering.isNotEmpty) 'ordering': ordering,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final payload = data['data'] as Map<String, dynamic>? ?? const {};
    final results = (payload['results'] as List<dynamic>? ?? const []);

    return results
        .map(
          (item) => TeacherDocumentModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<TeacherDocumentModel> createTeacherDocument({
    required int groupId,
    required String title,
    required String filePath,
    String? description,
    required bool isVisibleToStudents,
  }) async {
    final fileName = filePath.split('/').last;
    final formData = FormData.fromMap({
      'group_id': groupId,
      'title': title,
      'description': description ?? '',
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      'is_visible_to_students': isVisibleToStudents.toString(),
    });

    final response = await dio.post(
      '/api/v1/materials/teacher-documents/',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final data = response.data as Map<String, dynamic>;
    final payload = data['data'] as Map<String, dynamic>? ?? data;
    return TeacherDocumentModel.fromJson(payload);
  }

  @override
  Future<TeacherDocumentModel> updateTeacherDocument({
    required int documentId,
    int? groupId,
    String? title,
    String? description,
    String? filePath,
    bool? isVisibleToStudents,
  }) async {
    final formMap = <String, dynamic>{
      'group_id': groupId,
      'title': title,
      'description': description,
      if (isVisibleToStudents != null)
        'is_visible_to_students': isVisibleToStudents.toString(),
    };

    if (filePath != null && filePath.isNotEmpty) {
      final fileName = filePath.split('/').last;
      formMap['file'] = await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      );
    }

    final response = await dio.patch(
      '/api/v1/materials/teacher-documents/$documentId/',
      data: FormData.fromMap(formMap),
      options: Options(contentType: 'multipart/form-data'),
    );

    final data = response.data as Map<String, dynamic>;
    final payload = data['data'] as Map<String, dynamic>? ?? data;
    return TeacherDocumentModel.fromJson(payload);
  }

  @override
  Future<void> deleteTeacherDocument(int documentId) async {
    await dio.delete('/api/v1/materials/teacher-documents/$documentId/');
  }
}
