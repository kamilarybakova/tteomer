import '../../data/model/material_model.dart';
import '../repository/materials_repository.dart';

class GetMaterialsUseCase {
  final MaterialsRepository repo;
  GetMaterialsUseCase(this.repo);

  Future<({List<MaterialModel> materials, bool hasMore})> call({
    String? level,
    String? categoryId,
    int page = 1,
    int pageSize = 10,
  }) {
    return repo.getMaterials(
      level: level,
      categoryId: categoryId,
      page: page,
      pageSize: pageSize,
    );
  }
}
