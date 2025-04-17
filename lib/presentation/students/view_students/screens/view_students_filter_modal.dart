import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/data/local/views/student_view.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';
import 'package:nawiapp/presentation/students/view_students/providers/student_filter_provider.dart';
import 'package:nawiapp/presentation/students/view_students/widgets/labeled_checkbox.dart';

class ViewStudentsFilterModal extends ConsumerStatefulWidget {
  const ViewStudentsFilterModal({super.key});

  @override
  ConsumerState<ViewStudentsFilterModal> createState() => _ViewStudentsFilterModalState();
}

class _ViewStudentsFilterModalState extends ConsumerState<ViewStudentsFilterModal> {

  late final StudentFilter _studentFilter;

  final _scrollController = ScrollController();

  final _searchStudentController = TextEditingController();
  final Map<StudentAge, bool> _filterAges = {
    StudentAge.threeYears: false,
    StudentAge.fourYears: false,
    StudentAge.fiveYears: false
  };

  StudentViewOrderByType? _selectedOrder = StudentViewOrderByType.timestampRecently;
  bool _showHidden = false;

  @override
  void initState() {
    super.initState();
    _studentFilter = ref.read(studentFilterProvider);
    _searchStudentController.text = _studentFilter.nameLike ?? '';
    if(_studentFilter.ageEnumIndex1 != null) _filterAges.update(_studentFilter.ageEnumIndex1!, (value) => true);
    if(_studentFilter.ageEnumIndex2 != null) _filterAges.update(_studentFilter.ageEnumIndex2!, (value) => true);
    _selectedOrder = _studentFilter.orderBy;
    _showHidden = _studentFilter.showHidden;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Filtrar estudiantes"),
      scrollable: true,
      content: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height *0.5,
          child: Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  TextField(
                    controller: _searchStudentController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(),
                      suffix: GestureDetector(
                        onTap: _searchStudentController.clear,
                        child: Icon(Icons.clear),
                      ),
                      hintText: "Buscar estudiantes"
                    ),
                  ),
                      
                  const SizedBox(height: 16),
                      
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Por edades"
                    ),
                    child: Wrap(
                      spacing: 8,
                      children: _filterAges.keys.map((key) => LabeledCheckbox(
                        value: _filterAges[key]!,
                        onChanged: (value) => setState(() => _filterAges[key] = value ?? false),
                        title: Text(key.name),
                      )).toList()
                    ),
                  ),
                      
                  const SizedBox(height: 16),
                  
                  InputDecorator(
                    decoration: InputDecoration(labelText: "Ordenar"),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                RadioListTile<StudentViewOrderByType>(
                                  contentPadding: EdgeInsets.zero,
                                  value: StudentViewOrderByType.nameAsc,
                                  groupValue: _selectedOrder,
                                  onChanged: (value) => setState(() => _selectedOrder = value),
                                  title: const Text("A-Z"),
                                ),
                      
                                RadioListTile<StudentViewOrderByType>(
                                  contentPadding: EdgeInsets.zero,
                                  value: StudentViewOrderByType.nameDesc,
                                  groupValue: _selectedOrder,
                                  onChanged: (value) => setState(() => _selectedOrder = value),
                                  title: const Text("Z-A"),
                                )
                              ]
                            )
                          ),
                      
                          const VerticalDivider(),
                          
                          Expanded(
                            child: Column(
                              children: [
                                RadioListTile<StudentViewOrderByType>(
                                  contentPadding: EdgeInsets.zero,
                                  value: StudentViewOrderByType.timestampRecently,
                                  groupValue: _selectedOrder,
                                  onChanged: (value) => setState(() => _selectedOrder = value),
                                  title: const Text("Recientes", style: TextStyle(fontSize: 13)),
                                ),
                      
                                RadioListTile<StudentViewOrderByType>(
                                  contentPadding: EdgeInsets.zero,
                                  value: StudentViewOrderByType.timestampOldy,
                                  groupValue: _selectedOrder,
                                  onChanged: (value) => setState(() => _selectedOrder = value),
                                  title: const Text("Antiguos", style: TextStyle(fontSize: 13)),
                                )
                              ]
                            )
                          )
                        ]
                      )
                    )
                  ),
                      
                  CheckboxListTile(
                    value: _showHidden,
                    onChanged: (value) => setState(() => _showHidden = value ?? false),
                    title: const Text("Mostrar ocultos")
                  ),
              
                  const Divider(),
                  
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _searchStudentController.clear();
                      _filterAges.updateAll((key, value) => false);
                      _selectedOrder = StudentViewOrderByType.timestampRecently;
                      _showHidden = false;
                    }),
                    child: const Text("- Limpiar selección -"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Cancelar")
        ),

        TextButton(
          onPressed: () {
            //* Obtiene solo los valores true de los checkboxes de edad
            final List<StudentAge> selectedAges = _filterAges.entries
              .where((entry) => entry.value)
              .map((e) => e.key)
            .toList();

            StudentAge? age1; StudentAge? age2;

            //* Establece los valores solo si hay entre 1 u 2 selecciones de edad
            if(selectedAges.isNotEmpty && selectedAges.length <= 2) {
              age1 = selectedAges.firstOrNull;
              age2 = selectedAges.elementAtOrNull(1);
            }

            final studentFiler = StudentFilter(
              nameLike: NawiGeneralUtils.clearSpaces(_searchStudentController.text),
              ageEnumIndex1: age1,
              ageEnumIndex2: age2,
              orderBy: _selectedOrder!,
              showHidden: _showHidden
            );
            ref.read(studentFilterProvider.notifier).state = studentFiler;
            Navigator.of(context).pop();
          },
          child: const Text("Aceptar")
        ),

      ],
    );
  }

  @override
  void dispose() {
    _searchStudentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}