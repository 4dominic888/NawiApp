import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/infrastructure/in_memory_storage.dart';
import 'package:nawiapp/presentation/features/search/providers/student/count_student_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/student/search_student_list_provider.dart';
import 'package:nawiapp/presentation/widgets/student_element.dart';
import 'package:nawiapp/presentation/features/search/screens/modals/advanced_student_filter_modal.dart';
import 'package:nawiapp/presentation/features/search/widgets/search_filter_field.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class SearchStudentModule extends ConsumerStatefulWidget {
  const SearchStudentModule({
    super.key,
  });

  @override
  ConsumerState<SearchStudentModule> createState() => _SearchStudentModuleState();
}

class _SearchStudentModuleState extends ConsumerState<SearchStudentModule> {

  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final seachNotifier = ref.read(studentSummarySearchProvider.notifier);
    final controller = seachNotifier.pagingController;
    final filterNotifier = ref.read(studentFilterProvider.notifier);
    final filterWatcher = ref.watch(studentFilterProvider);
    final studentCountNotifier = ref.watch(
      countStudentProvider((filterWatcher, GetIt.I<InMemoryStorage>().currentClassroom?.id))
    );

    return Scaffold(
      appBar: SearchFilterField(
        hintTextField: 'Búsqueda por nombre...',
        filterAction: () async {
          final newFilter = await showDialog<StudentFilter?>(
            context: context,
            builder: (_) => AdvancedStudentFilterModal(currentFilter: filterNotifier.state)
          );
          
          if(newFilter != null) {
            filterNotifier.state = newFilter;
            seachNotifier.refresh();
          }
        },
        textOnChanged: (text) {
          debounce?.cancel();
          debounce = Timer(const Duration(milliseconds: 500), () {
            final newFilter = filterNotifier.state.copyWith(nameLike: text);
    
            if(filterNotifier.state != newFilter) {
              filterNotifier.state = newFilter;
              seachNotifier.refresh();
            }
          });
        },
        extraWidget: [
          IconButton(
            style: ElevatedButton.styleFrom(backgroundColor: NawiColorUtils.secondaryColor),
            icon: const Icon(Icons.cleaning_services),
            onPressed: filterWatcher.isEmpty ? null : () {
              filterNotifier.state = StudentFilter();
              seachNotifier.refresh();
            },
          ),
          Text('${studentCountNotifier.when(
            data: (data) => data,
            error: (_, __) => '0',
            loading: () => '-'
          )} elementos')
        ]
      ),
      body: RefreshIndicator(
        onRefresh: seachNotifier.refresh,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 90),
          child: PagedListView(
            pagingController: controller,
            builderDelegate: PagedChildBuilderDelegate<StudentSummary>(
              itemBuilder: (_, item, __) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: StudentElement(item: item),
              ),
              firstPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
              newPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
              noItemsFoundIndicatorBuilder: (_) => const Center(child: Text("No hay estudiantes registrados")),
              noMoreItemsIndicatorBuilder: (_) => const Center(child: Text("No más estudiantes a cargar")),
              firstPageErrorIndicatorBuilder: (_) => const Center(child: Text("Ha ocurrido un error al cargar la información")),
              newPageErrorIndicatorBuilder: (_) => const Center(child: Text("Ha ocurrido un error al cargar la información"))            
            )
          ),
        ),
      ),
    );
  }
}