import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom_status.dart';
import 'package:nawiapp/domain/services/classroom_service_base.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class ClassroomFormNotifier extends StateNotifier<Classroom> {

  final ClassroomServiceBase service;

  ClassroomFormNotifier(Classroom? classroom, {required this.service}) : super(classroom ?? Classroom.empty());

  void setName(String name) => state = state.copyWith(name: name);
  void setIcon(int iconCode) => state = state.copyWith(iconCode: iconCode);
  void setStatus(ClassroomStatus status) => state = state.copyWith(status: status);

  String? get nameErrorText {
    final name = NawiGeneralUtils.clearSpaces(state.name);
    if(name.isEmpty) return null;
    if(name.length <= 2) return "El nombre es demasiado corto";
    return null;
  }

  bool get isValid => NawiGeneralUtils.clearSpaces(state.name).isNotEmpty;

  Future<void> submit({required RoundedLoadingButtonController buttonController, String? idToEdit}) async {
    // buttonController.start();

    bool isUpdatable = idToEdit != null;
    final Result<Object> result;

    if(isUpdatable) {
      result = await service.updateOne(state.copyWith(id: idToEdit));
    }
    else {
      result = await service.addOne(state);
    }

    result.onValue(
      onError: (_, __) => buttonController.error(),
      onSuccessfully: (_, __) => buttonController.success(),
    );
  }
}

final classroomFormProvider = StateNotifierProvider
  .autoDispose
  .family<ClassroomFormNotifier, Classroom, Classroom?>
  ((ref, classroom) => ClassroomFormNotifier(classroom, service: GetIt.I<ClassroomServiceBase>()));