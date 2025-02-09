import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:nawiapp/presentation/registration_book/view_registers_book/screens/view_registers_book_screen.dart';
import 'package:nawiapp/presentation/students/view_students/screens/view_students_screen.dart';

void main() {
  //* Originalmente llamado Ñawi, pero para evitar futuros errores con caracteres especiales, se reemplaza la Ñ por N.
  runApp(const NawiApp());
}

class NawiApp extends StatelessWidget {
  const NawiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu principal',
      debugShowCheckedModeBanner: false,
      home: const MenuApp(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 178, 134, 254)),
        useMaterial3: true,
      ),
    );
  }
}

class MenuApp extends StatelessWidget {
  const MenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ñawi Menu", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Estudiantes", icon: Icon(Icons.group)),
              Tab(text: "Registros", icon: Icon(Icons.assignment_ind))
            ]
          ),
        ),
        body: TabBarView(
          children: [
            ViewStudentsScreen(),
            ViewRegistersBookScreen()
          ]
        ),
        floatingActionButton: AnimatedFloatingActionButton(
          fabButtons: [
            //* Create
            FloatingActionButton(
              onPressed: () {},
              
              heroTag: "Create",
              tooltip: "Crear nuevo elemento",
              child: const Icon(Icons.add),
            ),

            //* Filter
            FloatingActionButton(
              onPressed: () {},
              heroTag: "Filter",
              tooltip: "Filtrar elementos",
              child: const Icon(Icons.sort),
            )
          ],
          animatedIconData: AnimatedIcons.list_view,
          tooltip: "Más opciones",
          colorStartAnimation: Theme.of(context).colorScheme.inversePrimary,
          colorEndAnimation: Colors.purpleAccent.shade100,
          spaceBetween: -10,
        )
      ),
    );
  }
}