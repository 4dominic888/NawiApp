import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/backups/screens/backups_screen.dart';
import 'package:nawiapp/presentation/features/create/screens/create_element_screen.dart';
import 'package:nawiapp/presentation/features/export/screens/export_screen.dart';
import 'package:nawiapp/presentation/features/home/providers/tab_index_provider.dart';
import 'package:nawiapp/presentation/features/search/screens/search_element_screen.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({ super.key });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {

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
    _tabController.addListener(() {
      if(!_tabController.indexIsChanging) {
        ref.read(tabIndexProvider.notifier).state = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final tabIndex = ref.watch(tabIndexProvider);

    if(_tabController.index != tabIndex) {
      _tabController.animateTo(tabIndex);
    }    

    return DefaultTabController(
      length: listOfScreens.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ñawi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        bottomSheet: BottomNavigationBar(
          currentIndex: tabIndex,
          onTap: (index) => ref.read(tabIndexProvider.notifier).state = index,
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
}