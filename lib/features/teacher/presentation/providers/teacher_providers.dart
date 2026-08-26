import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/core/network/dio_client.dart';
import 'package:tteomer/features/teacher/data/datasources/teacher_remote_datasource.dart';
import 'package:tteomer/features/teacher/data/models/group_student_model.dart';
import 'package:tteomer/features/teacher/data/models/pending_student_model.dart';
import 'package:tteomer/features/teacher/data/models/teacher_group_model.dart';

final teacherRemoteDataSourceProvider = Provider<TeacherRemoteDataSource>((
  ref,
) {
  return TeacherRemoteDataSourceImpl(ref.read(dioProvider));
});

final teacherGroupsProvider = FutureProvider<List<TeacherGroupModel>>((
  ref,
) async {
  return ref.read(teacherRemoteDataSourceProvider).fetchGroups();
});

final teacherPendingStudentsProvider =
    FutureProvider.family<List<PendingStudentModel>, int>((ref, groupId) async {
      return ref
          .read(teacherRemoteDataSourceProvider)
          .fetchPendingStudents(groupId);
    });

final teacherGroupStudentsProvider =
    FutureProvider.family<List<GroupStudentModel>, int>((ref, groupId) async {
      return ref
          .read(teacherRemoteDataSourceProvider)
          .fetchGroupStudents(groupId);
    });
