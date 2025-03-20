import 'package:nawiapp/data/database_connection.dart';
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
  final String action;
  final DateTime timestamp;
  final RegisterBookType type;
  final String? notes;

  Set<StudentDAO> _mentions = {};

  Iterable<StudentDAO> get mentions => _mentions;
  set mentions(Iterable<StudentDAO>? value) => _mentions = Set<StudentDAO>.from(value ?? []);

  RegisterBookTableData get toTable => RegisterBookTableData(
    id: id,
    action: action,
    type: type,
    createdAt: timestamp,
    notes: notes
  );

  RegisterBook({
    this.id = '*',
    required this.action, Iterable<StudentDAO>? mentions,
    this.type = RegisterBookType.register, this.notes,
    DateTime? timestamp
  }) : timestamp = timestamp ?? DateTime.now() { this.mentions = mentions; } 

  factory RegisterBook.empty() => RegisterBook(action: "", mentions: []);

  RegisterBook.fromTableData(RegisterBookTableData data, Iterable<StudentDAO> mentions) : this(
    id: data.id,
    action: data.action,
    mentions: mentions,
    notes: data.notes,
    timestamp: data.createdAt
  );

  RegisterBook copyWith({
    String? id, String? action,
    DateTime? timestamp,
    RegisterBookType? type,
    String? notes,
    Iterable<StudentDAO>? mentions
  }) => RegisterBook(
    id: id ?? this.id,
    action: action ?? this.action,
    timestamp: timestamp ?? this.timestamp,
    mentions: mentions ?? this.mentions,
    notes: notes ?? this.notes,
    type: type ?? this.type
  );
}

//* No se si fue buena idea crear una clase aparte, sabiendo que tiene incluso la misma cantidad
//* de atributos, quitando [notes]
class RegisterBookDAO {
  final String id;
  final String action;
  final String hourCreatedAt;
  final DateTime createdAt;
  final RegisterBookType type;
  final Iterable<StudentDAO> mentions;
  
  const RegisterBookDAO({
    required this.id, required this.action,
    required this.hourCreatedAt, required this.createdAt,
    required this.type, required this.mentions
  });

  RegisterBookDAO.fromDAOView({required RegisterBookViewDAOVersionData data, required Iterable<StudentDAO> mentions}) : this(
    id: data.id,
    action: data.action,
    createdAt: data.createdAt,
    hourCreatedAt: data.hourCreatedAt ?? "hour error",
    type: data.type,
    mentions: mentions
  );

  RegisterBookDAO copyWith({
    String? id, String? action,
    DateTime? createdAt, String? hourCreatedAt,
    RegisterBookType? type,
    Iterable<StudentDAO>? mentions
  }) => RegisterBookDAO(
    id: id ?? this.id,
    action: action ?? this.action,
    hourCreatedAt: hourCreatedAt ?? this.hourCreatedAt,
    createdAt: createdAt ?? this.createdAt,
    type: type ?? this.type,
    mentions: mentions ?? this.mentions
  );
}