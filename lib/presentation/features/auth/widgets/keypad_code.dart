import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/auth/widgets/back_space_code_button.dart';
import 'package:nawiapp/presentation/features/auth/widgets/number_code_button.dart';
import 'package:nawiapp/presentation/features/auth/widgets/submit_code_button.dart';

class KeypadCode extends ConsumerWidget {
  const KeypadCode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final buttons = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ];

    return Column(
      spacing: 15,
      children: [
        for (final row in buttons)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map( (n) => NumberCodeButton(number: n) ).toList()
          ),

        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const BackSpaceCodeButton(),
            const NumberCodeButton(number: 0),
            const SubmitCodeButton()
          ],
        ),
      ],
    );
  }
}