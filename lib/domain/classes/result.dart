enum ErrorOrigin{
  repository,
  service,
  presentation,
  other
}

interface class Error<T> extends Result<T> {
  final ErrorOrigin origin;
  final StackTrace? stackTrace;

  Error._({required super.message, required this.origin, this.stackTrace});

  Error.onRepository({required String message, StackTrace? stackTrace}) : 
    this._(message: message, stackTrace: stackTrace, origin: ErrorOrigin.repository);

  Error.onService({required String message, StackTrace? stackTrace}) : 
    this._(message: message, stackTrace: stackTrace, origin: ErrorOrigin.service);

  Error.onPresentation({required String message, StackTrace? stackTrace}) : 
    this._(message: message, stackTrace: stackTrace, origin: ErrorOrigin.presentation);
    
  Error.onOther({required String message, StackTrace? stackTrace}) : 
    this._(message: message, stackTrace: stackTrace, origin: ErrorOrigin.other);
}

interface class Success<T> extends Result<T> {
  final T data;

  Success({super.message = "Operación exitosa", required this.data});
}

class Result<T> {
  final String message;

  T? get getValue {
    if(this is Success<T>) return (this as Success<T>).data;
    return null;
  }

  void onValue({
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