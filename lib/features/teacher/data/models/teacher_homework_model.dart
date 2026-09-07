class TeacherHomeworkModel {
  final int id;
  final int groupId;
  final String groupName;
  final String title;
  final String description;
  final String? file;
  final int? fileSize;
  final double? fileSizeMb;
  final DateTime? dueDate;
  final String targetType;
  final List<int> assignedStudentIds;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TeacherHomeworkModel({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.title,
    required this.description,
    required this.file,
    required this.fileSize,
    required this.fileSizeMb,
    required this.dueDate,
    required this.targetType,
    required this.assignedStudentIds,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isIndividual => targetType.toUpperCase() == 'INDIVIDUAL';

  factory TeacherHomeworkModel.fromJson(Map<String, dynamic> json) {
    return TeacherHomeworkModel(
      id: json['id'] as int? ?? 0,
      groupId: json['group_id'] as int? ?? 0,
      groupName: json['group_name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      file: json['file'] as String?,
      fileSize: json['file_size'] as int?,
      fileSizeMb: (json['file_size_mb'] as num?)?.toDouble(),
      dueDate: _parseDate(json['due_date']),
      targetType: json['target_type'] as String? ?? 'GROUP',
      assignedStudentIds: (json['assigned_student_ids'] as List<dynamic>? ?? const [])
          .map((id) => int.tryParse(id.toString()) ?? 0)
          .where((id) => id > 0)
          .toList(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  static DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
