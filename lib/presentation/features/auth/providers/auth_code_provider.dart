
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/credential_data.dart';
import 'package:nawiapp/infrastructure/secure_credential_manager.dart';

class AuthCodeState {
  final List<String> code;
  final bool isLoading;
  final String resultMesssage;
  final CredentialDataType? mode;

  AuthCodeState({
    this.isLoading = false,
    this.mode,
    required this.code,
    required this.resultMesssage
  });

  AuthCodeState copyWith({
    bool? isDni,
    List<String>? code,
    bool? isLoading,
    String? resultMesssage,
    CredentialDataType? mode,
  }) {
    return AuthCodeState(
      isLoading: isLoading ?? this.isLoading,
      code: code ?? this.code,
      resultMesssage: resultMesssage ?? this.resultMesssage,
      mode: mode ?? this.mode
    );
  }
}

class AuthCodeNotifier extends StateNotifier<AuthCodeState> {
  AuthCodeNotifier() : super(
    AuthCodeState(
      code: [],
      resultMesssage: '',
      mode: GetIt.I<SecureCredentialManager>().getMode()
    )
  );


  void onNumberPressed(int number) {
    if(state.mode == null) return;
    if (state.code.length < state.mode!.length) {
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

  bool _verifyPin(String code) {
    final bool isDni = state.mode == CredentialDataType.dni;
    final bool validate = GetIt.I<SecureCredentialManager>().validCredential(
      CredentialData(authCode: code, mode: isDni ? CredentialDataType.dni : CredentialDataType.pin)
    );

    return validate;
  }

  void onSubmit({void Function()? onValid}) {
    if (state.code.length != state.mode?.length) return;

    state = state.copyWith(isLoading: true, resultMesssage: '');

    final isValid = _verifyPin(state.code.join());

    state = state.copyWith(
      isLoading: false,
      resultMesssage: isValid ? "Ingresando..." : "${state.mode?.name ?? 'codigo'} incorrecto",
      code: []
    );

    if(isValid) onValid?.call();
  }

}

final authCodeProvider = StateNotifierProvider<AuthCodeNotifier, AuthCodeState>(
  (ref) => AuthCodeNotifier()
);