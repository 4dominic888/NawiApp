import 'dart:ui';

import 'package:nawiapp/presentation/shared/submit_status.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class NawiFormUtils {

  /// Función para hacer X acción en base a [status].
  /// 
  /// Combina las funcionalidades de [RoundedLoadingButtonController] en ella, por lo que es práctico
  static void handleSubmitStatus({
    required SubmitStatus status,
    required RoundedLoadingButtonController controller,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) {
    switch (status) {
      case SubmitStatus.loading:
        controller.start();
        break;
      case SubmitStatus.success:
        controller.success();
        onSuccess?.call();
        break;
      case SubmitStatus.error:
        controller.error();
        onError?.call();
        break;
      case SubmitStatus.idle:
        controller.reset();
        break;
    }
  }
}