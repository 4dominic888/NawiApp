import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class MultiSelectStudentField extends StatefulWidget {

  final List<StudentSummary> initialSelectedStudents;
  final void Function(List<StudentSummary> data)? onDeleted;
  final void Function(List<StudentSummary> data)? onSelected;
  final void Function(List<StudentSummary> data)? onChanged;

  const MultiSelectStudentField({ super.key,
    this.initialSelectedStudents = const [],
    this.onDeleted, this.onSelected, this.onChanged
  });

  @override
  State<MultiSelectStudentField> createState() => _MultiSelectStudentFieldState();
}

class _MultiSelectStudentFieldState extends State<MultiSelectStudentField> {

  final List<StudentSummary> _selectedStudents = [];

  @override
  void initState() {
    super.initState();
    _selectedStudents.addAll(widget.initialSelectedStudents);
  }

  @override
  Widget build(BuildContext context) {
    final service = GetIt.I<StudentServiceBase>();
    return MultiSelectDropdownSearchFormField<StudentSummary>(
      initiallySelectedItems: _selectedStudents,
      textFieldConfiguration: const TextFieldConfiguration(
        decoration: InputDecoration(border: OutlineInputBorder()),
      ),
      dropdownBoxConfiguration: const DropdownBoxConfiguration(
        decoration: InputDecoration(
          labelText: "Seleccionar estudiantes",
          hintText: "Buscar estudiantes por nombre",
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(10),
          prefixIcon: Icon(Icons.person_search, color: NawiColorUtils.primaryColor)
        )
      ),
      itemBuilder: (_, itemData) => ListTile(title: Text(itemData.name)),
      transitionBuilder: (_, suggestionsBox, __) => suggestionsBox,
      loadingBuilder: (_) => const ListTile(leading: CircularProgressIndicator(color: NawiColorUtils.primaryColor)),
      paginatedSuggestionsCallback: (pattern) => service.getAll(
        StudentFilter(nameLike: pattern, pageSize: 5, currentPage: 0)
      ).then((value) => value.getValue!),

      errorBuilder: (context, error) => ExpansionTile(
        title: const Text("Se ha producido un error", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        subtitle: Text('Ha ocurrido un error de conexion: $error', style: const TextStyle(color: Colors.red))
      ),
      chipBuilder: (_, itemData) => Chip(
        label: Text(itemData.name),
        onDeleted: () {
          setState(() {
            _selectedStudents.remove(itemData);
            widget.onDeleted?.call(_selectedStudents);
            widget.onChanged?.call(_selectedStudents);
          });
        },
        backgroundColor: NawiColorUtils.studentColorByAge(itemData.age.value, withOpacity: true),
      ),
      noItemsFoundBuilder: (_) => const ListTile(
        title: Text('Estudiantes no encontrados...', style: TextStyle(fontWeight: FontWeight.bold)),
        contentPadding: EdgeInsets.only(left: 20)
      ),
      onMultiSuggestionSelected: (suggestion, selected) {
        (selected ? _selectedStudents.add : _selectedStudents.remove)(suggestion);
        widget.onSelected?.call(_selectedStudents);
        widget.onChanged?.call(_selectedStudents);
        setState(() { });
      },
    );
  }
}