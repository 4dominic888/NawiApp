import 'package:flutter/material.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/presentation/features/search/providers/selectable_element_for_search_provider.dart';
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

    return SelectableModelBased(
      label: '¿Qué desea buscar?',
      studentModule: SearchStudentModule(),
      registerBookModule: SearchRegisterBookModule(),
      controller: selectableElementForSearchProvider,
    );

    // return SearchStudentModule();
  }
}
