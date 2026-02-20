import '../../data/model/category_model.dart';
import '../repository/materials_repository.dart';

class GetCategoriesUseCase {
  final MaterialsRepository repo;

  GetCategoriesUseCase(this.repo);

  Future<List<CategoryModel>> call() {
    return repo.getCategories();
  }
}
