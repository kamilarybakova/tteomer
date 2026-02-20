import '../../data/model/material_model.dart';
import '../repository/materials_repository.dart';

class GetMaterialsUseCase {
  final MaterialsRepository repo;

  GetMaterialsUseCase(this.repo);

  Future<List<MaterialModel>> call({
    String? level,
    int? categoryId,
  }) {
    return repo.getMaterials(level: level, categoryId: categoryId);
  }
}
