import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/select_classroom/screens/select_classroom_screen.dart';
import 'package:nawiapp/presentation/features/tutorial/providers/tutorial_slider_provider.dart';

class TutorialNextPageButton extends ConsumerWidget {
  const TutorialNextPageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutorialNotifier = ref.read(tutorialSliderProvider.notifier);
    final tutorialState = ref.watch(tutorialSliderProvider);
    final bool isValidatePin = tutorialState.authCode.isNotEmpty && tutorialNotifier.codeAuthErrorText == null;
    return Positioned(
      right: 25,
      bottom: kBottomNavigationBarHeight - 25,
      child: ElevatedButton(
        onPressed: isValidatePin || !tutorialNotifier.isLastPage ? () => tutorialNotifier.nextPage(
          onComplete: () async {
            await tutorialNotifier.saveAndContinue();
            if(!context.mounted) return;
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SelectClassroomScreen()));
          }
        ) : null,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          iconSize: 40
        ),
        child: tutorialState.loading ?
          const CircularProgressIndicator(color: Colors.white, padding: EdgeInsets.all(8.0)) :
          const Icon(Icons.arrow_forward, color: Colors.white)
      ),
    );
  }
}