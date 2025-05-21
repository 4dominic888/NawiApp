import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/infrastructure/in_memory_storage.dart';
import 'package:nawiapp/presentation/shared/submit_status.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

class _StudentFormState {
  final Student data;
  final SubmitStatus status;

  _StudentFormState({required this.data, this.status = SubmitStatus.idle});

  _StudentFormState copyWith(
    {String? name, StudentAge? age, String? notes, SubmitStatus? status, String? classroomId}
  ) => _StudentFormState(data: data.copyWith(
      name: name ?? data.name,
      age: age ?? data.age,
      notes: notes ?? data.notes,
      classroomId: classroomId ?? data.classroomId
    ),
    status: status ?? this.status
  );

}

class StudentFormNotifier extends StateNotifier<_StudentFormState> {

  final StudentServiceBase service;

  StudentFormNotifier(Student? student, {required this.service}) : super(_StudentFormState(data: student ?? Student.empty()));
  
  void setName(String name) => state = state.copyWith(name: name);
  void setAge(Set<StudentAge> age) => state = state.copyWith(age: age.first);
  void setNotes(String notes) => state = state.copyWith(notes: notes);
  void setStatus(SubmitStatus status) => state = state.copyWith(status: status);

  String? get nameErrorText {
    final name = NawiGeneralUtils.clearSpaces(state.data.name);
    if(name.isEmpty) return null;
    if(name.length <= 2) return "El nombre es demasiado corto";
    return null;    
  }

  void clearName() => setName('');
  void clearNotes() => setNotes('');

  bool get validatorsOk => [nameErrorText].every((v) => v == null);
  bool get noEmptyFields => NawiGeneralUtils.clearSpaces(state.data.name).isNotEmpty;

  bool get isValid => validatorsOk && noEmptyFields;

  Future<void> submit({String? idToEdit}) async {
    state = state.copyWith(classroomId: GetIt.I<InMemoryStorage>().currentClassroom?.id);
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

final studentFormProvider = StateNotifierProvider
  .autoDispose
  .family<StudentFormNotifier, _StudentFormState, Student?>(
    (ref, student) => StudentFormNotifier(student, service: GetIt.I<StudentServiceBase>())
);