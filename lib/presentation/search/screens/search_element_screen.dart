import 'package:flutter/material.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/presentation/create/widgets/another_student_element.dart';
import 'package:nawiapp/presentation/search/screens/another_advanced_student_filter_modal.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

class SearchElementScreen extends StatefulWidget {
  const SearchElementScreen({ super.key });

  @override
  State<SearchElementScreen> createState() => _SearchElementScreenState();
}

class _SearchElementScreenState extends State<SearchElementScreen> {

  Type selectedItem = Student;

  @override
  Widget build(BuildContext context) {

    final studentList = [
      StudentSummary(id: '*', name: 'Pepe', age: StudentAge.threeYears),
      StudentSummary(id: '*', name: 'Pepe', age: StudentAge.fourYears),
      StudentSummary(id: '*', name: 'Pepe', age: StudentAge.fiveYears),
      StudentSummary(id: '*', name: 'Pepe', age: StudentAge.threeYears),
      StudentSummary(id: '*', name: 'Pepe', age: StudentAge.fourYears),
      StudentSummary(id: '*', name: 'Pepe Ramirez', age: StudentAge.fiveYears),
      StudentSummary(id: '*', name: 'Pepe', age: StudentAge.threeYears),
      StudentSummary(id: '*', name: 'Pepe', age: StudentAge.fourYears),
      StudentSummary(id: '*', name: 'Pepe Manuel Jose', age: StudentAge.fiveYears),
      StudentSummary(id: '*', name: 'Pepe', age: StudentAge.threeYears),
      StudentSummary(id: '*', name: 'Pepe', age: StudentAge.fourYears),
      StudentSummary(id: '*', name: 'Pepe', age: StudentAge.fiveYears),
      StudentSummary(id: '*', name: 'Pepe', age: StudentAge.threeYears),
      StudentSummary(id: '*', name: 'Pepe', age: StudentAge.fourYears),
      StudentSummary(id: '*', name: 'Pepe', age: StudentAge.fiveYears),
    ];

    return Column(
      children: [
        Expanded(
          flex: 14,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Busqueda por nombre...',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: NawiColorUtils.secondaryColor.withAlpha(110),                
                        ),
                      ),
                    ),
                
                    IconButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NawiColorUtils.secondaryColor
                      ),
                      icon: const Icon(Icons.more_horiz_outlined),
                      onPressed: () {
                        showDialog(context: context, builder: (context) => AnotherAdvancedStudentFilterModal());
                      },
                    ),
          
                    IconButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NawiColorUtils.secondaryColor
                      ),
                      icon: const Icon(Icons.cleaning_services),
                      onPressed: null
                    ),
                  ],
                ),
              ),
            ),
          
            body: CustomScrollView(
              slivers: [
                SliverList.list(
                  children: studentList.map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnotherStudentElement(item: e)
                    )
                  ).toList(),
                )
              ],
            ),
          ),
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
                  onSelected: (_) => setState(() => selectedItem = Student),
                  selected: selectedItem == Student
                ),
                FilterChip(
                  label: Text("Registros"),
                  onSelected: (_) => setState(() => selectedItem = RegisterBook),
                  selected: selectedItem == RegisterBook
                )
              ],
            ),
          )
        ]
        
      ],
    );
  }
}
