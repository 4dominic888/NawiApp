import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/backups/screens/backups_screen.dart';
import 'package:nawiapp/presentation/features/create/screens/create_element_screen.dart';
import 'package:nawiapp/presentation/features/export/screens/export_screen.dart';
import 'package:nawiapp/presentation/features/home/extra/menu_tabs.dart';
import 'package:nawiapp/presentation/features/home/providers/tab_index_provider.dart';
import 'package:nawiapp/presentation/features/search/screens/search_element_screen.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({ super.key });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {

  Map<BottomNavigationBarItem, Widget> _getMenu(NawiMenuTabs menuTab) {
    return switch (menuTab) {
      NawiMenuTabs.create => {
        BottomNavigationBarItem( label: "Agregar", icon: const Icon(Icons.add) ):CreateElementScreen()
      },
      NawiMenuTabs.search => {
        BottomNavigationBarItem(label: "Buscar", icon: const Icon(Icons.search) ) : SearchElementScreen()
      },
      NawiMenuTabs.export => {
        BottomNavigationBarItem(label: "Exportar", icon: const Icon(Icons.download) ) : ExportScreen(),
      },
      NawiMenuTabs.backups => {
        BottomNavigationBarItem(label: "Backups", icon: const Icon(Icons.language) ) : BackupsScreen(),
      }
    };
  }
  
  late TabIndexNotifier _tabIndexNotifier;

  @override
  void initState() {
    super.initState();

    ref.read(tabControllerProvider.notifier).state = TabController(
      length: NawiMenuTabs.values.length,
      vsync: this
    );

    _tabIndexNotifier = ref.read(tabIndexProvider.notifier);
  }

  @override
  void dispose() {
    _tabIndexNotifier.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final reactiveTab = ref.watch(tabIndexProvider);

    if(_tabIndexNotifier.tabController.index != reactiveTab.index) {
      _tabIndexNotifier.tabController.animateTo(reactiveTab.index);
    }

    return DefaultTabController(
      length: NawiMenuTabs.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ñawi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        bottomSheet: BottomNavigationBar(
          currentIndex: reactiveTab.index,
          onTap: (index) => _getMenu(NawiMenuTabs.values[index]),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          selectedItemColor: NawiColorUtils.primaryColor,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: NawiMenuTabs.values.map( (e) => _getMenu(e).keys.first ).toList(),
        ),
        body: TabBarView(
          controller: _tabIndexNotifier.tabController,
          children: NawiMenuTabs.values.map( (e) => _getMenu(e).values.first ).toList(),
        )
      ),
    );
  }
}