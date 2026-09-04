import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/core/network/dio_client.dart';
import 'package:tteomer/features/documents/data/datasource/teacher_documents_remote_datasource.dart';
import 'package:tteomer/features/documents/data/model/teacher_document_model.dart';

final teacherDocumentsRemoteDataSourceProvider =
    Provider<TeacherDocumentsRemoteDataSource>((ref) {
      return TeacherDocumentsRemoteDataSourceImpl(ref.read(dioProvider));
    });

final teacherDocumentsProvider = FutureProvider<List<TeacherDocumentModel>>((
  ref,
) async {
  return ref
      .read(teacherDocumentsRemoteDataSourceProvider)
      .getTeacherDocuments();
});
