import 'category_model.dart';

class MaterialModel {
  final int id;
  final String title;
  final String description;
  final String level;
  final String audience;
  final CategoryModel? category; // ✅ nullable
  final String file;
  final int fileSize;
  final String fileSizeMb;
  final bool isPinned;
  final DateTime createdAt;

  MaterialModel({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.audience,
    required this.category,
    required this.file,
    required this.fileSize,
    required this.fileSizeMb,
    required this.isPinned,
    required this.createdAt,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      level: json['level'] ?? '',
      audience: json['audience'] ?? '',
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      file: json['file'] ?? '',
      fileSize: json['file_size'] ?? 0,
      fileSizeMb: json['file_size_mb']?.toString() ?? '0',
      isPinned: json['is_pinned'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
