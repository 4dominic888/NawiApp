import 'package:flutter/material.dart';
import 'package:nawiapp/presentation/shared/floating_icons.dart';

class ContentBackground extends StatelessWidget {

  final Color backgroundColor;
  final Widget child;

  const ContentBackground({ super.key, required this.backgroundColor, required this.child });

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(backgroundColor);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hsl.withLightness((hsl.lightness + 0.5).clamp(0, 1)).toColor(),
                hsl.withLightness((hsl.lightness + 0.3).clamp(0, 1)).toColor(),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          ),
        ),

        ...FloatingIcons.build(context),

        child
      ],
    );
  }
}