import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/core/network/dio_client.dart';
import 'package:tteomer/features/main/data/datasource/student_homework_remote_datasource.dart';
import 'package:tteomer/features/teacher/data/models/teacher_homework_model.dart';

final studentHomeworkRemoteDataSourceProvider =
    Provider<StudentHomeworkRemoteDataSource>((ref) {
      return StudentHomeworkRemoteDataSourceImpl(ref.read(dioProvider));
    });

final studentHomeworkProvider = FutureProvider<List<TeacherHomeworkModel>>((
  ref,
) async {
  return ref
      .read(studentHomeworkRemoteDataSourceProvider)
      .getStudentHomework(ordering: 'due_date');
});
