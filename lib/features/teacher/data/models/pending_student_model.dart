class PendingStudentModel {
  final int id;
  final int studentId;
  final String email;
  final String firstName;
  final String lastName;
  final String requestedAt;

  const PendingStudentModel({
    required this.id,
    required this.studentId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.requestedAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory PendingStudentModel.fromJson(Map<String, dynamic> json) {
    return PendingStudentModel(
      id: json['id'] as int? ?? 0,
      studentId: json['student_id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      requestedAt: json['requested_at'] as String? ?? '',
    );
  }
}
