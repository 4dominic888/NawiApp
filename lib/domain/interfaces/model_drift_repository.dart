import 'package:drift/drift.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/interfaces/filter_data.dart';

/// ``[T]`` es la clase modelo de drift
/// 
/// ``[R]`` es similar a ``[T]`` pero con Companion al lado en su nombre
/// 
/// ``[S]`` Es la vista de la clase modelo ``[T]``
/// 
/// ``[F]`` es el filtro del modelo, externo a drift que extiende de ``[FilterData]``
abstract class ModelDriftRepository<
  T extends DataClass, //* Drift code generated dataset
  R extends UpdateCompanion<T>, //* Drift code generated companion
  S extends DataClass, //* Drift view
  F extends FilterData //* Filter type
>{

  Future<Result<T?>> addOne(R data);
  Future<Result<List<S>>> getAll(F params);
  Future<Result<T>> getOne(String id);
  Future<Result<bool>> updateOne(T data);
  Future<Result<T>> deleteOne(String id);
}