import 'package:nawiapp/domain/classes/result.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

/// Tipo creado para poder almacenar información de botones de tipo [RoundedLoadingButtonController] con
/// una acción de tipo [Function] con un [Future] como retorno
typedef ButtonControllerWithProcess = ({
  RoundedLoadingButtonController controller,
  Future<void> Function() action
});

/// Usa esto para cuando deseas construir obtener un [ButtonControllerWithProcess] con ningun retorno.
/// 
/// [result] te permite colocar tu accion, del cual solo te interesa saber si fue correcto o no.
/// 
/// [onAction] te permite colocar una función cuando el proceso original acabó.
ButtonControllerWithProcess defaulVoidResultAction({
  required Future<Result> Function() result,
  required RoundedLoadingButtonController buttonController,
  void Function()? onAction
}) => (
  controller: buttonController,
    action: () async {
      buttonController.start();
      final r = await result.call();
      r.onValue(
        onSuccessfully: (_, __) => buttonController.success(),
        onError: (_, __) => buttonController.error(),
        withPopup: false
      );
      onAction?.call();
    }
  );
