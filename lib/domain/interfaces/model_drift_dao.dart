import 'package:drift/drift.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/interfaces/filter_data.dart';

abstract class CountableModelDriftDAO<F extends FilterData> {
  Stream<int> getAllCount(F params);
}

abstract class AsyncCountableModelDriftDAO<F extends FilterData> {
  Future<Stream<int>> getAllCount(F params);
}

/// Esta clase abstracta fusiona todas las funciones que tiene un CRUD y más.
/// Se puede ver tambien como la abstracción general de un repositorio
///
/// ``[T]`` es la clase modelo de drift
/// 
/// ``[R]`` es similar a ``[T]`` pero con Companion al lado en su nombre
/// 
/// ``[S]`` Es la vista de la clase modelo ``[T]``
/// 
/// ``[F]`` es el filtro del modelo, externo a drift que extiende de ``[FilterData]``
abstract class ModelDriftDAO<
  T extends DataClass,
  R extends UpdateCompanion<T>,
  S extends DataClass,
  F extends FilterData
> implements 
    AddingModelDriftRepository<T,R>,
    GettingModelDriftRepository<T,S,F>,
    UpdatingModelDriftRepository<T>,
    DeletingModelDriftRepository<T>,
    ArchivingModelDriftRepository<T> {
  @override Future<Result<T?>> addOne(R data);
  @override Future<Result<Iterable<S>>> getAll(F params);
  @override Future<Result<T>> getOne(String id);
  @override Future<Result<bool>> updateOne(T data);
  @override Future<Result<T>> deleteOne(String id);
  @override Future<Result<T>> archiveOne(String id);
  @override Future<Result<T>> unarchiveOne(String id);
}

/// Esta clase abstracta fusiona todas las funciones que tiene un CRUD, sin archivar.
/// Se puede ver tambien como la abstracción general de un repositorio
///
/// ``[T]`` es la clase modelo de drift
/// 
/// ``[R]`` es similar a ``[T]`` pero con Companion al lado en su nombre
/// 
/// ``[S]`` Es la vista de la clase modelo ``[T]``
/// 
/// ``[F]`` es el filtro del modelo, externo a drift que extiende de ``[FilterData]``
abstract class ModelDriftDAOWithouArchieve<
  T extends DataClass,
  R extends UpdateCompanion<T>,
  S extends DataClass,
  F extends FilterData
> implements 
    AddingModelDriftRepository<T,R>,
    GettingModelDriftRepository<T,S,F>,
    UpdatingModelDriftRepository<T>,
    DeletingModelDriftRepository<T> {
  @override Future<Result<T?>> addOne(R data);
  @override Future<Result<Iterable<S>>> getAll(F params);
  @override Future<Result<T>> getOne(String id);
  @override Future<Result<bool>> updateOne(T data);
  @override Future<Result<T>> deleteOne(String id);
}

/// ``[T]`` es la clase modelo de drift
/// 
/// ``[R]`` es similar a ``[T]`` pero con Companion al lado en su nombre
/// 
abstract class AddingModelDriftRepository<T extends DataClass, R extends UpdateCompanion<T>> {
  Future<Result<T?>> addOne(R data);
}

/// ``[T]`` es la clase modelo de drift
/// 
/// ``[S]`` Es la vista de la clase modelo ``[T]``
/// 
/// ``[F]`` es el filtro del modelo, externo a drift que extiende de ``[FilterData]``
abstract class GettingModelDriftRepository<T extends DataClass, S extends DataClass,F extends FilterData> {
  Future<Result<Iterable<S>>> getAll(F params);
  Future<Result<T>> getOne(String id);
}

/// ``[T]`` es la clase modelo de drift
abstract class UpdatingModelDriftRepository<T extends DataClass> {
  Future<Result<bool>> updateOne(T data);
}

/// ``[T]`` es la clase modelo de drift
abstract class DeletingModelDriftRepository<T extends DataClass> {
  Future<Result<T>> deleteOne(String id);
}

/// ``[T]`` es la clase modelo de drift
abstract class ArchivingModelDriftRepository<T extends DataClass> {
  Future<Result<T>> archiveOne(String id);
  Future<Result<T>> unarchiveOne(String id);
}