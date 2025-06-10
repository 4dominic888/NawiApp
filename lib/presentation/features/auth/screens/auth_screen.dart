import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get_it/get_it.dart';
// import 'package:nawiapp/infrastructure/secure_credential_manager.dart';
import 'package:nawiapp/presentation/features/auth/providers/auth_code_provider.dart';
import 'package:nawiapp/presentation/features/auth/widgets/code_auth_display.dart';
import 'package:nawiapp/presentation/features/auth/widgets/keypad_code.dart';

class AuthScreen extends ConsumerWidget {

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final authCodeState = ref.watch(authCodeProvider);
    // GetIt.I<SecureCredentialManager>().deleteAll();

    return Scaffold(
      appBar: AppBar(title: Text('Autenticación por ${authCodeState.mode?.name ?? '...'}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            const CodeAuthDisplay(),

            const SizedBox(height: 10),

            if (authCodeState.isLoading) const CircularProgressIndicator(),

            if (authCodeState.resultMesssage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  authCodeState.resultMesssage,
                  style: TextStyle(
                    fontSize: 16,
                    color: authCodeState.resultMesssage.contains('Ingresando')
                      ? Colors.green : Colors.red,
                  ),
                ),
              ),

            const Spacer(),

            const KeypadCode()
          ],
        ),
      ),
    );
  }
}