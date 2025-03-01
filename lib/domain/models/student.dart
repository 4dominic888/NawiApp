import 'package:nawiapp/data/database_connection.dart';

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

class Student {
  final String id;
  String name;
  final StudentAge age;
  String? notes;
  final DateTime timestamp;

  Student({
    this.id = '*',
    required this.name, required this.age,
    this.notes, DateTime? timestamp
  }) : timestamp = timestamp ?? DateTime.now();

  StudentTableData get toTableData => StudentTableData(
    id: id,
    name: name,
    age: age,
    timestamp: timestamp,
    notes: notes
  );


  //* Drift convertors
  Student.fromTableData(StudentTableData data) : 
    this(id: data.id, name: data.name,age: data.age, notes: data.notes);

  String get mentionLabel => name.replaceAll(' ', '_').toLowerCase();

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;
    return other is Student && other.name == name && other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
  
}

class StudentDAO{
  final String id;
  String name;
  final StudentAge age;

  StudentDAO({required this.id, required this.name, required this.age});

  StudentDAO.fromDAOView(StudentViewDAOVersionData data) : this(id: data.id, name: data.name, age: data.age);
}