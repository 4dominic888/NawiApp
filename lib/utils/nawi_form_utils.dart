import 'dart:ui';

import 'package:nawiapp/presentation/shared/submit_status.dart';

class NawiFormUtils {

  static void handleSubmitStatus({
    required SubmitStatus status,
    VoidCallback? onSuccess,
    VoidCallback? onError,
    VoidCallback? onLoading,
  }) {
    switch (status) {
      case SubmitStatus.loading:
        onLoading?.call();
        break;
      case SubmitStatus.success:
        onSuccess?.call();
        break;
      case SubmitStatus.error:
        onError?.call();
        break;
      case SubmitStatus.idle: break;
    }
  }
}