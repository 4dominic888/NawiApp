import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/tutorial/providers/tutorial_slider_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TutorialDotNavigation extends ConsumerWidget {
  const TutorialDotNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutorialState = ref.watch(tutorialSliderProvider);
    return Positioned(
      bottom: kBottomNavigationBarHeight - 25,
      left: 25,
      child: SmoothPageIndicator(
        controller: tutorialState.pageController,
        count: 4,
        onDotClicked: ref.read(tutorialSliderProvider.notifier).dotNavigation,
        effect: ExpandingDotsEffect(
          activeDotColor: Colors.grey.shade300,
          dotColor: Colors.grey.shade400,
          dotHeight: 6
        ),
      ),
    );
  }
}