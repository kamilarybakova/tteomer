import '../../domain/repository/materials_repository.dart';
import '../datasource/materials_remote_datasource.dart';
import '../model/category_model.dart';
import '../model/material_model.dart';

class MaterialsRepositoryImpl implements MaterialsRepository {
  final MaterialsRemoteDataSource remote;

  MaterialsRepositoryImpl(this.remote);

  @override
  Future<List<MaterialModel>> getMaterials({
    String? level,
    int? categoryId,
  }) {
    return remote.getMaterials(level: level, categoryId: categoryId);
  }

  @override
  Future<List<CategoryModel>> getCategories() {
    return remote.getCategories();
  }
}
