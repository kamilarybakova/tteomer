import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecase/get_categories_usecase.dart';
import '../../domain/usecase/get_materials_usecase.dart';
import 'materials_state.dart';

class MaterialsNotifier extends StateNotifier<MaterialsState> {
  final GetMaterialsUseCase getMaterials;
  final GetCategoriesUseCase getCategories;

  static const _pageSize = 10;

  MaterialsNotifier({
    required this.getMaterials,
    required this.getCategories,
  }) : super(MaterialsInitial());

  Future<void> load({
    String? level,
    int? categoryId,
    bool reset = true,
  }) async {
    final current = state;
    final page = reset ? 1 : (current is MaterialsLoaded ? current.currentPage + 1 : 1);

    if (!reset && current is MaterialsLoaded && !current.hasMore) return;
    if (!reset && current is MaterialsLoaded && current.isLoading) return;

    try {
      if (reset) {
        state = MaterialsLoading();

        final result = await getMaterials(level: level, categoryId: categoryId, page: 1, pageSize: _pageSize);
        final categories = await getCategories();

        state = MaterialsLoaded(
          result.materials,
          categories,
          hasMore: result.hasMore,
          currentPage: 1,
          isLoading: false,
        );
      } else if (current is MaterialsLoaded) {
        state = current.copyWith(isLoading: true);
        final result = await getMaterials(level: level, categoryId: categoryId, page: page, pageSize: _pageSize);
        state = current.copyWith(
          materials: [...current.materials, ...result.materials],
          hasMore: result.hasMore,
          currentPage: page,
          isLoading: false,
        );
      }
    } catch (e) {
      state = MaterialsError(e.toString());
    }
  }
}
