import 'package:flutter/material.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class LoadingProcessButton extends StatelessWidget {

  final RoundedLoadingButtonController controller;
  final Future<void> Function() proccess;
  final Widget label;
  final Color color;
  final double? width;

  const LoadingProcessButton({
    super.key, required this.controller,
    required this.proccess, required this.label,
    required this.color, this.width
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundedLoadingButton(
          controller: controller,
          color: color,
          onPressed: () async => await proccess.call(),
          width: width ?? 300,
          child: label,
        ),

        StreamBuilder<ButtonState>(
          stream: controller.stateStream,
          builder: (context, snapshot) {
            if(snapshot.data == ButtonState.error || snapshot.data == ButtonState.success){
              return TextButton(onPressed: controller.reset, child: 
                const Text('Reiniciar', style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  fontWeight: FontWeight.normal
                )));
            } return const SizedBox.shrink();
          }
        )
      ],
    );
  }
}