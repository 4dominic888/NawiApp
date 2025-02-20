enum ErrorOrigin{
  repository,
  service,
  database,
  presentation,
  other
}

abstract class Error extends Result {
  final ErrorOrigin origin;
  final StackTrace? stackTrace;

  Error._({required super.message, required this.origin, this.stackTrace});

  Error.onRepository({required String message, StackTrace? stackTrace}) : 
    this._(message: message, stackTrace: stackTrace, origin: ErrorOrigin.repository);

  Error.onService({required String message, StackTrace? stackTrace}) : 
    this._(message: message, stackTrace: stackTrace, origin: ErrorOrigin.service);

  Error.onDatabase({required String message, StackTrace? stackTrace}) : 
    this._(message: message, stackTrace: stackTrace, origin: ErrorOrigin.database);

  Error.onPresentation({required String message, StackTrace? stackTrace}) : 
    this._(message: message, stackTrace: stackTrace, origin: ErrorOrigin.presentation);
    
  Error.onOther({required String message, StackTrace? stackTrace}) : 
    this._(message: message, stackTrace: stackTrace, origin: ErrorOrigin.other);
}

abstract class Success<T> extends Result {
  final T data;

  Success({super.message = "Operación exitosa", required this.data});
}

class Result {
  final String message;

  void getValue<T>({
    void Function(T data, String message)? onSuccessfully,
    void Function(Error error, String message)? onError
    }) {

    if(this is Success<T>) {
      onSuccessfully?.call((this as Success<T>).data, message);
    }
    else {
      onError?.call(this as Error, message);
    }
  }

  Result({required this.message});
}