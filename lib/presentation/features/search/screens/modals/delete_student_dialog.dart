import 'package:flutter/material.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/records/button_controller_with_process.dart' as loadingbutton;
import 'package:nawiapp/presentation/widgets/loading_process_button.dart';
import 'package:nawiapp/presentation/widgets/warning_awesome_dialog.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class DeleteElementAwesomeDialog extends WarningAwesomeDialog {

  final bool isArchived;
  final RoundedLoadingButtonController leftButtonController;
  final RoundedLoadingButtonController rightButtonController;
  final String aboutDescription;

  final Future<Result> Function() deleteAction;
  final Future<Result> Function() archieveAction;
  final Future<Result> Function() unarchieveAction;
  final Future<void> Function()? onActionSelected;

  @override
  String? get title => "Confirmación de eliminación";

  @override
  String? get desc => "$aboutDescription"
              "\n\nCaso contrario, ${!isArchived ? "¿Archivarlo?" : "¿Desarchivarlo?"}";

  @override
  Widget? get btnOk => LoadingProcessButton(
    controller: rightButtonController,
    proccess: loadingbutton.defaulVoidResultAction(
      buttonController: rightButtonController,
      result: (() => deleteAction.call()),
      onAction: onActionSelected
    ).action,
    label: Text("Eliminar", style: TextStyle(color: Colors.white)),
    color: Colors.redAccent.shade200
  );

  @override
  Widget? get btnCancel => !isArchived ? 
    LoadingProcessButton(
      controller: leftButtonController,
      proccess: loadingbutton.defaulVoidResultAction(
        buttonController: leftButtonController,
        result: (() => archieveAction.call()),
        onAction: onActionSelected
      ).action,
      label: Text("Archivar", style: TextStyle(color: Colors.white)),
      color: Colors.orangeAccent.shade200
    ) :
    LoadingProcessButton(
      controller: leftButtonController,
      proccess: loadingbutton.defaulVoidResultAction(
        buttonController: leftButtonController,
        result: (() => unarchieveAction.call()),
        onAction: onActionSelected
      ).action,
      label: const Text("Desarchivar", style: TextStyle(color: Colors.white)),
      color: Colors.green.shade200,
    );

  DeleteElementAwesomeDialog({
    required super.context,
    this.isArchived = false,
    required this.deleteAction,
    required this.archieveAction,
    required this.unarchieveAction,
    required this.aboutDescription,
    this.onActionSelected,
    super.title,
    super.desc,
    super.btnOk,
    super.btnCancel,
  }) : 
  leftButtonController = RoundedLoadingButtonController(),
   rightButtonController = RoundedLoadingButtonController();
  

}