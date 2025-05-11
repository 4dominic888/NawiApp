import 'package:nawiapp/presentation/widgets/notification_message.dart';

enum NawiErrorOrigin{
  dao,
  service,
  presentation,
  other
}

/// Un [Exception], usado para operaciones con [Result]
interface class NawiError<T> extends Result<T> implements Exception {
  final NawiErrorOrigin origin;
  final StackTrace? stackTrace;

  NawiError({required super.message, required this.origin, this.stackTrace});

  NawiError.onDAO({required String message, StackTrace? stackTrace}) : 
    this(message: message, stackTrace: stackTrace, origin: NawiErrorOrigin.dao);

  NawiError.onService({required String message, StackTrace? stackTrace}) : 
    this(message: message, stackTrace: stackTrace, origin: NawiErrorOrigin.service);

  NawiError.onPresentation({required String message, StackTrace? stackTrace}) : 
    this(message: message, stackTrace: stackTrace, origin: NawiErrorOrigin.presentation);
    
  NawiError.onOther({required String message, StackTrace? stackTrace}) : 
    this(message: message, stackTrace: stackTrace, origin: NawiErrorOrigin.other);

  @override
  String toString() => message;
}

/// Para indica el éxito de una operación de tipo [Result]
interface class Success<T> extends Result<T> {
  final T data;

  Success({super.message = "Operación exitosa", required this.data});
}

/// Para aplicar el patron result al proyecto, pero con helpers
class Result<T> {

  final String message;

  /// Devuelve un [Result], con la conversión al nuevo tipo en la función [converter]
  /// 
  /// [origin] es para especificar un tipo de error en caso corresponda
  Result<E> convertTo<E>(E Function(T value) converter, {NawiErrorOrigin? origin}) {
    if(this is Success) {
      return Success<E>(data: converter(this.getValue as T), message: this.message);
    }
    final error = this as NawiError<T>;
    return NawiError<E>(message: error.message, stackTrace: error.stackTrace, origin: origin ?? (this as NawiError).origin);
  }


  /// Obtienes el valor de tipo [T], solo si la operación fue exitosa, de lo contrario obtendras un null
  T? get getValue {
    if(this is Success<T>) return (this as Success<T>).data;
    return null;
  }

  /// Obtiene un [NawiError] con el tipo, solo si la operación tuviera un error, de lo contrario, obtendras un null
  NawiError<E>? getError<E>() {
    if(this is NawiError) {
      return NawiError(message: this.message, stackTrace: (this as NawiError).stackTrace, origin: (this as NawiError).origin);
    }
    return null;
  }

  /// [onSuccessfully], coloca tu acción en caso la operación fuese exitosa
  /// 
  /// [onError], si el valor tuviera algún error
  /// 
  /// [withPopup], genera un [NotificationMessage] en tu interfaz
  void onValue({
    void Function(T data, String message)? onSuccessfully,
    void Function(NawiError error, String message)? onError,
    bool withPopup = true
    }) {

    if(this is Success<T>) {
      if(withPopup) NotificationMessage.showSuccessNotification(message);
      onSuccessfully?.call((this as Success<T>).data, message);
    }
    else {
      if(withPopup) NotificationMessage.showErrorNotification(message);
      onError?.call(this as NawiError, message);
    }
  }

  Result({required this.message});
}