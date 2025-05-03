import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/home/extra/menu_tabs.dart';

class TabMenuNotifier extends StateNotifier<NawiMenuTabs> {

  TabMenuNotifier() : super(NawiMenuTabs.create);

  void onIndexChanged(int index) => state = NawiMenuTabs.values[index];

  void goTo(NawiMenuTabs tab) => state = tab;

}

final tabMenuProvider = StateNotifierProvider<TabMenuNotifier, NawiMenuTabs>(
  (ref) => TabMenuNotifier()
);