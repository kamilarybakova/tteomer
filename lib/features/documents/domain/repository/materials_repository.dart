import '../../data/model/category_model.dart';
import '../../data/model/material_model.dart';

abstract class MaterialsRepository {
  Future<List<MaterialModel>> getMaterials({
    String? level,
    int? categoryId,
  });

  Future<List<CategoryModel>> getCategories();
}
