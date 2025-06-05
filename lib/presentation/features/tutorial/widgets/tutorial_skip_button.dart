import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/tutorial/providers/tutorial_slider_provider.dart';

class TutorialSkipButton extends ConsumerWidget {
  const TutorialSkipButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: kToolbarHeight, right: 20,
      child: TextButton(
        onPressed: ref.read(tutorialSliderProvider.notifier).skip,
        style: TextButton.styleFrom(side: BorderSide(color: Colors.grey.shade600)),
        child: const Text('Saltar')
      )
    );
  }
}