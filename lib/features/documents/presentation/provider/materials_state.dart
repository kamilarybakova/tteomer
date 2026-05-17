sealed class MaterialsState {}

class MaterialsInitial extends MaterialsState {}
class MaterialsLoading extends MaterialsState {}
class MaterialsError extends MaterialsState {
  final String message;
  MaterialsError(this.message);
}

class MaterialsLoaded extends MaterialsState {
  final List materials;
  final List categories;
  final bool hasMore;
  final int currentPage;
  final bool isLoading;

  MaterialsLoaded(
      this.materials,
      this.categories, {
        this.hasMore = false,
        this.currentPage = 1,
        this.isLoading = false,
      });

  MaterialsLoaded copyWith({
    List? materials,
    List? categories,
    bool? hasMore,
    int? currentPage,
    bool? isLoading,
  }) => MaterialsLoaded(
    materials ?? this.materials,
    categories ?? this.categories,
    hasMore: hasMore ?? this.hasMore,
    currentPage: currentPage ?? this.currentPage,
    isLoading: isLoading ?? this.isLoading,
  );
}