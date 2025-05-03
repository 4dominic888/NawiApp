import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_grouped_list/infinite_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/presentation/features/search/providers/register_book/search_register_book_list_provider.dart';
import 'package:nawiapp/presentation/widgets/another_register_book_element.dart';
import 'package:nawiapp/presentation/features/search/widgets/search_filter_field.dart';

class SearchRegisterBookModule extends ConsumerStatefulWidget {
  const SearchRegisterBookModule({
    super.key,
  });

  @override
  ConsumerState<SearchRegisterBookModule> createState() => _SearchRegisterBookModuleState();
}

class _SearchRegisterBookModuleState extends ConsumerState<SearchRegisterBookModule> {

  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final searchNotifier = ref.read(registerBookSummarySearchProvider.notifier);
    final infiniteListController = searchNotifier.controller;
    final filterNotifier = ref.read(registerBookFilterProvider.notifier);

    return Scaffold(
      appBar: SearchFilterField(
        hintTextField: 'Búsqueda por acción',
        filterAction: () {

        },
        textOnChanged: (text) {
          debounce?.cancel();
          debounce = Timer(const Duration(milliseconds: 500), () {
            final newFilter = filterNotifier.state.copyWith(actionLike: text);
    
            if(filterNotifier.state != newFilter) {
              filterNotifier.state = newFilter;
              searchNotifier.refresh();
            }
          });
        },
      ),
      body: InfiniteGroupedList(
        controller: infiniteListController,
        onLoadMore: searchNotifier.fetchPage,
        groupBy: (item) => item.createdAt,
        sortGroupBy: (item) => item.createdAt,
        groupCreator: (date) => '${date.year}-${date.month}-${date.day}',
        initialItemsErrorWidget: (error) => Text(error.toString()),
        loadingWidget: const Center(child: CircularProgressIndicator()),
        showRefreshIndicator: true,
        stickyGroups: false,
        noItemsFoundWidget: const Center(child: Text('No hay registros agregados')),
        groupTitleBuilder: (title, groupBy, isPinned, _) => Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.all(8.0),
          child: Text(DateFormat('EEEE, d MMM y').format(groupBy), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ),
        itemBuilder: (item) => AnotherRegisterBookElement(item: item, isPreview: false),
      )
    );
  }
}