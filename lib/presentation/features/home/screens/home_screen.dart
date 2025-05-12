import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:nawiapp/presentation/features/backups/screens/backups_screen.dart';
import 'package:nawiapp/presentation/features/create/screens/create_element_screen.dart';
import 'package:nawiapp/presentation/features/export/providers/initial_pdf_bytes_data_provider.dart';
import 'package:nawiapp/presentation/features/export/screens/export_screen.dart';
import 'package:nawiapp/presentation/features/home/extra/menu_tabs.dart';
import 'package:nawiapp/presentation/features/home/providers/tab_index_provider.dart';
import 'package:nawiapp/presentation/features/search/screens/search_element_screen.dart';
import 'package:nawiapp/presentation/features/home/providers/general_loading_provider.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({ super.key });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {

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
  
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: NawiMenuTabs.values.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tabMenuProvider, (prev, next) {
      _tabController.animateTo(next.index);

      //* Limpiar datos del exportado del PDF de forma eficiente
      if(prev != null && prev == NawiMenuTabs.export) {
        ref.read(initialPdfBytesDataProvider.notifier).state = null;
      }
    });

    final reactiveMenuTab = ref.watch(tabMenuProvider);

    return LoadingOverlay(
      color: Colors.black.withAlpha(120),
      isLoading: ref.watch(generalLoadingProvider),
      child: DefaultTabController(
        length: NawiMenuTabs.values.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Ñawi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            centerTitle: true,
          ),
          resizeToAvoidBottomInset: false,
          bottomSheet: BottomNavigationBar(
            currentIndex: reactiveMenuTab.index,
            onTap: ref.read(tabMenuProvider.notifier).onIndexChanged,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            selectedItemColor: NawiColorUtils.primaryColor,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: NawiMenuTabs.values.map( (e) => _getMenu(e).keys.first ).toList(),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: NawiMenuTabs.values.map( (e) => _getMenu(e).values.first ).toList(),
          )
        ),
      ),
    );
  }
}