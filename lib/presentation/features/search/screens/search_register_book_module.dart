import 'package:flutter/material.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/presentation/widgets/another_register_book_element.dart';
import 'package:nawiapp/presentation/features/search/widgets/search_filter_field.dart';

class SearchRegisterBookModule extends StatelessWidget {
  const SearchRegisterBookModule({
    super.key,
  });

  static final registerBookData = [
    RegisterBookSummary(
      id: '*',
      action: 'Algo paso pero debo colocar algo para testear aaaaaaa',
      hourCreatedAt: '44a',
      createdAt: DateTime.now(),
      type: RegisterBookType.anecdotal,
      mentions: []
    ),

    RegisterBookSummary(
      id: '*',
      action: 'Algo paso pero debo colocar algo para testear aaaaaaa',
      hourCreatedAt: '44a',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      type: RegisterBookType.register,
      mentions: [
        StudentSummary(id: '*', name: 'Pedro pablo XY', age: StudentAge.fiveYears),
        StudentSummary(id: '*', name: 'Pedro pablo XY', age: StudentAge.threeYears)
      ]
    ),

    RegisterBookSummary(
      id: '*',
      action: 'Algo paso pero debo colocar algo para testear aaaaaaa',
      hourCreatedAt: '44a',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      type: RegisterBookType.incident,
      mentions: [
        StudentSummary(id: '*', name: 'Pedro pablo XY', age: StudentAge.fiveYears),
        StudentSummary(id: '*', name: 'Pedro pablo XY', age: StudentAge.threeYears)
      ]
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchFilterField(
        hintTextField: 'Búsqueda por acción',
        filterAction: () {

        },
        textOnChanged: (text) {
          
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverList.list(
            children: registerBookData.map(
              (e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnotherRegisterBookElement(item: e),
              )
            ).toList()
          )
        ],
      ),
    );
  }
}