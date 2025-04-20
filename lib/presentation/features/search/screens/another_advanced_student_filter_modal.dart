import 'package:flutter/material.dart';
import 'package:nawiapp/data/local/views/student_view.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

class AnotherAdvancedStudentFilterModal extends StatefulWidget {
  const AnotherAdvancedStudentFilterModal({ super.key });

  @override
  State<AnotherAdvancedStudentFilterModal> createState() => _AnotherAdvancedStudentFilterModal();
}

class _AnotherAdvancedStudentFilterModal extends State<AnotherAdvancedStudentFilterModal> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Filtro avanzado", style: Theme.of(context).textTheme.headlineMedium),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text('Edad', style: Theme.of(context).textTheme.bodyLarge),
            SegmentedButton<StudentAge>(
              segments: NawiGeneralUtils.studentAges.map(
                (e) => ButtonSegment(value: e, label: Text(e.value.toString()))
              ).toList(),
              selected: {StudentAge.threeYears},
              onSelectionChanged: (value) {
                
              },
            ),

            const SizedBox(height: 20),
            
            Text('Ordenamiento por nombre', style: Theme.of(context).textTheme.bodyMedium),
            SegmentedButton<StudentViewOrderByType>(
              segments: [
                ButtonSegment(value: StudentViewOrderByType.nameAsc, label: const Text('Ascendente')),
                ButtonSegment(value: StudentViewOrderByType.nameDesc, label: const Text('Descendente'))
              ],
              selected: {StudentViewOrderByType.nameAsc},
              onSelectionChanged: (value) {
                
              },
            ),

            const SizedBox(height: 20),

            Text('Ordenamiento por fecha', style: Theme.of(context).textTheme.bodyMedium),
            SegmentedButton<StudentViewOrderByType>(
              segments: [
                ButtonSegment(value: StudentViewOrderByType.timestampRecently, label: const Text('Reciente')),
                ButtonSegment(value: StudentViewOrderByType.timestampOldy, label: const Text('Antiguo'))
              ],
              selected: {StudentViewOrderByType.timestampRecently},
              onSelectionChanged: (value) {
                
              },
            ),

            const SizedBox(height: 20),
            CheckboxListTile(
              // value: _showHidden,
              value: true,
              // onChanged: (value) => setState(() => _showHidden = value ?? false),
              onChanged: (value) => setState(() {}),
              title: const Text("Mostrar ocultos")
            ),
            
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Cancelar")
        ),
        
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Aceptar")
        ),
      ],
    );
  }
}