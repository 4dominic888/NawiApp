import 'package:nawiapp/domain/models/student.dart';

enum RegisterBookType {
  incident("Incidente"),
  anecdotal("Anecdótico"),
  register("Registro");

  final String name;
  const RegisterBookType(this.name);
}

class RegisterBook {
  String action;
  Set<Student> _mentions = {};
  final RegisterBookType? type;
  final String? notes;
  final DateTime timestamp = DateTime.now();

  List<Student> get mentions => _mentions.toList();
  set mentions(List<Student>? value) => _mentions = Set<Student>.from(value ?? []);

  RegisterBook({
    required this.action, List<Student>? mentions,
    this.type = RegisterBookType.register, this.notes
  }) { this.mentions = mentions; }

  factory RegisterBook.empty() => RegisterBook(action: "", mentions: []);
}