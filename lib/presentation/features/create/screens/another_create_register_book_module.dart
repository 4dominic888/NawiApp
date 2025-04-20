import 'package:flutter/material.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/presentation/features/create/widgets/another_mention_student_field.dart';
import 'package:nawiapp/presentation/widgets/another_register_book_element.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class AnotherCreateRegisterBookModule extends StatefulWidget {
  const AnotherCreateRegisterBookModule({ super.key });

  @override
  State<AnotherCreateRegisterBookModule> createState() => _AnotherCreateRegisterBookModuleState();
}

class _AnotherCreateRegisterBookModuleState extends State<AnotherCreateRegisterBookModule> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Vista previa", style: Theme.of(context).textTheme.headlineSmall),
      
          Padding(
            padding: EdgeInsets.all(2),
            child: AnotherRegisterBookElement(
              item: RegisterBookSummary(
                id: '*',
                action: 'Accion X creada por pepepepeppepe',
                hourCreatedAt: "45h 33m",
                createdAt: DateTime.now(),
                type: RegisterBookType.anecdotal,
                mentions: [
                  StudentSummary(id: '*', name: "Carlos Jose", age: StudentAge.fiveYears),
                  StudentSummary(id: '*', name: "Alejandro nosdasd", age: StudentAge.fiveYears),
                  StudentSummary(id: '*', name: "Pepe pepe", age: StudentAge.fourYears),
                  StudentSummary(id: '*', name: "Maria la edl carmen", age: StudentAge.threeYears),
                  StudentSummary(id: '*', name: "Carlos Jose", age: StudentAge.fiveYears),
                ]
              ),
            ),
          ),
      
          Divider(),
      
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Agregar registro", style: Theme.of(context).textTheme.headlineSmall),
      
              ElevatedButton.icon(
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text("Completar"),
                onPressed: (){}
              ),
            ],
          ),
      
          const SizedBox(height: 20),
      
          DropdownMenu<RegisterBookType>(
            initialSelection: RegisterBookType.register,
            requestFocusOnTap: false,
            label: const Text("Tipo"),
            width: MediaQuery.of(context).size.width,
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: NawiColorUtils.secondaryColor.withAlpha(110),
            ),
            onSelected: (value) => setState(() {}),
            dropdownMenuEntries: RegisterBookType.values.map(
              (e) => DropdownMenuEntry(value: e, label: e.name, leadingIcon: switch (e) {
                RegisterBookType.register => const Icon(Icons.app_registration_rounded),
                RegisterBookType.anecdotal => const Icon(Icons.star),
                RegisterBookType.incident => const Icon(Icons.warning)
              })
            ).toList(),
          ),
      
          const SizedBox(height: 20),
      
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Acción',
              hintText: 'Presione este campo para comenzar a registrar la acción',
              suffix: IconButton(onPressed: (){}, icon: const Icon(Icons.voice_chat)),
              filled: true,
              fillColor: NawiColorUtils.secondaryColor.withAlpha(110),
              floatingLabelBehavior: FloatingLabelBehavior.always
            ),
            readOnly: true,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnotherMentionStudentField()));
            },
          )
        ],
      ),
    );
  }
}