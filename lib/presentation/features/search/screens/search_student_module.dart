import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/presentation/features/search/providers/general_loading_search_student_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/search_student_list_provider.dart';
import 'package:nawiapp/presentation/widgets/another_student_element.dart';
import 'package:nawiapp/presentation/features/search/screens/another_advanced_student_filter_modal.dart';
import 'package:nawiapp/presentation/features/search/widgets/search_filter_field.dart';

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

    final notifier = ref.read(studentSummarySearchProvider.notifier);
    final controller = notifier.pagingController;
    final filterNotifier = ref.read(studentFilterProvider.notifier);

    return LoadingOverlay(
      color: Colors.black.withAlpha(120),
      isLoading: ref.watch(generalLoadingSearchStudentProvider),
      child: Scaffold(
        appBar: SearchFilterField(
          hintTextField: 'Búsqueda por nombre...',
          filterAction: () async {
            final newFilter = await showDialog<StudentFilter?>(
              context: context,
              builder: (_) => AnotherAdvancedStudentFilterModal(currentFilter: filterNotifier.state));
            if(newFilter != null) {
              filterNotifier.state = newFilter;
              notifier.refresh();
            }
          },
          textOnChanged: (text) {
            debounce?.cancel();
            debounce = Timer(const Duration(milliseconds: 500), () {
              final newFilter = filterNotifier.state.copyWith(nameLike: text);
      
              if(filterNotifier.state != newFilter) {
                filterNotifier.state = newFilter;
                notifier.refresh();
              }
            });
          },
        ),
        body: RefreshIndicator(
          onRefresh: notifier.refresh,
          child: PagedListView(
            pagingController: controller,
            builderDelegate: PagedChildBuilderDelegate<StudentSummary>(
              itemBuilder: (_, item, __) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnotherStudentElement(item: item),
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