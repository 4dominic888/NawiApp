import 'package:drift/drift.dart';
import 'package:nawiapp/domain/models/models_table/hidden_register_book_table.dart';
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

abstract class HiddenRegisterBookViewDAOVersion extends View {
  HiddenRegisterBookTable get hiddenRegisterBook;
  RegisterBookTable get registerBook;

  Expression<String> get hourCreatedAt => registerBook.createdAt.strftime("%H:%M");

  @override
  Query<HasResultSet, dynamic> as() => select([
    registerBook.id, registerBook.action, hourCreatedAt,
    registerBook.createdAt, registerBook.type,
  ]).from(hiddenRegisterBook).join([
    innerJoin(registerBook, registerBook.id.equalsExp(hiddenRegisterBook.hiddenRegisterBookId))
  ]);
}

enum RegisterBookViewOrderByType {
  timestampRecently, timestampOldy, actionAsc, actionDesc
}