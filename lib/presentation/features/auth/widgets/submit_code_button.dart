import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/auth/providers/auth_code_provider.dart';
import 'package:nawiapp/presentation/features/select_classroom/screens/select_classroom_screen.dart';

class SubmitCodeButton extends ConsumerWidget {
  const SubmitCodeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final authCodeNotifier = ref.read(authCodeProvider.notifier);
    final authCodeState = ref.watch(authCodeProvider);
    final bool isLenghtValid = authCodeState.code.length != authCodeState.maxLength;
    final bool isValid = authCodeState.isLoading || isLenghtValid;

    return ElevatedButton(
      onPressed: isValid ? null : () async {
        await authCodeNotifier.onSubmit(
          onValid: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SelectClassroomScreen())
          )
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade600,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),
      ),
      child: const Icon(Icons.check, color: Colors.white),
    );
  }
}