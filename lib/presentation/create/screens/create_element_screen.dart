import 'package:flutter/material.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/presentation/create/screens/another_create_register_book_module.dart';
import 'package:nawiapp/presentation/create/screens/another_create_student_module.dart';

class CreateElementScreen extends StatefulWidget {
  const CreateElementScreen({ super.key });

  @override
  State<CreateElementScreen> createState() => _CreateElementScreenState();
}

class _CreateElementScreenState extends State<CreateElementScreen> {

  Type selectedItem = Student;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if(selectedItem == Student) AnotherCreateStudentModule()
                  else AnotherCreateRegisterBookModule(),

                  const SizedBox(height: 10),

                  const Divider()
                ],
              ),
            ),
          ),
          
          Center(
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
        ],
      ),
    );
  }
}