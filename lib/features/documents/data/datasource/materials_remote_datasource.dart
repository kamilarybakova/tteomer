import 'package:dio/dio.dart';

import '../model/category_model.dart';
import '../model/material_model.dart';

abstract class MaterialsRemoteDataSource {
  Future<({List<MaterialModel> materials, bool hasMore})> getMaterials({
    String? level,
    String? categoryId,
    int page = 1,
    int pageSize = 10,
  });

  Future<List<CategoryModel>> getCategories();
}

class MaterialsRemoteDataSourceImpl implements MaterialsRemoteDataSource {
  final Dio dio;
  MaterialsRemoteDataSourceImpl(this.dio);

  @override
  Future<({List<MaterialModel> materials, bool hasMore})> getMaterials({
    String? level,
    String? categoryId,
    int page = 1,
    int pageSize = 10,
  }) async {
    final res = await dio.get(
      '/api/v1/materials/',
      queryParameters: {
        'level': level,
        'category': categoryId,
        'page': page,
        'page_size': pageSize,
      },
    );

    final dynamic data = res.data['data'];
    final List results;
    bool hasMore = false;

    // API may return either paginated object {results, next} or grouped list.
    if (data is Map<String, dynamic>) {
      results = (data['results'] as List?) ?? const [];
      hasMore = data['next'] != null;
    } else if (data is List) {
      // Flatten grouped payloads:
      // 1) [{id, name, materials: [...]}]
      // 2) [{level, categories: [{id, name, materials: [...]}]}]
      results = data.whereType<Map>().expand((group) {
        final directMaterials = group['materials'];
        if (directMaterials is List) {
          return directMaterials;
        }

        final categories = group['categories'];
        if (categories is List) {
          return categories.whereType<Map>().expand(
            (cat) => (cat['materials'] as List?) ?? const [],
          );
        }

        return const [];
      }).toList();
      hasMore = false;
    } else {
      results = const [];
      hasMore = false;
    }

    return (
      materials: results.map((e) => MaterialModel.fromJson(e)).toList(),
      hasMore: hasMore,
    );
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final res = await dio.get('/api/v1/materials/categories/');
    final List data = res.data['data']['results'];
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }
}
