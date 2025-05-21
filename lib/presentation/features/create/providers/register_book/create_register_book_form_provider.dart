import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/mappers/register_book_mapper.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/presentation/shared/submit_status.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

class _RegisterBookFormState {
  final RegisterBook data;
  final SubmitStatus status;
  
  _RegisterBookFormState({required this.data, this.status = SubmitStatus.idle});

  _RegisterBookFormState copyWith({
    String? action,
    RegisterBookType? type,
    Iterable<StudentSummary>? mentions,
    DateTime? createdAt,
    String? notes,
    SubmitStatus? status,
    String? classroomId
  }
  ) => _RegisterBookFormState(
    data: data.copyWith(
      action: action ?? data.action,
      type: type ?? data.type,
      mentions: mentions ?? data.mentions,
      createdAt: createdAt ?? data.createdAt,
      notes: notes ?? data.notes,
      classroomId: classroomId ?? data.classroomId
    ),
    status: status ?? this.status
  );
}

class RegisterBookFormNotifier extends StateNotifier<_RegisterBookFormState> {
  final RegisterBookServiceBase service;

  RegisterBookFormNotifier(RegisterBook? registerBook, {required this.service}) : 
    super(_RegisterBookFormState(data: registerBook ?? RegisterBookMapper.empty()));

  void setAction(String action) => state = state.copyWith(action: action);
  void setType(RegisterBookType? type) => state = state.copyWith(type: type ?? RegisterBookType.register);
  void setMentions(Iterable<StudentSummary> mentions) => state = state.copyWith(mentions: mentions);
  void setTimestamp(DateTime? createdAt) => state = state.copyWith(createdAt: createdAt ?? DateTime.now());
  void setNotes(String notes) => state = state.copyWith(notes: notes);
  void setStatus(SubmitStatus status) => state = state.copyWith(status: status);

  void clearMentions() => setMentions([]);
  void clearNotes() => setNotes('');
  void clearAction() => setAction('');

  String? get createdAtErrorText {
    if(state.data.createdAt.isAfter(DateTime.now())) return "No puedes ingresar una hora futura";
    return null;
  }

  String? get actionErrorText {
    final action = NawiGeneralUtils.clearSpaces(state.data.action);
    if(action.isEmpty) return null;
    if(action.length <= 2) return "Acción muy corta";
    return null;
  }

  bool get validatorsOk => [createdAtErrorText, actionErrorText].every((v) => v == null);
  bool get noEmptyFields => NawiGeneralUtils.clearSpaces(state.data.action).isNotEmpty;

  bool get isValid =>  validatorsOk && noEmptyFields;

  Future<void> submit({String? idToEdit}) async {
    setStatus(SubmitStatus.loading);

    bool isUpdatable = idToEdit != null;
    final Result<Object> result;

    if(isUpdatable) {
      result = await service.updateOne(state.data.copyWith(id: idToEdit));
    }
    else {
      result = await service.addOne(state.data);
    }

    result.onValue(
      onError: (_, __) => setStatus(SubmitStatus.error),
      onSuccessfully: (_, __) => setStatus(SubmitStatus.success),
    );
  }
}

final registerBookFormProvider = StateNotifierProvider
  .autoDispose
  .family<RegisterBookFormNotifier, _RegisterBookFormState, RegisterBook?>(
    (ref, registerBook) => RegisterBookFormNotifier(registerBook, service: GetIt.I<RegisterBookServiceBase>()),
  );