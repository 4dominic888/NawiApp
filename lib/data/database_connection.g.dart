// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_connection.dart';

// ignore_for_file: type=lint
class $StudentTableTable extends StudentTable
    with TableInfo<$StudentTableTable, StudentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => NawiTools.uuid.v4());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumnWithTypeConverter<StudentAge, int> age =
      GeneratedColumn<int>('age', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<StudentAge>($StudentTableTable.$converterage);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
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
  VerificationContext validateIntegrity(Insertable<StudentTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_ageMeta, const VerificationResult.success());
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudentTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      age: $StudentTableTable.$converterage.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age'])!),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $StudentTableTable createAlias(String alias) {
    return $StudentTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StudentAge, int, int> $converterage =
      const EnumIndexConverter<StudentAge>(StudentAge.values);
}

class StudentTableData extends DataClass
    implements Insertable<StudentTableData> {
  final String id;
  final String name;
  final StudentAge age;
  final String? notes;
  final DateTime timestamp;
  const StudentTableData(
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
    {
      map['age'] = Variable<int>($StudentTableTable.$converterage.toSql(age));
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  StudentTableCompanion toCompanion(bool nullToAbsent) {
    return StudentTableCompanion(
      id: Value(id),
      name: Value(name),
      age: Value(age),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      timestamp: Value(timestamp),
    );
  }

  factory StudentTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: $StudentTableTable.$converterage
          .fromJson(serializer.fromJson<int>(json['age'])),
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
      'age':
          serializer.toJson<int>($StudentTableTable.$converterage.toJson(age)),
      'notes': serializer.toJson<String?>(notes),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  StudentTableData copyWith(
          {String? id,
          String? name,
          StudentAge? age,
          Value<String?> notes = const Value.absent(),
          DateTime? timestamp}) =>
      StudentTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        notes: notes.present ? notes.value : this.notes,
        timestamp: timestamp ?? this.timestamp,
      );
  StudentTableData copyWithCompanion(StudentTableCompanion data) {
    return StudentTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      notes: data.notes.present ? data.notes.value : this.notes,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentTableData(')
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
      (other is StudentTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.notes == this.notes &&
          other.timestamp == this.timestamp);
}

class StudentTableCompanion extends UpdateCompanion<StudentTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<StudentAge> age;
  final Value<String?> notes;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const StudentTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.notes = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required StudentAge age,
    this.notes = const Value.absent(),
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        age = Value(age),
        timestamp = Value(timestamp);
  static Insertable<StudentTableData> custom({
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

  StudentTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<StudentAge>? age,
      Value<String?>? notes,
      Value<DateTime>? timestamp,
      Value<int>? rowid}) {
    return StudentTableCompanion(
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
      map['age'] =
          Variable<int>($StudentTableTable.$converterage.toSql(age.value));
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
    return (StringBuffer('StudentTableCompanion(')
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

class $RegisterBookTableTable extends RegisterBookTable
    with TableInfo<$RegisterBookTableTable, RegisterBookTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegisterBookTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => NawiTools.uuid.v4());
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action =
      GeneratedColumn<String>('action', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 2,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<RegisterBookType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<RegisterBookType>(
              $RegisterBookTableTable.$convertertype);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
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
  VerificationContext validateIntegrity(
      Insertable<RegisterBookTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegisterBookTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegisterBookTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      type: $RegisterBookTableTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RegisterBookTableTable createAlias(String alias) {
    return $RegisterBookTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RegisterBookType, int, int> $convertertype =
      const EnumIndexConverter<RegisterBookType>(RegisterBookType.values);
}

class RegisterBookTableData extends DataClass
    implements Insertable<RegisterBookTableData> {
  final String id;
  final String action;
  final RegisterBookType type;
  final String? notes;
  final DateTime createdAt;
  const RegisterBookTableData(
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
    {
      map['type'] =
          Variable<int>($RegisterBookTableTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RegisterBookTableCompanion toCompanion(bool nullToAbsent) {
    return RegisterBookTableCompanion(
      id: Value(id),
      action: Value(action),
      type: Value(type),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory RegisterBookTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegisterBookTableData(
      id: serializer.fromJson<String>(json['id']),
      action: serializer.fromJson<String>(json['action']),
      type: $RegisterBookTableTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
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
      'type': serializer
          .toJson<int>($RegisterBookTableTable.$convertertype.toJson(type)),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RegisterBookTableData copyWith(
          {String? id,
          String? action,
          RegisterBookType? type,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      RegisterBookTableData(
        id: id ?? this.id,
        action: action ?? this.action,
        type: type ?? this.type,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  RegisterBookTableData copyWithCompanion(RegisterBookTableCompanion data) {
    return RegisterBookTableData(
      id: data.id.present ? data.id.value : this.id,
      action: data.action.present ? data.action.value : this.action,
      type: data.type.present ? data.type.value : this.type,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegisterBookTableData(')
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
      (other is RegisterBookTableData &&
          other.id == this.id &&
          other.action == this.action &&
          other.type == this.type &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class RegisterBookTableCompanion
    extends UpdateCompanion<RegisterBookTableData> {
  final Value<String> id;
  final Value<String> action;
  final Value<RegisterBookType> type;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RegisterBookTableCompanion({
    this.id = const Value.absent(),
    this.action = const Value.absent(),
    this.type = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RegisterBookTableCompanion.insert({
    this.id = const Value.absent(),
    required String action,
    required RegisterBookType type,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : action = Value(action),
        type = Value(type),
        createdAt = Value(createdAt);
  static Insertable<RegisterBookTableData> custom({
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

  RegisterBookTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? action,
      Value<RegisterBookType>? type,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return RegisterBookTableCompanion(
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
      map['type'] = Variable<int>(
          $RegisterBookTableTable.$convertertype.toSql(type.value));
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
    return (StringBuffer('RegisterBookTableCompanion(')
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

class $StudentRegisterBookTableTable extends StudentRegisterBookTable
    with
        TableInfo<$StudentRegisterBookTableTable,
            StudentRegisterBookTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentRegisterBookTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _studentMeta =
      const VerificationMeta('student');
  @override
  late final GeneratedColumn<String> student = GeneratedColumn<String>(
      'student', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES student (id)'));
  static const VerificationMeta _registerBookMeta =
      const VerificationMeta('registerBook');
  @override
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
  VerificationContext validateIntegrity(
      Insertable<StudentRegisterBookTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('student')) {
      context.handle(_studentMeta,
          student.isAcceptableOrUnknown(data['student']!, _studentMeta));
    } else if (isInserting) {
      context.missing(_studentMeta);
    }
    if (data.containsKey('register_book')) {
      context.handle(
          _registerBookMeta,
          registerBook.isAcceptableOrUnknown(
              data['register_book']!, _registerBookMeta));
    } else if (isInserting) {
      context.missing(_registerBookMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  StudentRegisterBookTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentRegisterBookTableData(
      student: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student'])!,
      registerBook: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}register_book'])!,
    );
  }

  @override
  $StudentRegisterBookTableTable createAlias(String alias) {
    return $StudentRegisterBookTableTable(attachedDatabase, alias);
  }
}

class StudentRegisterBookTableData extends DataClass
    implements Insertable<StudentRegisterBookTableData> {
  final String student;
  final String registerBook;
  const StudentRegisterBookTableData(
      {required this.student, required this.registerBook});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student'] = Variable<String>(student);
    map['register_book'] = Variable<String>(registerBook);
    return map;
  }

  StudentRegisterBookTableCompanion toCompanion(bool nullToAbsent) {
    return StudentRegisterBookTableCompanion(
      student: Value(student),
      registerBook: Value(registerBook),
    );
  }

  factory StudentRegisterBookTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentRegisterBookTableData(
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

  StudentRegisterBookTableData copyWith(
          {String? student, String? registerBook}) =>
      StudentRegisterBookTableData(
        student: student ?? this.student,
        registerBook: registerBook ?? this.registerBook,
      );
  StudentRegisterBookTableData copyWithCompanion(
      StudentRegisterBookTableCompanion data) {
    return StudentRegisterBookTableData(
      student: data.student.present ? data.student.value : this.student,
      registerBook: data.registerBook.present
          ? data.registerBook.value
          : this.registerBook,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentRegisterBookTableData(')
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
      (other is StudentRegisterBookTableData &&
          other.student == this.student &&
          other.registerBook == this.registerBook);
}

class StudentRegisterBookTableCompanion
    extends UpdateCompanion<StudentRegisterBookTableData> {
  final Value<String> student;
  final Value<String> registerBook;
  final Value<int> rowid;
  const StudentRegisterBookTableCompanion({
    this.student = const Value.absent(),
    this.registerBook = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentRegisterBookTableCompanion.insert({
    required String student,
    required String registerBook,
    this.rowid = const Value.absent(),
  })  : student = Value(student),
        registerBook = Value(registerBook);
  static Insertable<StudentRegisterBookTableData> custom({
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

  StudentRegisterBookTableCompanion copyWith(
      {Value<String>? student,
      Value<String>? registerBook,
      Value<int>? rowid}) {
    return StudentRegisterBookTableCompanion(
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
    return (StringBuffer('StudentRegisterBookTableCompanion(')
          ..write('student: $student, ')
          ..write('registerBook: $registerBook, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$NawiDatabase extends GeneratedDatabase {
  _$NawiDatabase(QueryExecutor e) : super(e);
  $NawiDatabaseManager get managers => $NawiDatabaseManager(this);
  late final $StudentTableTable studentTable = $StudentTableTable(this);
  late final $RegisterBookTableTable registerBookTable =
      $RegisterBookTableTable(this);
  late final $StudentRegisterBookTableTable studentRegisterBookTable =
      $StudentRegisterBookTableTable(this);
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
        studentTable,
        registerBookTable,
        studentRegisterBookTable,
        name,
        age,
        timestamp,
        createdAt,
        type
      ];
}

typedef $$StudentTableTableCreateCompanionBuilder = StudentTableCompanion
    Function({
  Value<String> id,
  required String name,
  required StudentAge age,
  Value<String?> notes,
  required DateTime timestamp,
  Value<int> rowid,
});
typedef $$StudentTableTableUpdateCompanionBuilder = StudentTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<StudentAge> age,
  Value<String?> notes,
  Value<DateTime> timestamp,
  Value<int> rowid,
});

final class $$StudentTableTableReferences extends BaseReferences<_$NawiDatabase,
    $StudentTableTable, StudentTableData> {
  $$StudentTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StudentRegisterBookTableTable,
      List<StudentRegisterBookTableData>> _studentRegisterBookTableRefsTable(
          _$NawiDatabase db) =>
      MultiTypedResultKey.fromTable(db.studentRegisterBookTable,
          aliasName: $_aliasNameGenerator(
              db.studentTable.id, db.studentRegisterBookTable.student));

  $$StudentRegisterBookTableTableProcessedTableManager
      get studentRegisterBookTableRefs {
    final manager = $$StudentRegisterBookTableTableTableManager(
            $_db, $_db.studentRegisterBookTable)
        .filter((f) => f.student.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_studentRegisterBookTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$StudentTableTableFilterComposer
    extends Composer<_$NawiDatabase, $StudentTableTable> {
  $$StudentTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<StudentAge, StudentAge, int> get age =>
      $composableBuilder(
          column: $table.age,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  Expression<bool> studentRegisterBookTableRefs(
      Expression<bool> Function($$StudentRegisterBookTableTableFilterComposer f)
          f) {
    final $$StudentRegisterBookTableTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.studentRegisterBookTable,
            getReferencedColumn: (t) => t.student,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$StudentRegisterBookTableTableFilterComposer(
                  $db: $db,
                  $table: $db.studentRegisterBookTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$StudentTableTableOrderingComposer
    extends Composer<_$NawiDatabase, $StudentTableTable> {
  $$StudentTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));
}

class $$StudentTableTableAnnotationComposer
    extends Composer<_$NawiDatabase, $StudentTableTable> {
  $$StudentTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StudentAge, int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  Expression<T> studentRegisterBookTableRefs<T extends Object>(
      Expression<T> Function(
              $$StudentRegisterBookTableTableAnnotationComposer a)
          f) {
    final $$StudentRegisterBookTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.studentRegisterBookTable,
            getReferencedColumn: (t) => t.student,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$StudentRegisterBookTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.studentRegisterBookTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$StudentTableTableTableManager extends RootTableManager<
    _$NawiDatabase,
    $StudentTableTable,
    StudentTableData,
    $$StudentTableTableFilterComposer,
    $$StudentTableTableOrderingComposer,
    $$StudentTableTableAnnotationComposer,
    $$StudentTableTableCreateCompanionBuilder,
    $$StudentTableTableUpdateCompanionBuilder,
    (StudentTableData, $$StudentTableTableReferences),
    StudentTableData,
    PrefetchHooks Function({bool studentRegisterBookTableRefs})> {
  $$StudentTableTableTableManager(_$NawiDatabase db, $StudentTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<StudentAge> age = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentTableCompanion(
            id: id,
            name: name,
            age: age,
            notes: notes,
            timestamp: timestamp,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            required StudentAge age,
            Value<String?> notes = const Value.absent(),
            required DateTime timestamp,
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentTableCompanion.insert(
            id: id,
            name: name,
            age: age,
            notes: notes,
            timestamp: timestamp,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StudentTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({studentRegisterBookTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (studentRegisterBookTableRefs) db.studentRegisterBookTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (studentRegisterBookTableRefs)
                    await $_getPrefetchedData<StudentTableData,
                            $StudentTableTable, StudentRegisterBookTableData>(
                        currentTable: table,
                        referencedTable: $$StudentTableTableReferences
                            ._studentRegisterBookTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StudentTableTableReferences(db, table, p0)
                                .studentRegisterBookTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.student == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$StudentTableTableProcessedTableManager = ProcessedTableManager<
    _$NawiDatabase,
    $StudentTableTable,
    StudentTableData,
    $$StudentTableTableFilterComposer,
    $$StudentTableTableOrderingComposer,
    $$StudentTableTableAnnotationComposer,
    $$StudentTableTableCreateCompanionBuilder,
    $$StudentTableTableUpdateCompanionBuilder,
    (StudentTableData, $$StudentTableTableReferences),
    StudentTableData,
    PrefetchHooks Function({bool studentRegisterBookTableRefs})>;
typedef $$RegisterBookTableTableCreateCompanionBuilder
    = RegisterBookTableCompanion Function({
  Value<String> id,
  required String action,
  required RegisterBookType type,
  Value<String?> notes,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$RegisterBookTableTableUpdateCompanionBuilder
    = RegisterBookTableCompanion Function({
  Value<String> id,
  Value<String> action,
  Value<RegisterBookType> type,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$RegisterBookTableTableReferences extends BaseReferences<
    _$NawiDatabase, $RegisterBookTableTable, RegisterBookTableData> {
  $$RegisterBookTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StudentRegisterBookTableTable,
      List<StudentRegisterBookTableData>> _studentRegisterBookTableRefsTable(
          _$NawiDatabase db) =>
      MultiTypedResultKey.fromTable(db.studentRegisterBookTable,
          aliasName: $_aliasNameGenerator(db.registerBookTable.id,
              db.studentRegisterBookTable.registerBook));

  $$StudentRegisterBookTableTableProcessedTableManager
      get studentRegisterBookTableRefs {
    final manager = $$StudentRegisterBookTableTableTableManager(
            $_db, $_db.studentRegisterBookTable)
        .filter(
            (f) => f.registerBook.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_studentRegisterBookTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RegisterBookTableTableFilterComposer
    extends Composer<_$NawiDatabase, $RegisterBookTableTable> {
  $$RegisterBookTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<RegisterBookType, RegisterBookType, int>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> studentRegisterBookTableRefs(
      Expression<bool> Function($$StudentRegisterBookTableTableFilterComposer f)
          f) {
    final $$StudentRegisterBookTableTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.studentRegisterBookTable,
            getReferencedColumn: (t) => t.registerBook,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$StudentRegisterBookTableTableFilterComposer(
                  $db: $db,
                  $table: $db.studentRegisterBookTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$RegisterBookTableTableOrderingComposer
    extends Composer<_$NawiDatabase, $RegisterBookTableTable> {
  $$RegisterBookTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$RegisterBookTableTableAnnotationComposer
    extends Composer<_$NawiDatabase, $RegisterBookTableTable> {
  $$RegisterBookTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RegisterBookType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> studentRegisterBookTableRefs<T extends Object>(
      Expression<T> Function(
              $$StudentRegisterBookTableTableAnnotationComposer a)
          f) {
    final $$StudentRegisterBookTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.studentRegisterBookTable,
            getReferencedColumn: (t) => t.registerBook,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$StudentRegisterBookTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.studentRegisterBookTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$RegisterBookTableTableTableManager extends RootTableManager<
    _$NawiDatabase,
    $RegisterBookTableTable,
    RegisterBookTableData,
    $$RegisterBookTableTableFilterComposer,
    $$RegisterBookTableTableOrderingComposer,
    $$RegisterBookTableTableAnnotationComposer,
    $$RegisterBookTableTableCreateCompanionBuilder,
    $$RegisterBookTableTableUpdateCompanionBuilder,
    (RegisterBookTableData, $$RegisterBookTableTableReferences),
    RegisterBookTableData,
    PrefetchHooks Function({bool studentRegisterBookTableRefs})> {
  $$RegisterBookTableTableTableManager(
      _$NawiDatabase db, $RegisterBookTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegisterBookTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegisterBookTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegisterBookTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<RegisterBookType> type = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RegisterBookTableCompanion(
            id: id,
            action: action,
            type: type,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String action,
            required RegisterBookType type,
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RegisterBookTableCompanion.insert(
            id: id,
            action: action,
            type: type,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RegisterBookTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({studentRegisterBookTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (studentRegisterBookTableRefs) db.studentRegisterBookTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (studentRegisterBookTableRefs)
                    await $_getPrefetchedData<
                            RegisterBookTableData,
                            $RegisterBookTableTable,
                            StudentRegisterBookTableData>(
                        currentTable: table,
                        referencedTable: $$RegisterBookTableTableReferences
                            ._studentRegisterBookTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RegisterBookTableTableReferences(db, table, p0)
                                .studentRegisterBookTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.registerBook == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RegisterBookTableTableProcessedTableManager = ProcessedTableManager<
    _$NawiDatabase,
    $RegisterBookTableTable,
    RegisterBookTableData,
    $$RegisterBookTableTableFilterComposer,
    $$RegisterBookTableTableOrderingComposer,
    $$RegisterBookTableTableAnnotationComposer,
    $$RegisterBookTableTableCreateCompanionBuilder,
    $$RegisterBookTableTableUpdateCompanionBuilder,
    (RegisterBookTableData, $$RegisterBookTableTableReferences),
    RegisterBookTableData,
    PrefetchHooks Function({bool studentRegisterBookTableRefs})>;
typedef $$StudentRegisterBookTableTableCreateCompanionBuilder
    = StudentRegisterBookTableCompanion Function({
  required String student,
  required String registerBook,
  Value<int> rowid,
});
typedef $$StudentRegisterBookTableTableUpdateCompanionBuilder
    = StudentRegisterBookTableCompanion Function({
  Value<String> student,
  Value<String> registerBook,
  Value<int> rowid,
});

final class $$StudentRegisterBookTableTableReferences extends BaseReferences<
    _$NawiDatabase,
    $StudentRegisterBookTableTable,
    StudentRegisterBookTableData> {
  $$StudentRegisterBookTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $StudentTableTable _studentTable(_$NawiDatabase db) =>
      db.studentTable.createAlias($_aliasNameGenerator(
          db.studentRegisterBookTable.student, db.studentTable.id));

  $$StudentTableTableProcessedTableManager get student {
    final $_column = $_itemColumn<String>('student')!;

    final manager = $$StudentTableTableTableManager($_db, $_db.studentTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RegisterBookTableTable _registerBookTable(_$NawiDatabase db) =>
      db.registerBookTable.createAlias($_aliasNameGenerator(
          db.studentRegisterBookTable.registerBook, db.registerBookTable.id));

  $$RegisterBookTableTableProcessedTableManager get registerBook {
    final $_column = $_itemColumn<String>('register_book')!;

    final manager =
        $$RegisterBookTableTableTableManager($_db, $_db.registerBookTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_registerBookTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StudentRegisterBookTableTableFilterComposer
    extends Composer<_$NawiDatabase, $StudentRegisterBookTableTable> {
  $$StudentRegisterBookTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$StudentTableTableFilterComposer get student {
    final $$StudentTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.student,
        referencedTable: $db.studentTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentTableTableFilterComposer(
              $db: $db,
              $table: $db.studentTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RegisterBookTableTableFilterComposer get registerBook {
    final $$RegisterBookTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.registerBook,
        referencedTable: $db.registerBookTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RegisterBookTableTableFilterComposer(
              $db: $db,
              $table: $db.registerBookTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StudentRegisterBookTableTableOrderingComposer
    extends Composer<_$NawiDatabase, $StudentRegisterBookTableTable> {
  $$StudentRegisterBookTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$StudentTableTableOrderingComposer get student {
    final $$StudentTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.student,
        referencedTable: $db.studentTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentTableTableOrderingComposer(
              $db: $db,
              $table: $db.studentTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RegisterBookTableTableOrderingComposer get registerBook {
    final $$RegisterBookTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.registerBook,
        referencedTable: $db.registerBookTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RegisterBookTableTableOrderingComposer(
              $db: $db,
              $table: $db.registerBookTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StudentRegisterBookTableTableAnnotationComposer
    extends Composer<_$NawiDatabase, $StudentRegisterBookTableTable> {
  $$StudentRegisterBookTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$StudentTableTableAnnotationComposer get student {
    final $$StudentTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.student,
        referencedTable: $db.studentTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentTableTableAnnotationComposer(
              $db: $db,
              $table: $db.studentTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RegisterBookTableTableAnnotationComposer get registerBook {
    final $$RegisterBookTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.registerBook,
            referencedTable: $db.registerBookTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RegisterBookTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.registerBookTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$StudentRegisterBookTableTableTableManager extends RootTableManager<
    _$NawiDatabase,
    $StudentRegisterBookTableTable,
    StudentRegisterBookTableData,
    $$StudentRegisterBookTableTableFilterComposer,
    $$StudentRegisterBookTableTableOrderingComposer,
    $$StudentRegisterBookTableTableAnnotationComposer,
    $$StudentRegisterBookTableTableCreateCompanionBuilder,
    $$StudentRegisterBookTableTableUpdateCompanionBuilder,
    (StudentRegisterBookTableData, $$StudentRegisterBookTableTableReferences),
    StudentRegisterBookTableData,
    PrefetchHooks Function({bool student, bool registerBook})> {
  $$StudentRegisterBookTableTableTableManager(
      _$NawiDatabase db, $StudentRegisterBookTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentRegisterBookTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentRegisterBookTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentRegisterBookTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> student = const Value.absent(),
            Value<String> registerBook = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentRegisterBookTableCompanion(
            student: student,
            registerBook: registerBook,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String student,
            required String registerBook,
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentRegisterBookTableCompanion.insert(
            student: student,
            registerBook: registerBook,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StudentRegisterBookTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({student = false, registerBook = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (student) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.student,
                    referencedTable: $$StudentRegisterBookTableTableReferences
                        ._studentTable(db),
                    referencedColumn: $$StudentRegisterBookTableTableReferences
                        ._studentTable(db)
                        .id,
                  ) as T;
                }
                if (registerBook) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.registerBook,
                    referencedTable: $$StudentRegisterBookTableTableReferences
                        ._registerBookTable(db),
                    referencedColumn: $$StudentRegisterBookTableTableReferences
                        ._registerBookTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StudentRegisterBookTableTableProcessedTableManager
    = ProcessedTableManager<
        _$NawiDatabase,
        $StudentRegisterBookTableTable,
        StudentRegisterBookTableData,
        $$StudentRegisterBookTableTableFilterComposer,
        $$StudentRegisterBookTableTableOrderingComposer,
        $$StudentRegisterBookTableTableAnnotationComposer,
        $$StudentRegisterBookTableTableCreateCompanionBuilder,
        $$StudentRegisterBookTableTableUpdateCompanionBuilder,
        (
          StudentRegisterBookTableData,
          $$StudentRegisterBookTableTableReferences
        ),
        StudentRegisterBookTableData,
        PrefetchHooks Function({bool student, bool registerBook})>;

class $NawiDatabaseManager {
  final _$NawiDatabase _db;
  $NawiDatabaseManager(this._db);
  $$StudentTableTableTableManager get studentTable =>
      $$StudentTableTableTableManager(_db, _db.studentTable);
  $$RegisterBookTableTableTableManager get registerBookTable =>
      $$RegisterBookTableTableTableManager(_db, _db.registerBookTable);
  $$StudentRegisterBookTableTableTableManager get studentRegisterBookTable =>
      $$StudentRegisterBookTableTableTableManager(
          _db, _db.studentRegisterBookTable);
}
