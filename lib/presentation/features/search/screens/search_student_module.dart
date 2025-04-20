import 'package:flutter/material.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/presentation/widgets/another_student_element.dart';
import 'package:nawiapp/presentation/features/search/screens/another_advanced_student_filter_modal.dart';
import 'package:nawiapp/presentation/features/search/widgets/search_filter_field.dart';

class SearchStudentModule extends StatelessWidget {
  const SearchStudentModule({
    super.key,
    required this.studentList,
  });

  final List<StudentSummary> studentList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchFilterField(
        hintTextField: 'Búsqueda por nombre...',
        filterDialog: AnotherAdvancedStudentFilterModal(),
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
    );
  }
}