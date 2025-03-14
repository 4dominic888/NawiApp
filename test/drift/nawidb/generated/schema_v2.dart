// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class Student extends Table with TableInfo<Student, StudentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Student(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
      'age', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, age, notes, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'student';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  Student createAlias(String alias) {
    return Student(attachedDatabase, alias);
  }
}

class StudentData extends DataClass implements Insertable<StudentData> {
  final String id;
  final String name;
  final int age;
  final String? notes;
  final DateTime timestamp;
  const StudentData(
      {required this.id,
      required this.name,
      required this.age,
      this.notes,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['age'] = Variable<int>(age);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  StudentCompanion toCompanion(bool nullToAbsent) {
    return StudentCompanion(
      id: Value(id),
      name: Value(name),
      age: Value(age),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      timestamp: Value(timestamp),
    );
  }

  factory StudentData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
      notes: serializer.fromJson<String?>(json['notes']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
      'notes': serializer.toJson<String?>(notes),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  StudentData copyWith(
          {String? id,
          String? name,
          int? age,
          Value<String?> notes = const Value.absent(),
          DateTime? timestamp}) =>
      StudentData(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        notes: notes.present ? notes.value : this.notes,
        timestamp: timestamp ?? this.timestamp,
      );
  StudentData copyWithCompanion(StudentCompanion data) {
    return StudentData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      notes: data.notes.present ? data.notes.value : this.notes,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('notes: $notes, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, age, notes, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentData &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.notes == this.notes &&
          other.timestamp == this.timestamp);
}

class StudentCompanion extends UpdateCompanion<StudentData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> age;
  final Value<String?> notes;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const StudentCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.notes = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentCompanion.insert({
    required String id,
    required String name,
    required int age,
    this.notes = const Value.absent(),
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        age = Value(age),
        timestamp = Value(timestamp);
  static Insertable<StudentData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? age,
    Expression<String>? notes,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (notes != null) 'notes': notes,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? age,
      Value<String?>? notes,
      Value<DateTime>? timestamp,
      Value<int>? rowid}) {
    return StudentCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('notes: $notes, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class RegisterBook extends Table
    with TableInfo<RegisterBook, RegisterBookData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  RegisterBook(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> action =
      GeneratedColumn<String>('action', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 2,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, action, type, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'register_book';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegisterBookData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegisterBookData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  RegisterBook createAlias(String alias) {
    return RegisterBook(attachedDatabase, alias);
  }
}

class RegisterBookData extends DataClass
    implements Insertable<RegisterBookData> {
  final String id;
  final String action;
  final int type;
  final String? notes;
  final DateTime createdAt;
  const RegisterBookData(
      {required this.id,
      required this.action,
      required this.type,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['action'] = Variable<String>(action);
    map['type'] = Variable<int>(type);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RegisterBookCompanion toCompanion(bool nullToAbsent) {
    return RegisterBookCompanion(
      id: Value(id),
      action: Value(action),
      type: Value(type),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory RegisterBookData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegisterBookData(
      id: serializer.fromJson<String>(json['id']),
      action: serializer.fromJson<String>(json['action']),
      type: serializer.fromJson<int>(json['type']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'action': serializer.toJson<String>(action),
      'type': serializer.toJson<int>(type),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RegisterBookData copyWith(
          {String? id,
          String? action,
          int? type,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      RegisterBookData(
        id: id ?? this.id,
        action: action ?? this.action,
        type: type ?? this.type,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  RegisterBookData copyWithCompanion(RegisterBookCompanion data) {
    return RegisterBookData(
      id: data.id.present ? data.id.value : this.id,
      action: data.action.present ? data.action.value : this.action,
      type: data.type.present ? data.type.value : this.type,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegisterBookData(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('type: $type, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, action, type, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegisterBookData &&
          other.id == this.id &&
          other.action == this.action &&
          other.type == this.type &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class RegisterBookCompanion extends UpdateCompanion<RegisterBookData> {
  final Value<String> id;
  final Value<String> action;
  final Value<int> type;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RegisterBookCompanion({
    this.id = const Value.absent(),
    this.action = const Value.absent(),
    this.type = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RegisterBookCompanion.insert({
    required String id,
    required String action,
    required int type,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        action = Value(action),
        type = Value(type),
        createdAt = Value(createdAt);
  static Insertable<RegisterBookData> custom({
    Expression<String>? id,
    Expression<String>? action,
    Expression<int>? type,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (action != null) 'action': action,
      if (type != null) 'type': type,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RegisterBookCompanion copyWith(
      {Value<String>? id,
      Value<String>? action,
      Value<int>? type,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return RegisterBookCompanion(
      id: id ?? this.id,
      action: action ?? this.action,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegisterBookCompanion(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('type: $type, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class StudentRegisterBook extends Table
    with TableInfo<StudentRegisterBook, StudentRegisterBookData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  StudentRegisterBook(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> student = GeneratedColumn<String>(
      'student', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES student (id)'));
  late final GeneratedColumn<String> registerBook = GeneratedColumn<String>(
      'register_book', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES register_book (id)'));
  @override
  List<GeneratedColumn> get $columns => [student, registerBook];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'student_register_book';
  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  StudentRegisterBookData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentRegisterBookData(
      student: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student'])!,
      registerBook: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}register_book'])!,
    );
  }

  @override
  StudentRegisterBook createAlias(String alias) {
    return StudentRegisterBook(attachedDatabase, alias);
  }
}

class StudentRegisterBookData extends DataClass
    implements Insertable<StudentRegisterBookData> {
  final String student;
  final String registerBook;
  const StudentRegisterBookData(
      {required this.student, required this.registerBook});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student'] = Variable<String>(student);
    map['register_book'] = Variable<String>(registerBook);
    return map;
  }

  StudentRegisterBookCompanion toCompanion(bool nullToAbsent) {
    return StudentRegisterBookCompanion(
      student: Value(student),
      registerBook: Value(registerBook),
    );
  }

  factory StudentRegisterBookData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentRegisterBookData(
      student: serializer.fromJson<String>(json['student']),
      registerBook: serializer.fromJson<String>(json['registerBook']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'student': serializer.toJson<String>(student),
      'registerBook': serializer.toJson<String>(registerBook),
    };
  }

  StudentRegisterBookData copyWith({String? student, String? registerBook}) =>
      StudentRegisterBookData(
        student: student ?? this.student,
        registerBook: registerBook ?? this.registerBook,
      );
  StudentRegisterBookData copyWithCompanion(StudentRegisterBookCompanion data) {
    return StudentRegisterBookData(
      student: data.student.present ? data.student.value : this.student,
      registerBook: data.registerBook.present
          ? data.registerBook.value
          : this.registerBook,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentRegisterBookData(')
          ..write('student: $student, ')
          ..write('registerBook: $registerBook')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(student, registerBook);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentRegisterBookData &&
          other.student == this.student &&
          other.registerBook == this.registerBook);
}

class StudentRegisterBookCompanion
    extends UpdateCompanion<StudentRegisterBookData> {
  final Value<String> student;
  final Value<String> registerBook;
  final Value<int> rowid;
  const StudentRegisterBookCompanion({
    this.student = const Value.absent(),
    this.registerBook = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentRegisterBookCompanion.insert({
    required String student,
    required String registerBook,
    this.rowid = const Value.absent(),
  })  : student = Value(student),
        registerBook = Value(registerBook);
  static Insertable<StudentRegisterBookData> custom({
    Expression<String>? student,
    Expression<String>? registerBook,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (student != null) 'student': student,
      if (registerBook != null) 'register_book': registerBook,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentRegisterBookCompanion copyWith(
      {Value<String>? student,
      Value<String>? registerBook,
      Value<int>? rowid}) {
    return StudentRegisterBookCompanion(
      student: student ?? this.student,
      registerBook: registerBook ?? this.registerBook,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (student.present) {
      map['student'] = Variable<String>(student.value);
    }
    if (registerBook.present) {
      map['register_book'] = Variable<String>(registerBook.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentRegisterBookCompanion(')
          ..write('student: $student, ')
          ..write('registerBook: $registerBook, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class HiddenStudentTable extends Table
    with TableInfo<HiddenStudentTable, HiddenStudentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  HiddenStudentTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> hiddenId = GeneratedColumn<String>(
      'hidden_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES student (id)'));
  @override
  List<GeneratedColumn> get $columns => [hiddenId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hidden_student_table';
  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  HiddenStudentTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HiddenStudentTableData(
      hiddenId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hidden_id'])!,
    );
  }

  @override
  HiddenStudentTable createAlias(String alias) {
    return HiddenStudentTable(attachedDatabase, alias);
  }
}

class HiddenStudentTableData extends DataClass
    implements Insertable<HiddenStudentTableData> {
  final String hiddenId;
  const HiddenStudentTableData({required this.hiddenId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['hidden_id'] = Variable<String>(hiddenId);
    return map;
  }

  HiddenStudentTableCompanion toCompanion(bool nullToAbsent) {
    return HiddenStudentTableCompanion(
      hiddenId: Value(hiddenId),
    );
  }

  factory HiddenStudentTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HiddenStudentTableData(
      hiddenId: serializer.fromJson<String>(json['hiddenId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'hiddenId': serializer.toJson<String>(hiddenId),
    };
  }

  HiddenStudentTableData copyWith({String? hiddenId}) => HiddenStudentTableData(
        hiddenId: hiddenId ?? this.hiddenId,
      );
  HiddenStudentTableData copyWithCompanion(HiddenStudentTableCompanion data) {
    return HiddenStudentTableData(
      hiddenId: data.hiddenId.present ? data.hiddenId.value : this.hiddenId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HiddenStudentTableData(')
          ..write('hiddenId: $hiddenId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => hiddenId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HiddenStudentTableData && other.hiddenId == this.hiddenId);
}

class HiddenStudentTableCompanion
    extends UpdateCompanion<HiddenStudentTableData> {
  final Value<String> hiddenId;
  final Value<int> rowid;
  const HiddenStudentTableCompanion({
    this.hiddenId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HiddenStudentTableCompanion.insert({
    required String hiddenId,
    this.rowid = const Value.absent(),
  }) : hiddenId = Value(hiddenId);
  static Insertable<HiddenStudentTableData> custom({
    Expression<String>? hiddenId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (hiddenId != null) 'hidden_id': hiddenId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HiddenStudentTableCompanion copyWith(
      {Value<String>? hiddenId, Value<int>? rowid}) {
    return HiddenStudentTableCompanion(
      hiddenId: hiddenId ?? this.hiddenId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (hiddenId.present) {
      map['hidden_id'] = Variable<String>(hiddenId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HiddenStudentTableCompanion(')
          ..write('hiddenId: $hiddenId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudentViewDAOVersionViewData extends DataClass {
  final String id;
  final String name;
  final int age;
  final DateTime timestamp;
  const $StudentViewDAOVersionViewData(
      {required this.id,
      required this.name,
      required this.age,
      required this.timestamp});
  factory $StudentViewDAOVersionViewData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return $StudentViewDAOVersionViewData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  $StudentViewDAOVersionViewData copyWith(
          {String? id, String? name, int? age, DateTime? timestamp}) =>
      $StudentViewDAOVersionViewData(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        timestamp: timestamp ?? this.timestamp,
      );
  @override
  String toString() {
    return (StringBuffer('\$StudentViewDAOVersionViewData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, age, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is $StudentViewDAOVersionViewData &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.timestamp == this.timestamp);
}

class $StudentViewDAOVersionView
    extends ViewInfo<$StudentViewDAOVersionView, $StudentViewDAOVersionViewData>
    implements HasResultSet {
  final String? _alias;
  @override
  final DatabaseAtV2 attachedDatabase;
  $StudentViewDAOVersionView(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [id, name, age, timestamp];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'student_view_d_a_o_version';
  @override
  Map<SqlDialect, String> get createViewStatements => {
        SqlDialect.sqlite:
            'CREATE VIEW IF NOT EXISTS "student_view_d_a_o_version" ("id", "name", "age", "timestamp") AS SELECT "t0"."id" AS "id", "t0"."name" AS "name", "t0"."age" AS "age", "t0"."timestamp" AS "timestamp" FROM "student" "t0"'
      };
  @override
  $StudentViewDAOVersionView get asDslTable => this;
  @override
  $StudentViewDAOVersionViewData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return $StudentViewDAOVersionViewData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string);
  late final GeneratedColumn<int> age =
      GeneratedColumn<int>('age', aliasedName, false, type: DriftSqlType.int);
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime);
  @override
  $StudentViewDAOVersionView createAlias(String alias) {
    return $StudentViewDAOVersionView(attachedDatabase, alias);
  }

  @override
  Query? get query => null;
  @override
  Set<String> get readTables => const {};
}

class $RegisterBookViewDAOVersionViewData extends DataClass {
  final String id;
  final String action;
  final String? hourCreatedAt;
  final DateTime createdAt;
  final int type;
  final String name;
  final int age;
  const $RegisterBookViewDAOVersionViewData(
      {required this.id,
      required this.action,
      this.hourCreatedAt,
      required this.createdAt,
      required this.type,
      required this.name,
      required this.age});
  factory $RegisterBookViewDAOVersionViewData.fromJson(
      Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return $RegisterBookViewDAOVersionViewData(
      id: serializer.fromJson<String>(json['id']),
      action: serializer.fromJson<String>(json['action']),
      hourCreatedAt: serializer.fromJson<String?>(json['hourCreatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      type: serializer.fromJson<int>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'action': serializer.toJson<String>(action),
      'hourCreatedAt': serializer.toJson<String?>(hourCreatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'type': serializer.toJson<int>(type),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
    };
  }

  $RegisterBookViewDAOVersionViewData copyWith(
          {String? id,
          String? action,
          Value<String?> hourCreatedAt = const Value.absent(),
          DateTime? createdAt,
          int? type,
          String? name,
          int? age}) =>
      $RegisterBookViewDAOVersionViewData(
        id: id ?? this.id,
        action: action ?? this.action,
        hourCreatedAt:
            hourCreatedAt.present ? hourCreatedAt.value : this.hourCreatedAt,
        createdAt: createdAt ?? this.createdAt,
        type: type ?? this.type,
        name: name ?? this.name,
        age: age ?? this.age,
      );
  @override
  String toString() {
    return (StringBuffer('\$RegisterBookViewDAOVersionViewData(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('hourCreatedAt: $hourCreatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('age: $age')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, action, hourCreatedAt, createdAt, type, name, age);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is $RegisterBookViewDAOVersionViewData &&
          other.id == this.id &&
          other.action == this.action &&
          other.hourCreatedAt == this.hourCreatedAt &&
          other.createdAt == this.createdAt &&
          other.type == this.type &&
          other.name == this.name &&
          other.age == this.age);
}

class $RegisterBookViewDAOVersionView extends ViewInfo<
    $RegisterBookViewDAOVersionView,
    $RegisterBookViewDAOVersionViewData> implements HasResultSet {
  final String? _alias;
  @override
  final DatabaseAtV2 attachedDatabase;
  $RegisterBookViewDAOVersionView(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns =>
      [id, action, hourCreatedAt, createdAt, type, name, age];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'register_book_view_d_a_o_version';
  @override
  Map<SqlDialect, String> get createViewStatements => {
        SqlDialect.sqlite:
            'CREATE VIEW IF NOT EXISTS "register_book_view_d_a_o_version" ("id", "action", "hour_created_at", "created_at", "type", "name", "age") AS SELECT "t1"."id" AS "id", "t1"."action" AS "action", STRFTIME(\'%H:%M\', "t1"."created_at", \'unixepoch\') AS "hour_created_at", "t1"."created_at" AS "created_at", "t1"."type" AS "type", "t0"."name" AS "name", "t0"."age" AS "age" FROM "student_register_book" "t2" INNER JOIN "student" "t0" ON "t0"."id" = "t2"."student" INNER JOIN "register_book" "t1" ON "t1"."id" = "t2"."register_book"'
      };
  @override
  $RegisterBookViewDAOVersionView get asDslTable => this;
  @override
  $RegisterBookViewDAOVersionViewData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return $RegisterBookViewDAOVersionViewData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      hourCreatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hour_created_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age'])!,
    );
  }

  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string);
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string);
  late final GeneratedColumn<String> hourCreatedAt = GeneratedColumn<String>(
      'hour_created_at', aliasedName, true,
      type: DriftSqlType.string);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime);
  late final GeneratedColumn<int> type =
      GeneratedColumn<int>('type', aliasedName, false, type: DriftSqlType.int);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string);
  late final GeneratedColumn<int> age =
      GeneratedColumn<int>('age', aliasedName, false, type: DriftSqlType.int);
  @override
  $RegisterBookViewDAOVersionView createAlias(String alias) {
    return $RegisterBookViewDAOVersionView(attachedDatabase, alias);
  }

  @override
  Query? get query => null;
  @override
  Set<String> get readTables => const {};
}

class DatabaseAtV2 extends GeneratedDatabase {
  DatabaseAtV2(QueryExecutor e) : super(e);
  late final Student student = Student(this);
  late final RegisterBook registerBook = RegisterBook(this);
  late final StudentRegisterBook studentRegisterBook =
      StudentRegisterBook(this);
  late final HiddenStudentTable hiddenStudentTable = HiddenStudentTable(this);
  late final $StudentViewDAOVersionView studentViewDAOVersion =
      $StudentViewDAOVersionView(this);
  late final $RegisterBookViewDAOVersionView registerBookViewDAOVersion =
      $RegisterBookViewDAOVersionView(this);
  late final Index name = Index('name', 'CREATE INDEX name ON student (name)');
  late final Index age = Index('age', 'CREATE INDEX age ON student (age)');
  late final Index timestamp =
      Index('timestamp', 'CREATE INDEX timestamp ON student (timestamp)');
  late final Index createdAt = Index(
      'created_at', 'CREATE INDEX created_at ON register_book (created_at)');
  late final Index type =
      Index('type', 'CREATE INDEX type ON register_book (type)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        student,
        registerBook,
        studentRegisterBook,
        hiddenStudentTable,
        studentViewDAOVersion,
        registerBookViewDAOVersion,
        name,
        age,
        timestamp,
        createdAt,
        type
      ];
  @override
  int get schemaVersion => 2;
}
