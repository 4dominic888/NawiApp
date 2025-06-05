import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TutorialSliderState {
  final int currentPage;
  final int totalPages;
  final PageController pageController;
  final String codeAuth;
  final bool isUsingDni;
  final bool isCodeAuthValid;
  final bool loading;

  TutorialSliderState({
    required this.currentPage,
    required this.totalPages,
    required this.pageController,
    required this.codeAuth,
    this.isUsingDni = false,
    this.isCodeAuthValid = false,
    this.loading = false
  });

  TutorialSliderState copyWith({
    int? currentPage,
    int? totalPages,
    PageController? pageController,
    String? codeAuth,
    bool? isUsingDni,
    String? pinErrorText,
    bool? isCodeAuthValid,
    bool? loading
  }) {
    return TutorialSliderState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      pageController: pageController ?? this.pageController,
      codeAuth: codeAuth ?? this.codeAuth,
      isUsingDni: isUsingDni ?? this.isUsingDni,
      isCodeAuthValid: isCodeAuthValid ?? this.isCodeAuthValid,
      loading: loading ?? this.loading
    );
  }
}

class TutorialSliderNotifier extends StateNotifier<TutorialSliderState> {
  TutorialSliderNotifier() : super(TutorialSliderState(
    currentPage: 0,
    totalPages: 4,
    pageController: PageController(),
    codeAuth: ''
  ));

  bool get isLastPage => state.currentPage == 3;
  bool get isFirstPage => state.currentPage == 0;

  void nextPage({void Function()? onComplete}) {
    if (!isLastPage) {
      state.pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      onPageChanged(state.currentPage + 1);
    } else {
      onComplete?.call();
    }
  }

  void previousPage() {
    state.pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
    onPageChanged(state.currentPage - 1);
  }

  void dotNavigation(int index) {
    onPageChanged(index);
    state.pageController.jumpToPage(index);
  }

  void skip() {
    onPageChanged(3);
    state.pageController.jumpToPage(3);
  }

  void setCodeAuth(String? text) => state = state.copyWith(codeAuth: text);
  void setLoading(bool value) => state = state.copyWith(loading: value);

  String? get codeAuthErrorText {
    final text = state.codeAuth.trim();
    if(text.isEmpty) return null;
    final expectedLength = state.isUsingDni ? 8 : 4;
    if(text.length < expectedLength) return 'La longitud debe ser igual a $expectedLength';
    return null;
  }

  // bool get isValidatePin => state.codeAuth.isNotEmpty;

  void onPageChanged(int index) => state = state.copyWith(currentPage: index);

  void useDni(bool? value) {
    state = state.copyWith(
      isUsingDni: value ?? false,
      pinErrorText: ''
    );
    state = state.copyWith(codeAuth: '');
  }

  @override
  void dispose() {
    state.pageController.dispose();
    super.dispose();
  }
}

final tutorialSliderProvider = StateNotifierProvider<TutorialSliderNotifier, TutorialSliderState>(
  (ref) => TutorialSliderNotifier()
);