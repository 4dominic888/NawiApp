import 'package:nawiapp/presentation/widgets/notification_message.dart';

enum NawiErrorOrigin{
  repository,
  service,
  presentation,
  other
}

interface class NawiError<T> extends Result<T> implements Exception {
  final NawiErrorOrigin origin;
  final StackTrace? stackTrace;

  NawiError({required super.message, required this.origin, this.stackTrace});

  NawiError.onRepository({required String message, StackTrace? stackTrace}) : 
    this(message: message, stackTrace: stackTrace, origin: NawiErrorOrigin.repository);

  NawiError.onService({required String message, StackTrace? stackTrace}) : 
    this(message: message, stackTrace: stackTrace, origin: NawiErrorOrigin.service);

  NawiError.onPresentation({required String message, StackTrace? stackTrace}) : 
    this(message: message, stackTrace: stackTrace, origin: NawiErrorOrigin.presentation);
    
  NawiError.onOther({required String message, StackTrace? stackTrace}) : 
    this(message: message, stackTrace: stackTrace, origin: NawiErrorOrigin.other);

  @override
  String toString() => message;
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
    void Function(NawiError error, String message)? onError,
    bool withPopup = true
    }) {

    if(this is Success<T>) {
      if(withPopup) NotificationMessage.showSuccessNotification(message);
      onSuccessfully?.call((this as Success<T>).data, message);
    }
    else {
      if(withPopup) NotificationMessage.showSuccessNotification(message);
      onError?.call(this as NawiError, message);
    }
  }

  Result({required this.message});
}