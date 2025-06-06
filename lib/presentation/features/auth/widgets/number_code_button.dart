import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/auth/providers/auth_code_provider.dart';

class NumberCodeButton extends ConsumerWidget {

  final int number;

  const NumberCodeButton({ super.key, required this.number }) : assert(number >= 0 && number <= 9, 'The number value must be in 0-9 range');

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final authCodeNotifier = ref.read(authCodeProvider.notifier);
    final authCodeState = ref.watch(authCodeProvider);

    return ElevatedButton(
      onPressed: authCodeState.isLoading ? null : () => authCodeNotifier.onNumberPressed(number),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),
      ),
      child: Text(number.toString(), style: const TextStyle(fontSize: 20)),
    );
  }
}