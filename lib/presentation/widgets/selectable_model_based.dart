import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

class SelectableModelBased extends ConsumerWidget {
  const SelectableModelBased({ 
    super.key,
    required this.studentModule,
    required this.registerBookModule,
    required this.controller,
    this.padding
  });

  final Widget studentModule;
  final Widget registerBookModule;
  final StateProvider<Type> controller;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectedType = ref.watch(controller);
    final notifier = ref.read(controller.notifier);

    return Column(
      children: [
        Expanded(
          flex: 14,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(8.0),
            child: selectedType == Student ? studentModule : registerBookModule,
          )
        ),

        if(!NawiGeneralUtils.isKeyboardVisible(context)) ...[
          const SizedBox(height: 20),

          Expanded(
            flex: 3,
            child: Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: Text("Estudiantes"),
                  onSelected: (_) => notifier.state = Student,
                  selected: selectedType == Student
                ),
                FilterChip(
                  label: Text("Registros"),
                  onSelected: (_) => notifier.state = RegisterBook,
                  selected: selectedType == RegisterBook
                )
              ],
            ),
          )
        ]        
      ],
    );
  }  
}
