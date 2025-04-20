import 'package:flutter/material.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

class SelectableModelBased extends StatefulWidget {
  const SelectableModelBased({ super.key, required this.studentModule, required this.registerBookModule , this.padding});

  final Widget studentModule;
  final Widget registerBookModule;
  final EdgeInsetsGeometry? padding;

  @override
  State<SelectableModelBased> createState() => _SelectableModelBasedState();
}

class _SelectableModelBasedState extends State<SelectableModelBased> {

  Type _selectedItem = Student;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Expanded(
          flex: 14,
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(8.0),
            child: _selectedItem == Student ? widget.studentModule : widget.registerBookModule,
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
                  onSelected: (_) => setState(() => _selectedItem = Student),
                  selected: _selectedItem == Student
                ),
                FilterChip(
                  label: Text("Registros"),
                  onSelected: (_) => setState(() => _selectedItem = RegisterBook),
                  selected: _selectedItem == RegisterBook
                )
              ],
            ),
          )
        ]        
      ],
    );
  }
}