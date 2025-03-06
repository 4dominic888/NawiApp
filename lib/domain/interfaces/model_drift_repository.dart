import 'package:drift/drift.dart';
import 'package:nawiapp/domain/classes/result.dart';

/// ``[T]`` es ModelTableData
/// 
/// ``[R]`` es ModelTableCompanion
/// 
/// ´´[S]`` es el ModelDAO, es de la vista creada
abstract class ModelDriftRepository<T extends DataClass, R extends UpdateCompanion<T>, S extends DataClass> {  
  Future<Result<T?>> addOne(R data);

  /// Map values:
  /// 
  /// `pageSize`: `int`, Tamaño de cada pagina
  /// 
  /// `currentPage`: `int`, Pagina actual
  /// 
  /// `nameLike`: `String`, Nombre del estudiante a aplicar búsqueda dinámica
  /// 
  /// `actionLike`: `String`, Acción del cuaderno de registro, igual que con el nombre la búsqueda
  /// 
  /// `orderByStudent`: `StudentViewOrderByType`, Enum para seleccionar el tipo de ordenamiento para estudiantes
  /// 
  /// `orderByAction`: `RegisterBookViewOrderByType`, Enum para seleccionar el tipo de ordenamiento para acciones
  /// 
  /// `ageEnumIndex1`: `int`, Filtrar segun la edad de 3, 4 o 5
  /// 
  /// `ageEnumIndex2`: `int`, Filtrar segun la edad de 3, 4 o 5, complementario al anterior
  /// 
  /// `hidden`: `bool`, True si se desea ocultar los registros ocultos, caso contrario lo muestra
  Stream<Result<List<S>>> getAll(Map<String, dynamic> params);
  Future<Result<T>> getOne(String id);
  Future<Result<bool>> updateOne(T data);
  Future<Result<T>> deleteOne(String id);
}