import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/auth/providers/auth_code_provider.dart';

class CodeAuthDisplay extends ConsumerWidget {
  const CodeAuthDisplay({ super.key });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final authCodeState = ref.watch(authCodeProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        authCodeState.maxLength,
        (index) => Container(
          margin: const EdgeInsets.all(8),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < authCodeState.code.length ? Colors.black : Colors.grey[300],
          ),
        ),
      ),
    );
  }
}