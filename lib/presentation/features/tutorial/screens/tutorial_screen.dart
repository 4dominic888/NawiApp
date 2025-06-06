import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/tutorial/providers/tutorial_slider_provider.dart';
import 'package:nawiapp/presentation/features/tutorial/widgets/tutorial_dot_navigation.dart';
import 'package:nawiapp/presentation/features/tutorial/widgets/tutorial_next_page_button.dart';
import 'package:nawiapp/presentation/features/tutorial/widgets/tutorial_code_auth_slide_page.dart';
import 'package:nawiapp/presentation/features/tutorial/widgets/tutorial_previous_page_button.dart';
import 'package:nawiapp/presentation/features/tutorial/widgets/tutorial_skip_button.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {

  Widget _buildSlide(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(text, style: const TextStyle(fontSize: 24), textAlign: TextAlign.center),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tutorialState = ref.watch(tutorialSliderProvider);
    final tutorialNotifier = ref.read(tutorialSliderProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: tutorialState.pageController,
            onPageChanged: tutorialNotifier.onPageChanged,
            children: [
              _buildSlide('Bienvenido al tutorial.\nDesliz a la derecha para continuar ->'),
              _buildSlide('Aquí aprenderás a usar la app.'),
              _buildSlide('Recuerda siempre mantener tus datos seguros.'),
              const TutorialCodeAuthSlidePage()
            ],
          ),

          if(!tutorialNotifier.isLastPage) const TutorialSkipButton(),
          const TutorialDotNavigation(),
          const TutorialNextPageButton(),
          if(!tutorialNotifier.isFirstPage) const TutorialPreviousPageButton()
        ],
      )
    );
  }
}