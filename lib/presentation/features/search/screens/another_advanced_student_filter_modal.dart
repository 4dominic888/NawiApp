import 'package:flutter/material.dart';
import 'package:nawiapp/data/local/views/student_view.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

class AnotherAdvancedStudentFilterModal extends StatefulWidget {
  final StudentFilter currentFilter;

  const AnotherAdvancedStudentFilterModal({ super.key, required this.currentFilter });

  @override
  State<AnotherAdvancedStudentFilterModal> createState() => _AnotherAdvancedStudentFilterModal();
}

class _AnotherAdvancedStudentFilterModal extends State<AnotherAdvancedStudentFilterModal> {

  late StudentFilter _filter;
  Set<StudentAge> _pseudoAgeSelected = {};

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
    if(_filter.ageEnumIndex1 != null) _pseudoAgeSelected.add(_filter.ageEnumIndex1!);
    if(_filter.ageEnumIndex2 != null) _pseudoAgeSelected.add(_filter.ageEnumIndex2!);
  }

  void _setAges(Set<StudentAge> ages) {
    setState(() {
      if(ages.isEmpty || ages.length == 3) {
        _filter = _filter.copyWith(
          ageEnumIndex1: StudentAge.custom,
          ageEnumIndex2: StudentAge.custom
        );
      }
      else {
        _filter = _filter.copyWith(
          ageEnumIndex1: ages.elementAtOrNull(0) ?? StudentAge.custom,
          ageEnumIndex2: ages.elementAtOrNull(1) ?? StudentAge.custom
        );
      }
      _pseudoAgeSelected = ages;
    });
  }

  void _setOrderBy(Set<StudentViewOrderByType> studentOrders) {
    setState(() {
      _filter = _filter.copyWith(orderBy: studentOrders.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Filtro avanzado", style: Theme.of(context).textTheme.headlineMedium),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edad', style: Theme.of(context).textTheme.bodyLarge),
              SegmentedButton<StudentAge>(
                multiSelectionEnabled: true,
                emptySelectionAllowed: true,
                segments: NawiGeneralUtils.studentAges.map(
                  (e) => ButtonSegment(value: e, label: Text(e.value.toString()))
                ).toList(),
                selected: _pseudoAgeSelected,
                onSelectionChanged: _setAges,
              ),
          
              const SizedBox(height: 20),
              
              Text('Ordenar', style: Theme.of(context).textTheme.bodyMedium),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<StudentViewOrderByType>(
                  multiSelectionEnabled: false,
                  segments: [
                    ButtonSegment(value: StudentViewOrderByType.timestampRecently, label: const Text('Reciente')),
                    ButtonSegment(value: StudentViewOrderByType.timestampOldy, label: const Text('Antiguo')),
                    ButtonSegment(value: StudentViewOrderByType.nameAsc, label: const Text('A-Z')),
                    ButtonSegment(value: StudentViewOrderByType.nameDesc, label: const Text('Z-A')),
                  ],
                  selected: { _filter.orderBy },
                  onSelectionChanged: _setOrderBy
                ),
              ),
          
              const SizedBox(height: 20),
              CheckboxListTile(
                value: _filter.showHidden,
                onChanged: (value) => setState(() => _filter = _filter.copyWith(showHidden: value)),
                title: const Text("Mostrar ocultos")
              ),
              
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Cancelar")
        ),
        
        TextButton(
          onPressed: () => Navigator.of(context).pop(_filter),
          child: const Text("Aceptar")
        ),
      ],
    );
  }
}