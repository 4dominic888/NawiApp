import 'package:drift/drift.dart';
import 'package:nawiapp/domain/models/models_table/register_book_table.dart';

abstract class RegisterBookViewDAOVersion extends View {

  RegisterBookTable get registerBook;

  Expression<String> get hourCreatedAt => registerBook.createdAt.strftime("%H:%M");

  @override
  Query as() => select([
    registerBook.id, registerBook.action, hourCreatedAt,
    registerBook.createdAt, registerBook.type,
  ]).from(registerBook);
}

enum RegisterBookViewOrderByType {
  timestampRecently, timestampOldy, actionAsc, actionDesc
}