import 'package:flutter/material.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/presentation/create/widgets/another_student_element.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

class AnotherCreateStudentModule extends StatelessWidget {
  const AnotherCreateStudentModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Vista previa", style: Theme.of(context).textTheme.headlineSmall),
        
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: AnotherStudentElement(item: StudentSummary(
            id: '*', name: "Pepito Juarez", age: StudentAge.fiveYears
          )),
        ),
    
        const Divider(),
    
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Agregar alumno", style: Theme.of(context).textTheme.headlineSmall),
    
            ElevatedButton.icon(
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text("Completar"),
              onPressed: (){}
            ),
          ],
        ),
    
        const SizedBox(height: 20),
    
        TextField(
          decoration: InputDecoration(
            labelText: 'Nombre',
            hintText: 'Nombre del estudiante',
            suffix: IconButton(onPressed: (){}, icon: const Icon(Icons.clear)),
            filled: true,
            fillColor: NawiColorUtils.secondaryColor.withAlpha(110),
            floatingLabelBehavior: FloatingLabelBehavior.always
          ),
        ),
    
        const SizedBox(height: 20),
    
        TextField(
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Notas',
            hintText: 'Ingrese detalles adicionales (Opcional)',
            suffix: IconButton(onPressed: (){}, icon: const Icon(Icons.clear)),
            filled: true,
            fillColor: NawiColorUtils.secondaryColor.withAlpha(110),
            floatingLabelBehavior: FloatingLabelBehavior.always
          ),
        ),
    
        const SizedBox(height: 25),
    
        Center(
          child: SegmentedButton<StudentAge>(
            segments: NawiGeneralUtils.studentAges.map(
              (e) => ButtonSegment(value: e, label: Text(e.name))
            ).toList(),
            selected: {StudentAge.threeYears},
            onSelectionChanged: (value) {
              
            },
          ),
        )
      ],
    );
  }
}