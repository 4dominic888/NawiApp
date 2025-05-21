import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';
import 'package:nawiapp/presentation/features/search/widgets/search_filter_field.dart';
import 'package:nawiapp/presentation/features/select_classroom/providers/select_classroom_grid_provider.dart';
import 'package:nawiapp/presentation/features/select_classroom/screens/add_classroom_modal.dart';
import 'package:nawiapp/presentation/features/select_classroom/widgets/classroom_element.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class SelectClassroomScreen extends ConsumerStatefulWidget {
  const SelectClassroomScreen({ super.key });

  @override
  ConsumerState<SelectClassroomScreen> createState() => _SelectClassroomScreenState();
}

class _SelectClassroomScreenState extends ConsumerState<SelectClassroomScreen> {

  Timer? debounce;

  @override
  Widget build(BuildContext context) {
    final searchNotifier = ref.read(classroomSearchProvider.notifier);
    final controller = searchNotifier.pagingController;
    final filterNotifier = ref.read(classroomFilterProvider.notifier);

    return Scaffold(
      floatingActionButton: IconButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: NawiColorUtils.primaryColor,
          foregroundColor: Colors.white
        ),
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            DialogRoute(context: context, builder: (_) => AddClassroomModal())
          );
        },
      ),
      appBar: SearchFilterField(
        hintTextField: 'Búsqueda por nombre...',
        filterAction: () async {

        },
        textOnChanged: (text) {
          debounce?.cancel();
          debounce = Timer(const Duration(milliseconds: 500), () {
            final newFilter = filterNotifier.state.copyWith(nameLike: text);
    
            if(filterNotifier.state != newFilter) {
              filterNotifier.state = newFilter;
              searchNotifier.refresh();
            }
          });
        },
      ),
      body: RefreshIndicator(
        onRefresh: searchNotifier.refresh,
        child: PagedListView(
          pagingController: controller,
          builderDelegate: PagedChildBuilderDelegate<Classroom>(
            itemBuilder: (_, item, __) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClassroomElement(item: item),
            ),
            firstPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
            newPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
            noItemsFoundIndicatorBuilder: (_) => const Center(child: Text("No hay aulas registradas, registre una ahora")),
            firstPageErrorIndicatorBuilder: (_) => const Center(child: Text("Ha ocurrido un error al cargar la información")),
            newPageErrorIndicatorBuilder: (_) => const Center(child: Text("Ha ocurrido un error al cargar la información"))
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }
}