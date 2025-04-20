import 'package:flutter/material.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/presentation/features/search/screens/search_register_book_module.dart';
import 'package:nawiapp/presentation/features/search/screens/search_student_module.dart';
import 'package:nawiapp/presentation/widgets/selectable_model_based.dart';

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

    return SelectableModelBased(
      studentModule: SearchStudentModule(studentList: studentList),
      registerBookModule: SearchRegisterBookModule()
    );
  }
}
