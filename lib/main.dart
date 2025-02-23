import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:nawiapp/locator.dart';
import 'package:nawiapp/presentation/registration_book/add_registers_book/screens/add_register_book_screen.dart';
import 'package:nawiapp/presentation/registration_book/view_registers_book/screens/view_registers_book_screen.dart';
import 'package:nawiapp/presentation/students/add_students/screens/add_students_screen.dart';
import 'package:nawiapp/presentation/students/view_students/screens/view_students_filter_modal.dart';
import 'package:nawiapp/presentation/students/view_students/screens/view_students_screen.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

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

class MenuApp extends StatefulWidget {
  const MenuApp({super.key});

  @override
  State<MenuApp> createState() => _MenuAppState();
}

class _MenuAppState extends State<MenuApp> with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if(_tabController.indexIsChanging == false) setState(() => _currentIndex = _tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ñawi Menu", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Estudiantes", icon: Icon(Icons.group)),
              Tab(text: "Registros", icon: Icon(Icons.assignment_ind))
            ]
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ViewStudentsScreen(),
            ViewRegistersBookScreen()
          ]
        ),
        floatingActionButton: AnimatedFloatingActionButton(
          fabButtons: [
            //TODO Cambiar los null por las pantallas que correspondan al siguiente modulo
            //* Create
            FloatingActionButton(
              onPressed: () => _currentIndex == 0 ?
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddStudentsScreen())) :
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddRegisterBookScreen())),
              heroTag: "Create",
              tooltip: "Crear nuevo elemento",
              child: const Icon(Icons.add),
            ),

            //* Filter
            FloatingActionButton(
              onPressed: () => _currentIndex == 0 ?
                showDialog(context: context, builder: (_) => ViewStudentsFilterModal()) :
                null,
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}