class TeacherDocumentModel {
  final int id;
  final int groupId;
  final String groupName;
  final String title;
  final String description;
  final String file;
  final int fileSize;
  final String fileSizeMb;
  final bool isVisibleToStudents;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TeacherDocumentModel({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.title,
    required this.description,
    required this.file,
    required this.fileSize,
    required this.fileSizeMb,
    required this.isVisibleToStudents,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeacherDocumentModel.fromJson(Map<String, dynamic> json) {
    return TeacherDocumentModel(
      id: json['id'] as int? ?? 0,
      groupId: json['group_id'] as int? ?? 0,
      groupName: json['group_name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      file: json['file'] as String? ?? '',
      fileSize: json['file_size'] as int? ?? 0,
      fileSizeMb: json['file_size_mb']?.toString() ?? '0',
      isVisibleToStudents: json['is_visible_to_students'] as bool? ?? false,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
