class PaginatedData<T> {
  final ({int currentPage, int pageSize}) metadata;
  final Iterable<T> data;

  /// ``[currentPage]`` Página actual
  /// 
  /// ``[pageSize]`` Número de elementos por página
  ///  
  /// ``[data]`` La data
  PaginatedData.build({
    required int currentPage,
    required int pageSize,
    required Iterable<T> data
  }) : this._(metadata: (
    currentPage: currentPage,
    pageSize: pageSize
  ), data: data);

  PaginatedData._({required this.metadata, required this.data});
}