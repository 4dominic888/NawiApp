import 'package:drift/drift.dart';
import 'package:nawiapp/data/database_connection.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';
import 'package:recase/recase.dart';

enum RegisterBookType {
  incident("Incidente"),
  anecdotal("Anecdótico"),
  register("Registro");

  final String name;
  const RegisterBookType(this.name);
}

/// Para que compartan esta funcion que formatea la acción
mixin _FormatActionRegisterBook {

  String get action;

  /// Formatea el texto ingresado a uno más legible.
  /// 
  /// Remplaza las menciones encontradas en el texto por sus formas capitalizadas.
  /// 
  /// Ejemplo:
  /// ```
  /// formatActionText("Y asi, @mario_rodriguez jugó tranquilo"); // Y asi, Mario Rodriguez jugó tranquilo
  /// ```
  String get formatActionText {
    final buffer = StringBuffer();
    for (String word in action.split(' ')) {
      if(word.startsWith('@')) word = word.replaceFirst('@', '').replaceAll('_', ' ').titleCase;
      buffer.write(word);
      buffer.write(' ');
    }
    return NawiTools.clearSpacesOnText(buffer.toString());
  }

}

class RegisterBook with _FormatActionRegisterBook {
  final String id;
  @override final String action;
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

  RegisterBookTableCompanion toTableCompanion({bool withId = false}) => RegisterBookTableCompanion(
    id: withId ? Value(id) : Value.absent(),
    action: Value(action),
    createdAt: Value(timestamp),
    notes: Value(notes),
    type: Value(type)
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
    timestamp: data.createdAt,
    type: data.type
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
class RegisterBookDAO with _FormatActionRegisterBook {
  final String id;
  @override final String action;
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