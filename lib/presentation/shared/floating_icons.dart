import 'package:flutter/material.dart';

class FloatingIcons {
  static List<Widget> build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Posiciones relativas a tamaño de pantalla
    final positions = [
      Positioned(
        left: size.width * 0.1,
        top: size.height * 0.2,
        child: const _IconFloat(icon: Icons.star),
      ),
      Positioned(
        left: size.width * 0.5,
        top: size.height * 0.4,
        child: const _IconFloat(icon: Icons.games),
      ),
      Positioned(
        left: size.width * 0.75,
        top: size.height * 0.55,
        child: const _IconFloat(icon: Icons.ac_unit),
      ),
      Positioned(
        left: size.width * 0.7,
        top: size.height * 0.1,
        child: const _IconFloat(icon: Icons.circle),
      ),
      Positioned(
        left: size.width * 0.03,
        top: size.height * 0.45,
        child: const _IconFloat(icon: Icons.auto_awesome),
      ),
    ];

    return positions;
  }
}

class _IconFloat extends StatelessWidget {
  final IconData icon;
  
  const _IconFloat({ required this.icon });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.05,
      child: Icon(icon,
        size: 100,
        color: Colors.black,
      ),
    );
  }
}