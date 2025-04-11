import 'package:drift/drift.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';
import 'package:recase/recase.dart';

class RegisterBook with _ActionSlugible {
  final String id;
  final DateTime createdAt;
  final RegisterBookType type;
  final String? notes;
  Set<StudentDTO> _mentions = {};

  @override
  final String action;

  RegisterBook({
    this.id = '*',
    required this.action, Iterable<StudentDTO>? mentions,
    this.type = RegisterBookType.register, this.notes,
    DateTime? timestamp
  }) : createdAt = timestamp ?? DateTime.now() { this.mentions = mentions; }
  factory RegisterBook.empty() => RegisterBook(action: "", mentions: []);

  RegisterBook.fromTableData(RegisterBookTableData data, Iterable<StudentDTO> mentions) : this(
    id: data.id,
    action: data.action,
    mentions: mentions,
    notes: data.notes,
    timestamp: data.createdAt,
    type: data.type
  );

  Iterable<StudentDTO> get mentions => _mentions;
  set mentions(Iterable<StudentDTO>? value) => _mentions = Set<StudentDTO>.from(value ?? []);

  RegisterBookTableData get toTable => RegisterBookTableData(
    id: id,
    action: action,
    type: type,
    createdAt: createdAt,
    notes: notes
  );

  RegisterBook copyWith({
    String? id, String? action,
    DateTime? createdAt,
    RegisterBookType? type,
    String? notes,
    Iterable<StudentDTO>? mentions
  }) => RegisterBook(
    id: id ?? this.id,
    action: action ?? this.action,
    timestamp: createdAt ?? this.createdAt,
    mentions: mentions ?? this.mentions,
    notes: notes ?? this.notes,
    type: type ?? this.type
  );

  RegisterBookTableCompanion toTableCompanion({bool withId = false}) => RegisterBookTableCompanion(
    id: withId ? Value(id) : Value.absent(),
    action: Value(action),
    createdAt: Value(createdAt),
    notes: Value(notes),
    type: Value(type)
  );

}

//* No se si fue buena idea crear una clase aparte, sabiendo que tiene incluso la misma cantidad
//* de atributos, quitando [notes]
class RegisterBookDTO with _ActionSlugible {
  final String id;
  final String hourCreatedAt;
  final DateTime createdAt;
  final RegisterBookType type;
  final Iterable<StudentDTO> mentions;

  @override
  final String action;
  
  const RegisterBookDTO({
    required this.id, required this.action,
    required this.hourCreatedAt, required this.createdAt,
    required this.type, required this.mentions
  });

  RegisterBookDTO.fromDTOView({required RegisterBookViewDTOVersionData data, required Iterable<StudentDTO> mentions}) : this(
    id: data.id,
    action: data.action,
    createdAt: data.createdAt,
    hourCreatedAt: data.hourCreatedAt ?? "hour error",
    type: data.type,
    mentions: mentions
  );

  RegisterBookDTO copyWith({
    String? id, String? action,
    DateTime? createdAt, String? hourCreatedAt,
    RegisterBookType? type,
    Iterable<StudentDTO>? mentions
  }) => RegisterBookDTO(
    id: id ?? this.id,
    action: action ?? this.action,
    hourCreatedAt: hourCreatedAt ?? this.hourCreatedAt,
    createdAt: createdAt ?? this.createdAt,
    type: type ?? this.type,
    mentions: mentions ?? this.mentions
  );
}

enum RegisterBookType {
  incident("Incidente"),
  anecdotal("Anecdótico"),
  register("Registro");

  final String name;
  const RegisterBookType(this.name);
}

/// Slug se refiere a esto: maria_lopez o maria-lopez
mixin _ActionSlugible {

  String get action;

  /// Remplaza las menciones con formato slug encontradas en la acción por sus formas capitalizadas.
  /// 
  /// Ejemplo:
  /// ```
  /// formatActionText("Y asi, @mario_rodriguez jugó tranquilo"); // Y asi, Mario Rodriguez jugó tranquilo
  /// ```
  String get actionUnslug {
    final buffer = StringBuffer();
    for (String word in action.split(' ')) {
      if(word.startsWith('@')) word = word.replaceFirst('@', '').replaceAll('_', ' ').titleCase;
      buffer.write(word);
      buffer.write(' ');
    }
    return NawiTools.clearSpaces(buffer.toString());
  }

}