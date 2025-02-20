import 'package:nawiapp/domain/models/student.dart';

enum RegisterBookType {
  incident("Incidente"),
  anecdotal("Anecdótico"),
  register("Registro");

  final String name;
  const RegisterBookType(this.name);
}

class RegisterBook {
  final String id;
  String action;
  DateTime timestamp = DateTime.now();
  RegisterBookType? type;
  String? notes;

  Set<Student> _mentions = {};

  List<Student> get mentions => _mentions.toList();
  set mentions(List<Student>? value) => _mentions = Set<Student>.from(value ?? []);

  RegisterBook({
    this.id = '*',
    required this.action, List<Student>? mentions,
    this.type = RegisterBookType.register, this.notes
  }) { this.mentions = mentions; }

  factory RegisterBook.empty() => RegisterBook(action: "", mentions: []);
}