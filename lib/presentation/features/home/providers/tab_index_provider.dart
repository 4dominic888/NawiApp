import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/home/extra/menu_tabs.dart';

class TabIndexNotifier extends StateNotifier<NawiMenuTabs> {
  final TabController tabController;
  final Ref ref;

  TabIndexNotifier({required this.tabController, required this.ref}) : super(NawiMenuTabs.create);

  void initState() {
    tabController.addListener(() {
      if(tabController.indexIsChanging) {
        state = NawiMenuTabs.values[tabController.index];
      }
    });
  }

  void goCreate() => state = NawiMenuTabs.create;
  void goSearch() => state = NawiMenuTabs.search;
  void goExports() => state = NawiMenuTabs.export;
  void goBackups() => state = NawiMenuTabs.backups;
}

final tabIndexProvider = StateNotifierProvider<TabIndexNotifier, NawiMenuTabs>(
  (ref) => TabIndexNotifier(tabController: ref.read(tabControllerProvider)!, ref: ref)
);

final tabControllerProvider = StateProvider<TabController?>((ref) => null);