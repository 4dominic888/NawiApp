import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/tutorial/providers/tutorial_slider_provider.dart';

class TutorialPreviousPageButton extends ConsumerWidget {
  const TutorialPreviousPageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: kToolbarHeight, left: 20,
      child: TextButton(
        onPressed: ref.read(tutorialSliderProvider.notifier).previousPage,
        style: TextButton.styleFrom(side: BorderSide(color: Colors.grey.shade600)),
        child: const Text('Anterior'),
      ),
    );
  }
}