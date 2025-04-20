import 'package:flutter/material.dart';
import 'package:nawiapp/presentation/features/backups/screens/backups_screen.dart';
import 'package:nawiapp/presentation/features/create/screens/create_element_screen.dart';
import 'package:nawiapp/presentation/features/export/screens/export_screen.dart';
import 'package:nawiapp/presentation/features/search/screens/search_element_screen.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ super.key });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  static Map<BottomNavigationBarItem, Widget> listOfScreens = {
    BottomNavigationBarItem(label: "Agregar", icon: const Icon(Icons.add) ) : CreateElementScreen(),
    BottomNavigationBarItem(label: "Buscar", icon: const Icon(Icons.search) ) : SearchElementScreen(),
    BottomNavigationBarItem(label: "Exportar", icon: const Icon(Icons.download) ) : ExportScreen(),
    BottomNavigationBarItem(label: "Backups", icon: const Icon(Icons.language) ) : BackupsScreen(),
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
        appBar: AppBar(
          title: const Text("Ñawi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        bottomSheet: BottomNavigationBar(
          currentIndex: _tabController.index,
          onTap: (value) => setState(() => _tabController.index = value),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          selectedItemColor: NawiColorUtils.primaryColor,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: listOfScreens.keys.toList(),
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