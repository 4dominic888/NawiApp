import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class WarningAwesomeDialog extends AwesomeDialog {

  @override
  DialogType get dialogType => DialogType.warning;

  @override
  bool get headerAnimationLoop => false;

  @override
  bool get showCloseIcon => true;

  @override
  Widget? get closeIcon => const Icon(Icons.close);

  @override
  AnimType get animType => AnimType.scale;

  WarningAwesomeDialog({
    required super.context,
    required super.title,
    required super.desc,
    required super.btnOk,
    required super.btnCancel
  });
}