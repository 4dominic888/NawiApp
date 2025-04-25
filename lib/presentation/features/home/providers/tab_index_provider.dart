import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/home/extra/menu_tabs.dart';

class TabMenuNotifier extends StateNotifier<NawiMenuTabs> {
  late final TabController controller;

  TabMenuNotifier() : super(NawiMenuTabs.create);

  onIndexChanged(int index) => state = NawiMenuTabs.values[index];

  void goTo(NawiMenuTabs tab) => state = tab;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

final tabMenuProvider = StateNotifierProvider<TabMenuNotifier, NawiMenuTabs>(
  (ref) => TabMenuNotifier()
);