class NewsResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<NewsItemModel> results;

  NewsResponseModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return NewsResponseModel(
      count: data['count'] ?? 0,
      next: data['next'],
      previous: data['previous'],
      results: (data['results'] as List<dynamic>? ?? [])
          .map((e) => NewsItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}

class NewsItemModel {
  final int id;
  final String title;
  final String description;
  final String tag;
  final String image;

  NewsItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
    required this.image,
  });

  factory NewsItemModel.fromJson(Map<String, dynamic> json) {
    return NewsItemModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      tag: json['tag'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tag': tag,
      'image': image,
    };
  }
}