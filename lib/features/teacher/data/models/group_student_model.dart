class GroupStudentModel {
  final int id;
  final int studentId;
  final String email;
  final String firstName;
  final String lastName;
  final String level;

  const GroupStudentModel({
    required this.id,
    required this.studentId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.level,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory GroupStudentModel.fromJson(Map<String, dynamic> json) {
    final student = json['student'] as Map<String, dynamic>?;

    return GroupStudentModel(
      id: (json['id'] as int?) ?? (student?['id'] as int?) ?? 0,
      studentId:
          (json['student_id'] as int?) ??
          (student?['id'] as int?) ??
          (json['id'] as int?) ??
          0,
      email: (json['email'] as String?) ?? (student?['email'] as String?) ?? '',
      firstName:
          (json['first_name'] as String?) ??
          (student?['first_name'] as String?) ??
          '',
      lastName:
          (json['last_name'] as String?) ??
          (student?['last_name'] as String?) ??
          '',
      level: (json['level'] as String?) ?? (student?['level'] as String?) ?? '',
    );
  }
}
