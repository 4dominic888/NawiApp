import 'package:flutter/material.dart';
import 'package:nawiapp/presentation/registration_book/view_registers_book/screens/view_registers_book_screen.dart';
import 'package:nawiapp/presentation/students/view_students/screens/view_students_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ super.key });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  static Map<Tab, Widget> listOfScreens = {
    Tab(text: "Agregar", icon: const Icon(Icons.add) ) : ViewStudentsScreen(),
    Tab(text: "Buscar", icon: const Icon(Icons.search) ) : ViewRegistersBookScreen()
  };

  late TabController _tabController;
  int totalScreens = listOfScreens.length;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: listOfScreens.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: listOfScreens.length,
      child: Scaffold(
        bottomNavigationBar: Material(
          color: Theme.of(context).colorScheme.secondary,
          child: TabBar(
            controller: _tabController,
            tabs: listOfScreens.keys.toList()
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: listOfScreens.values.toList()
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