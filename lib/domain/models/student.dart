import 'package:drift/drift.dart';
import 'package:nawiapp/data/drift_connection.dart';

class Student with _MentionLabelStudent, _IdenticalStudent {
  @override
  final String id;

  @override
  final StudentAge age;

  @override
  final String name;

  final String? notes;
  final DateTime timestamp;

  Student({
    this.id = '*',
    required this.name, required this.age,
    this.notes, DateTime? timestamp
  }) : timestamp = timestamp ?? DateTime.now();

  //* Drift convertors
  Student.fromTableData(StudentTableData data) : 
    this(id: data.id, name: data.name,age: data.age, notes: data.notes, timestamp: data.timestamp);

  StudentSummary get toStudentSummary => StudentSummary(id: id, name: name, age: age);  

  StudentTableData get toTableData => StudentTableData(
    id: id,
    name: name,
    age: age,
    timestamp: timestamp,
    notes: notes
  );

  Student copyWith({
    String? id,
    String? name,
    StudentAge? age,
    String? notes,
    DateTime? timestamp
  }) => Student(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age ?? this.age,
    notes: notes ?? this.notes,
    timestamp: timestamp ?? this.timestamp
  );

  StudentTableCompanion toTableCompanion({bool withId = false}) => StudentTableCompanion(
    id: withId ? Value(id) : Value.absent(),
    age: Value(age),
    name: Value(name),
    notes: Value(notes),
    timestamp: Value(timestamp)
  );
}

enum StudentAge {
  threeYears(3, "3 años", alterName: "tres años"),
  fourYears(4, "4 años", alterName: "cuatro años"),
  fiveYears(5, "5 años", alterName: "cinco años"),
  custom.notDefined("No definido");

  final int value;
  final String name;
  final String? alterName;

  const StudentAge(this.value, this.name, {this.alterName});
  const StudentAge.notDefined(String n) : this(0, n);
}

class StudentSummary with _MentionLabelStudent, _IdenticalStudent {
  @override
  final String id;
  
  @override
  final String name;
  
  @override
  final StudentAge age;

  const StudentSummary({required this.id, required this.name, required this.age});

  StudentSummary.fromSummaryView(StudentViewSummaryVersionData data) : this(id: data.id, name: data.name, age: data.age);
}

mixin _IdenticalStudent {
  StudentAge get age;
  @override
  int get hashCode => name.hashCode ^ age.hashCode;
  String get id;

  String get name;

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;
    return (other is Student || other is StudentSummary) &&
    (other as _IdenticalStudent).name == name && other.age == age && other.id == id;
  }
}

mixin _MentionLabelStudent {
  String get mentionLabel => name.replaceAll(' ', '_').toLowerCase();
  String get name;
}