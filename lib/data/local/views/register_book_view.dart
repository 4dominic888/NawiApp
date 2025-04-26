import 'package:drift/drift.dart';
import 'package:nawiapp/data/local/tables/hidden_register_book_table.dart';
import 'package:nawiapp/data/local/tables/register_book_table.dart';

abstract class RegisterBookViewSummaryVersion extends View {
  RegisterBookTable get registerBook;

  @override
  Query as() => select([
    registerBook.id, registerBook.action,
    registerBook.createdAt, registerBook.type,
  ]).from(registerBook);
}

abstract class HiddenRegisterBookViewSummaryVersion extends View {
  HiddenRegisterBookTable get hiddenRegisterBook;
  RegisterBookTable get registerBook;

  @override
  Query<HasResultSet, dynamic> as() => select([
    registerBook.id, registerBook.action,
    registerBook.createdAt, registerBook.type,
  ]).from(hiddenRegisterBook).join([
    innerJoin(registerBook, registerBook.id.equalsExp(hiddenRegisterBook.hiddenRegisterBookId))
  ]);
}

enum RegisterBookViewOrderByType {
  timestampRecently, timestampOldy, actionAsc, actionDesc
}