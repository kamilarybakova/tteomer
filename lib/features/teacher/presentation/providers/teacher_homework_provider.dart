import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/core/network/dio_client.dart';
import 'package:tteomer/features/teacher/data/datasources/teacher_homework_remote_datasource.dart';
import 'package:tteomer/features/teacher/data/models/teacher_homework_model.dart';

final teacherHomeworkRemoteDataSourceProvider =
    Provider<TeacherHomeworkRemoteDataSource>((ref) {
      return TeacherHomeworkRemoteDataSourceImpl(ref.read(dioProvider));
    });

final teacherHomeworkProvider = FutureProvider<List<TeacherHomeworkModel>>((
  ref,
) async {
  return ref.read(teacherHomeworkRemoteDataSourceProvider).getTeacherHomework();
});
