import 'package:flutter/material.dart';

class ViewStudentsFilterModal extends StatefulWidget {
  const ViewStudentsFilterModal({super.key});

  @override
  State<ViewStudentsFilterModal> createState() => _ViewStudentsFilterModalState();
}

class _ViewStudentsFilterModalState extends State<ViewStudentsFilterModal> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Filtrar estudiantes"),
      scrollable: true,
      content: Form(
        child: Column(
          children: [
            TextField()
          ],
        )
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Cancelar")
        ),

        TextButton(
          onPressed: () {
            //TODO: Recoger informacion del filtrado y hacer cosas de BD
            Navigator.of(context).pop();
          },
          child: const Text("Aceptar")
        ),

      ],
    );
  }
}