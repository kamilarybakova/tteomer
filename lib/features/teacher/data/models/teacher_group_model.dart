class TeacherGroupModel {
  final int id;
  final String name;
  final String level;
  final String lessonTime;
  final String note;
  final int maxStudents;
  final int currentStudents;
  final String teacherName;

  const TeacherGroupModel({
    required this.id,
    required this.name,
    required this.level,
    required this.lessonTime,
    required this.note,
    required this.maxStudents,
    required this.currentStudents,
    required this.teacherName,
  });

  factory TeacherGroupModel.fromJson(Map<String, dynamic> json) {
    return TeacherGroupModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      level: json['level'] as String? ?? '',
      lessonTime: json['lesson_time'] as String? ?? '',
      note: json['note'] as String? ?? '',
      maxStudents: json['max_students'] as int? ?? 0,
      currentStudents: json['current_students'] as int? ?? 0,
      teacherName: json['teacher_name'] as String? ?? '',
    );
  }
}
