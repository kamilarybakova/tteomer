import '../../data/model/category_model.dart';
import '../../data/model/material_model.dart';

sealed class MaterialsState {}

class MaterialsInitial extends MaterialsState {}

class MaterialsLoading extends MaterialsState {}

class MaterialsLoaded extends MaterialsState {
  final List<MaterialModel> materials;
  final List<CategoryModel> categories;

  MaterialsLoaded(this.materials, this.categories);
}

class MaterialsError extends MaterialsState {
  final String message;
  MaterialsError(this.message);
}
