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
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Aca irá algun widget de control'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'None',
        child: const Icon(Icons.add),
      ),
    );
  }
}