import 'package:drift/drift.dart';
import 'package:nawiapp/domain/models/models_table/student_table.dart';

abstract class StudentViewDAOVersion extends View {
  StudentTable get student; 

  @override Query as() => 
    select([student.id, student.name, student.age]).from(student);
}

enum StudentViewOrderByType {
  timestampRecently, timestampOldy, nameAsc, nameDesc
}