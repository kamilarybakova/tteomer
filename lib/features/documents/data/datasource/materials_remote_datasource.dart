import 'package:dio/dio.dart';

import '../model/category_model.dart';
import '../model/material_model.dart';

abstract class MaterialsRemoteDataSource {
  Future<List<MaterialModel>> getMaterials({
    String? level,
    int? categoryId,
    int page = 1,
  });

  Future<List<CategoryModel>> getCategories();
}

class MaterialsRemoteDataSourceImpl implements MaterialsRemoteDataSource {
  final Dio dio;

  MaterialsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<MaterialModel>> getMaterials({
    String? level,
    int? categoryId,
    int page = 1,
  }) async {
    final res = await dio.get(
      '/api/v1/materials/',
      queryParameters: {
        if (level != null) 'level': level,
        if (categoryId != null) 'category': categoryId,
        'page': page,
      },
    );

    final List data = res.data['data']['results'];
    return data.map((e) => MaterialModel.fromJson(e)).toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final res = await dio.get('/api/v1/materials/categories/');
    final List data = res.data['data']['results'];
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }
}

