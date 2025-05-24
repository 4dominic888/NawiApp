import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';

class SelectableModelBased extends ConsumerWidget {
  const SelectableModelBased({ 
    super.key,
    required this.studentModule,
    required this.registerBookModule,
    required this.controller,
    required this.label,
    this.padding
  });

  final Widget studentModule;
  final Widget registerBookModule;
  final StateProvider<Type> controller;
  final EdgeInsetsGeometry? padding;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectedType = ref.watch(controller);
    final notifier = ref.read(controller.notifier);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              children: [
                Text(label, style: TextTheme.of(context).titleLarge),
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
          ),
          Flexible(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(8.0),
              child: selectedType == Student ? studentModule : registerBookModule,
            ),
          ),
        ],
      ),
    );
  }  
}
