import 'package:drift/drift.dart';
import 'package:nawiapp/domain/models/models_table/hidden_student_table.dart';
import 'package:nawiapp/domain/models/models_table/student_table.dart';

abstract class StudentViewDAOVersion extends View {
  StudentTable get student; 

  @override Query as() => 
    select([student.id, student.name, student.age, student.timestamp]).from(student);
}

abstract class HiddenStudentViewDAOVersion extends View {
  HiddenStudentTable get hiddenStudent;
  StudentTable get student;

  @override
  Query<HasResultSet, dynamic> as() => select([
    student.id, student.name, student.age, student.timestamp
  ]).from(hiddenStudent).join([
    innerJoin(student, student.id.equalsExp(hiddenStudent.hiddenId))
  ]);
}

enum StudentViewOrderByType {
  timestampRecently, timestampOldy, nameAsc, nameDesc
}