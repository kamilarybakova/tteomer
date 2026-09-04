import '../../domain/repository/materials_repository.dart';
import '../datasource/materials_remote_datasource.dart';
import '../model/category_model.dart';
import '../model/material_model.dart';

class MaterialsRepositoryImpl implements MaterialsRepository {
  final MaterialsRemoteDataSource remote;
  MaterialsRepositoryImpl(this.remote);

  @override
  Future<({List<MaterialModel> materials, bool hasMore})> getMaterials({
    String? level,
    String? categoryId,
    int page = 1,
    int pageSize = 10,
  }) {
    return remote.getMaterials(
      level: level,
      categoryId: categoryId,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<List<CategoryModel>> getCategories() => remote.getCategories();
}
