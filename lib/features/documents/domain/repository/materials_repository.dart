import '../../data/model/category_model.dart';
import '../../data/model/material_model.dart';

abstract class MaterialsRepository {
  Future<({List<MaterialModel> materials, bool hasMore})> getMaterials({
    String? level,
    String? categoryId,
    int page = 1,
    int pageSize = 10,
  });

  Future<List<CategoryModel>> getCategories();
}
