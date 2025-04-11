/// Clase con atributos útiles para filtros avanzados
abstract class FilterData {

  /// Tamaño de cada porcion de datos seleccionados
  final int? pageSize;

  /// Cantidad de paginas recorridas en base a [pageSize]
  final int? currentPage;

  /// Para ver u ocultar los datos archivados
  ///
  /// `false` si se desea ver el listado de datos ocultando los archivados, caso contrario, `true`
  /// muestra solo los archivados
  final bool showHidden;

  bool get notShowHidden => !showHidden;

  FilterData({this.pageSize, this.currentPage, this.showHidden = false});

  Map<String, dynamic> toMap() => {
    "pageSize": pageSize,
    "currentPage": currentPage,
    "showHidden": showHidden
  };

  FilterData copyWith({
    int? pageSize, int? currentPage,
    bool? showHidden
  });
}