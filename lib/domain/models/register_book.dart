import 'package:nawiapp/domain/models/student.dart';

enum RegisterBookType {
  incident("Incidente"),
  anecdotal("Anecdótico"),
  register("Registro");

  final String name;
  const RegisterBookType(this.name);
}

class RegisterBook {
  final String action;
  final List<Student> mentions;
  final RegisterBookType? type;
  final String? notes;
  final DateTime timestamp = DateTime.now();

  RegisterBook({
    required this.action, required this.mentions,
    this.type = RegisterBookType.register, this.notes
  });
}