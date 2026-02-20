import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecase/get_categories_usecase.dart';
import '../../domain/usecase/get_materials_usecase.dart';
import 'materials_state.dart';

class MaterialsNotifier extends StateNotifier<MaterialsState> {
  final GetMaterialsUseCase getMaterials;
  final GetCategoriesUseCase getCategories;

  MaterialsNotifier({
    required this.getMaterials,
    required this.getCategories,
  }) : super(MaterialsInitial());

  Future<void> load({String? level, int? categoryId}) async {
    try {
      state = MaterialsLoading();

      final materials = await getMaterials(
        level: level,
        categoryId: categoryId,
      );

      final categories = await getCategories();

      state = MaterialsLoaded(materials, categories);
    } catch (e) {
      state = MaterialsError(e.toString());
    }
  }
}
