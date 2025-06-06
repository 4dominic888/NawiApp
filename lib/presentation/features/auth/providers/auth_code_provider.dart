import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/credential_data.dart';
import 'package:nawiapp/infrastructure/secure_credential_manager.dart';

class AuthCodeState {
  final bool isDni;
  final List<String> code;
  final bool isLoading;
  final String resultMesssage;
  int get maxLength => isDni ? 8 : 4;

  AuthCodeState({
    this.isDni = false,
    this.isLoading = false,
    required this.code,
    required this.resultMesssage
  });

  AuthCodeState copyWith({
    bool? isDni,
    List<String>? code,
    bool? isLoading,
    String? resultMesssage,
  }) {
    return AuthCodeState(
      isDni: isDni ?? this.isDni,
      isLoading: isLoading ?? this.isLoading,
      code: code ?? this.code,
      resultMesssage: resultMesssage ?? this.resultMesssage
    );
  }
}

class AuthCodeNotifier extends StateNotifier<AuthCodeState> {
  AuthCodeNotifier() : super(
    AuthCodeState(
      code: [],
      resultMesssage: ''
    )
  );

  void onNumberPressed(int number) {
    if (state.code.length < state.maxLength) {
      state = state.copyWith(
        code: [...state.code, number.toString()]
      );
    }
  }

  void onBackspace() {
    if (state.code.isNotEmpty) {
      state = state.copyWith(
        code: List<String>.from(state.code)..removeLast()
      );
    }
  }

  Future<bool> _verifyPin(String code) async {
    final bool validate = await GetIt.I<SecureCredentialManager>().validCredential(
      CredentialData(authCode: code)
    );

    return validate;
  }

  Future<void> onSubmit({void Function()? onValid}) async {
    if (state.code.length != state.maxLength) return;

    state = state.copyWith(isLoading: true, resultMesssage: '');

    final isValid = await _verifyPin(state.code.join());

    state = state.copyWith(
      isLoading: false,
      resultMesssage: isValid ? "Ingresando..." : "PIN incorrecto",
      code: []
    );

    if(isValid) onValid?.call();
  }

  void changeMode(bool? value) {
    state = state.copyWith(
      isDni: value!,
      code: [],
      resultMesssage: ''
    );
  }

}

final authCodeProvider = StateNotifierProvider<AuthCodeNotifier, AuthCodeState>(
  (ref) => AuthCodeNotifier()
);