import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/infrastructure/in_memory_storage.dart';
import 'package:nawiapp/presentation/features/backups/screens/backups_screen.dart';
import 'package:nawiapp/presentation/features/create/providers/register_book/initial_register_book_form_data_provider.dart';
import 'package:nawiapp/presentation/features/create/providers/selectable_element_for_create_provider.dart';
import 'package:nawiapp/presentation/features/create/providers/student/initial_student_form_data_provider.dart';
import 'package:nawiapp/presentation/features/create/screens/create_element_screen.dart';
import 'package:nawiapp/presentation/features/export/providers/initial_pdf_bytes_data_provider.dart';
import 'package:nawiapp/presentation/features/export/screens/export_screen.dart';
import 'package:nawiapp/presentation/features/home/extra/menu_tabs.dart';
import 'package:nawiapp/presentation/features/home/providers/tab_index_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/register_book/search_register_book_list_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/selectable_element_for_search_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/student/search_student_list_provider.dart';
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
    _tabController = TabController(length: NawiMenuTabs.values.length, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.read(studentSummarySearchProvider.notifier).refresh();
    ref.read(registerBookSummarySearchProvider.notifier).refresh();

    final classroom = GetIt.I<InMemoryStorage>().currentClassroom!;

    ref.listen(tabMenuProvider, (prev, next) {
      _tabController.animateTo(next.index);

      if(prev != null) {
        if(prev == NawiMenuTabs.export) ref.read(initialPdfBytesDataProvider.notifier).state = null;

        if(prev == NawiMenuTabs.create) {
          ref.read(initialStudentFormDataProvider.notifier).state = null;
          ref.read(initialRegisterBookFormDataProvider.notifier).state = null;
        }
      }
    });

    final reactiveMenuTab = ref.watch(tabMenuProvider);

    return LoadingOverlay(
      color: Colors.black.withAlpha(120),
      isLoading: ref.watch(generalLoadingProvider),
      child: DefaultTabController(
        length: NawiMenuTabs.values.length,
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: ref.watch(tabMenuProvider) == NawiMenuTabs.search ? IconButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: NawiColorUtils.primaryColor,
              disabledBackgroundColor: Colors.grey,
              foregroundColor: Colors.white
            ),
            iconSize: 40,
            icon: const Icon(Icons.add),
            onPressed: () {
              ref.read(initialStudentFormDataProvider.notifier).state = null;
              ref.read(initialRegisterBookFormDataProvider.notifier).state = null;

              Type element;
              if(ref.read(selectableElementForSearchProvider) == Student) {
                element = Student;
              }
              else {
                element = RegisterBook;
              }
              ref.read(selectableElementForCreateProvider.notifier).state = element;
              ref.read(tabMenuProvider.notifier).goTo(NawiMenuTabs.create);
            },
          ) : const SizedBox.shrink(),
          appBar: AppBar(
            title: Text("Ñawi, ${classroom.name}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
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