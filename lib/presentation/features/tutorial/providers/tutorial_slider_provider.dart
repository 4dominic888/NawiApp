import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/credential_data.dart';
import 'package:nawiapp/infrastructure/secure_credential_manager.dart';

class TutorialSliderState {
  final int currentPage;
  final int totalPages;
  final PageController pageController;
  final String authCode;
  final String verifyAuthCode;
  final bool isUsingDni;
  final bool isCodeAuthValid;
  final bool loading;

  TutorialSliderState({
    required this.currentPage,
    required this.totalPages,
    required this.pageController,
    required this.authCode,
    required this.verifyAuthCode,
    this.isUsingDni = false,
    this.isCodeAuthValid = false,
    this.loading = false,
  });

  TutorialSliderState copyWith({
    int? currentPage,
    int? totalPages,
    PageController? pageController,
    String? authCode,
    String? verifyAuthCode,
    bool? isUsingDni,
    String? pinErrorText,
    bool? isCodeAuthValid,
    bool? loading
  }) {
    return TutorialSliderState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      pageController: pageController ?? this.pageController,
      verifyAuthCode: verifyAuthCode ?? this.verifyAuthCode,
      authCode: authCode ?? this.authCode,
      isUsingDni: isUsingDni ?? this.isUsingDni,
      isCodeAuthValid: isCodeAuthValid ?? this.isCodeAuthValid,
      loading: loading ?? this.loading,
    );
  }
}

class TutorialSliderNotifier extends StateNotifier<TutorialSliderState> {
  TutorialSliderNotifier() : super(TutorialSliderState(
    currentPage: 0,
    totalPages: 4,
    pageController: PageController(),
    authCode: '',
    verifyAuthCode: ''
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

  Future<void> saveAndContinue() async {
    setLoading(true);
    final credentialManager = GetIt.I<SecureCredentialManager>();

    await credentialManager.setCredential(
      CredentialData(
        authCode: state.authCode,
        mode: state.isUsingDni ? CredentialDataType.dni : CredentialDataType.pin
      )
    );
    setLoading(false);
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

  void setCodeAuth(String? text) => state = state.copyWith(authCode: text);
  void setVerifyCodeAuth(String? text) => state = state.copyWith(verifyAuthCode: text);
  void setLoading(bool value) => state = state.copyWith(loading: value);

  String? get codeAuthErrorText {
    final text = state.authCode.trim();
    if(text.isEmpty) return null;
    final expectedLength = state.isUsingDni ? 8 : 4;
    if(text.length < expectedLength) return 'La longitud debe ser igual a $expectedLength';
    return null;
  }

  String? get verifyCodeAuthErrorText {
    final text = state.verifyAuthCode.trim();
    if(text.isEmpty) return null;
    if(text != state.authCode) return 'Las claves deben ser iguales';
    return null;
  }

  void onPageChanged(int index) => state = state.copyWith(currentPage: index);

  void useDni(bool? value) {
    state = state.copyWith(
      isUsingDni: value ?? false,
      pinErrorText: ''
    );
    state = state.copyWith(authCode: '');
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