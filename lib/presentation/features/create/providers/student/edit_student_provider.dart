import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/presentation/features/create/providers/selectable_element_for_create_provider.dart';
import 'package:nawiapp/presentation/features/create/providers/student/initial_student_form_data_provider.dart';
import 'package:nawiapp/presentation/features/home/extra/menu_tabs.dart';
import 'package:nawiapp/presentation/features/home/providers/general_loading_provider.dart';
import 'package:nawiapp/presentation/features/home/providers/tab_index_provider.dart';
import 'package:nawiapp/presentation/widgets/notification_message.dart';

final editStudentProvider = Provider((ref){
  return (String studentId) async {
    final loading = ref.read(generalLoadingProvider.notifier);
    loading.state = true;

    final studentToEdit = await GetIt.I<StudentServiceBase>().getOne(studentId);

    studentToEdit.onValue(
      withPopup: false,
      onError: (_, message) {
        loading.state = false;
        NotificationMessage.showErrorNotification(message);
      },
      onSuccessfully: (data, _) {
        loading.state = false;
        //* Ir al formulario de estudiante con el dato a editar
        ref.read(tabMenuProvider.notifier).goTo(NawiMenuTabs.create);
        ref.read(initialStudentFormDataProvider.notifier).state = data;
        ref.read(selectableElementForCreateProvider.notifier).state = Student;
      },
    );
  };
});