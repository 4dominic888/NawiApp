import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/auth/providers/auth_code_provider.dart';

class BackSpaceCodeButton extends ConsumerWidget {
  const BackSpaceCodeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final authCodeNotifier = ref.read(authCodeProvider.notifier);
    final authCodeState = ref.watch(authCodeProvider);

    return ElevatedButton(
      onPressed: authCodeState.isLoading ? null : authCodeNotifier.onBackspace,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade300,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),
      ),
      child: const Icon(Icons.backspace, color: Colors.white),
    );
  }
}