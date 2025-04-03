class PaginatedData<T> {

  final ({int currentPage, int pageSize}) metadata;
  final Iterable<T> data;

  PaginatedData._({required this.metadata, required this.data});

  /// ``[currentPage]`` Actual page
  /// 
  /// ``[pageSize]`` Number of elementos per page
  ///  
  /// ``[data]`` Data
  PaginatedData.build({
    required int currentPage,
    required int pageSize,
    required Iterable<T> data
  }) : this._(metadata: (
    currentPage: currentPage,
    pageSize: pageSize
  ), data: data);
}