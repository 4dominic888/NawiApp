import 'package:drift/drift.dart';
import 'package:nawiapp/domain/models/models_table/register_book_table.dart';
import 'package:nawiapp/domain/models/models_table/student_register_book_table.dart';
import 'package:nawiapp/domain/models/models_table/student_table.dart';

abstract class RegisterBookViewDAOVersion extends View {

  StudentTable get student;
  RegisterBookTable get registerBook;
  StudentRegisterBookTable get studentRegisterBookTable;

  Expression<String> get hourCreatedAt => registerBook.createdAt.strftime("%H:%M");

  @override
  Query as() => select([
    registerBook.id, registerBook.action, hourCreatedAt, registerBook.createdAt, registerBook.type,
    student.name, student.age
    ])
    .from(studentRegisterBookTable).
    join([
      innerJoin(student, student.id.equalsExp(studentRegisterBookTable.student)),
      innerJoin(registerBook, registerBook.id.equalsExp(studentRegisterBookTable.registerBook))
    ]);
}

enum RegisterBookViewOrderByType {
  timestampRecently, timestampOldy, actionAsc, actionDesc
}