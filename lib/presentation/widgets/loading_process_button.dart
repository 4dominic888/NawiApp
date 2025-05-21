import 'package:flutter/material.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class LoadingProcessButton extends StatelessWidget {

  final RoundedLoadingButtonController controller;
  final Future<void> Function()? proccess;
  final Widget label;
  final Color? color;
  final double? width;
  final bool autoResetable;
  final VoidCallback? onReset;

  const LoadingProcessButton({
    super.key, required this.controller,
    required this.proccess, required this.label,
    this.color, this.width, this.onReset,
    this.autoResetable = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundedLoadingButton(
          controller: controller,
          color: color ?? NawiColorUtils.primaryColor,
          resetAfterDuration: autoResetable,
          resetDuration: const Duration(seconds: 3),
          onPressed: proccess != null ? () async => await proccess?.call() : null,
          width: width ?? 300,
          child: label
        ),

        if(!autoResetable)
        StreamBuilder<ButtonState>(
          stream: controller.stateStream,
          builder: (context, snapshot) {
            if(snapshot.data == ButtonState.error || snapshot.data == ButtonState.success){
              return TextButton(
                onPressed: () {
                  onReset?.call();
                  controller.reset();
                },
                child: 
                  const Text(
                    'Reiniciar',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      fontWeight: FontWeight.normal
                    )
                  )
                );
            } return const SizedBox.shrink();
          }
        )
      ],
    );
  }
}