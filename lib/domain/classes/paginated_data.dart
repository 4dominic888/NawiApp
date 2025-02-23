class PaginatedData<T> {

  final ({int currentPage, int pageSize}) metadata;
  final List<T> data;

  PaginatedData._({required this.metadata, required this.data});

  /// ``[currentPage]`` Actual page
  /// 
  /// ``[pageSize]`` Number of elementos per page
  ///  
  /// ``[data]`` Data
  PaginatedData.build({
    required int currentPage,
    required int pageSize,
    required List<T> data
  }) : this._(metadata: (
    currentPage: currentPage,
    pageSize: pageSize
  ), data: data);
}