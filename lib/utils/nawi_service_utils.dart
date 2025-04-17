import 'package:nawiapp/domain/classes/result.dart';

/// Utilidades para la capa de servicio
class NawiServiceUtils{  
  
  /// [NawiError] por defecto en bloques try catch
  static NawiError<T> onCatch<T>(Object e) {
    if(e is NawiError<T>) return e;
    return NawiError.onService(message: e.toString());
  }
}
