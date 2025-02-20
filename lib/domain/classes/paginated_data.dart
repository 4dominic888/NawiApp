class PaginatedData<T> {

  final ({int currentPage, int currentCount, int pageSize}) metadata;
  final List<T> data;

  PaginatedData._({required this.metadata, required this.data});

  /// ``[currentPage]`` Actual page
  /// 
  /// ``[currentCount]`` Amount of elements loaded
  /// 
  /// ``[pageSize]`` Number of elementos per page
  ///  
  /// ``[data]`` Data
  PaginatedData.build({
    required int currentPage,
    required int currentCount,
    required int pageSize,
    required List<T> data
  }) : this._(metadata: (
    currentPage: currentPage,
    currentCount: currentPage,
    pageSize: pageSize
  ), data: data);
}