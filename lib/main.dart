import 'package:flutter/material.dart';

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
            Center(child: const Text("Vista de estudiantes")),
            Center(child: const Text("Vista de registros"))
          ]
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'None',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}