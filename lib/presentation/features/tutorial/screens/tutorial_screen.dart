import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/presentation/features/select_classroom/widgets/classroom_element.dart';
import 'package:nawiapp/presentation/features/tutorial/providers/tutorial_slider_provider.dart';
import 'package:nawiapp/presentation/features/tutorial/widgets/tutorial_dot_navigation.dart';
import 'package:nawiapp/presentation/features/tutorial/widgets/tutorial_next_page_button.dart';
import 'package:nawiapp/presentation/features/tutorial/widgets/tutorial_code_auth_slide_page.dart';
import 'package:nawiapp/presentation/features/tutorial/widgets/tutorial_previous_page_button.dart';
import 'package:nawiapp/presentation/features/tutorial/widgets/tutorial_skip_button.dart';
import 'package:nawiapp/presentation/widgets/register_book_element.dart';
import 'package:nawiapp/presentation/widgets/scroll_hint.dart';
import 'package:nawiapp/presentation/widgets/student_element.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  final bool reviewMode;
  const TutorialScreen({super.key, this.reviewMode = false});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {

  Widget _buildSlide(String text, {Widget? children, bool? scrollable = false}) {
    final content = Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: const TextStyle(fontSize: 24), textAlign: TextAlign.center),
        ...[children ?? const SizedBox.shrink()]
      ],
    );

    return Column(
      children: [
        SizedBox(height: kToolbarHeight * 2),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: scrollable ?? false ? ScrollHint(child: content) : content,
            ),
          ),
        ),
        SizedBox(height: kToolbarHeight)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tutorialState = ref.watch(tutorialSliderProvider);
    final tutorialNotifier = ref.read(tutorialSliderProvider.notifier);

    return Scaffold(
      appBar: widget.reviewMode ? AppBar(title: const SizedBox.shrink()) : null,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: tutorialState.pageController,
              onPageChanged: tutorialNotifier.onPageChanged,
              children: [
                _buildSlide('Bienvenido al tutorial.\nDesliz a la derecha para continuar ->'),
            
                _buildSlide('Comienza creando una clase, luego estudiantes y finalmente los registros', scrollable: true, children: Column(spacing: 10,
                  children: [
                    ClassroomElement(item: Classroom(name: 'Clase Ejemplo'), preview: true),
            
                    StudentElement(item: StudentSummary(
                      id: '*', name: 'Pedro Pablo', age: StudentAge.fourYears
                    ), isPreview: true),
            
                    RegisterBookElement(item: RegisterBookSummary(
                      id: '*',
                      action: 'Pedro Pablo y Jose Miguel han jugado',
                      createdAt: DateTime(2025, 8, 3),
                      type: RegisterBookType.register,
                      mentions: [
                        StudentSummary(id: '*', name: 'Pedro Pablo', age: StudentAge.fourYears),
                        StudentSummary(id: '*', name: 'Jose Miguel', age: StudentAge.fiveYears),
                      ]
                    ), isPreview: true)
                  ],
                )),
            
                _buildSlide('Una vez registrados, ve a la vista de registros y filtra los que quieres y se exportarán en un archivo',
                  children: Image.asset('assets/images/export_example.png'),
                ),
                
                if(!widget.reviewMode) const TutorialCodeAuthSlidePage()
              ],
            ),
            
            if(!tutorialNotifier.isLastPage) const TutorialSkipButton(),
            if(!widget.reviewMode) const TutorialDotNavigation(),
            const TutorialNextPageButton(),
            if(!tutorialNotifier.isFirstPage) const TutorialPreviousPageButton()
          ],
        ),
      )
    );
  }
}