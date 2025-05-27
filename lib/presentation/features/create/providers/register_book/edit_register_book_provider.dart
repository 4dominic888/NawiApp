import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/presentation/features/create/providers/register_book/initial_register_book_form_data_provider.dart';
import 'package:nawiapp/presentation/features/create/providers/selectable_element_for_create_provider.dart';
import 'package:nawiapp/presentation/features/home/extra/menu_tabs.dart';
import 'package:nawiapp/presentation/features/home/providers/general_loading_provider.dart';
import 'package:nawiapp/presentation/features/home/providers/tab_index_provider.dart';
import 'package:nawiapp/presentation/widgets/notification_message.dart';

final editRegisterBookProvider = Provider((ref) {
  return (String registerBookId) async {
    final loading = ref.read(generalLoadingProvider.notifier);
    loading.state = true;

    final studentToEdit = await GetIt.I<RegisterBookServiceBase>().getOne(registerBookId);

    studentToEdit.onValue(
      withPopup: false,
      onError: (_, message) {
        loading.state = false;
        NotificationMessage.showSuccessNotification(message);
      },
      onSuccessfully: (data, _) {
        loading.state = false;
        ref.read(initialRegisterBookFormDataProvider.notifier).state = data;
        ref.read(tabMenuProvider.notifier).goTo(NawiMenuTabs.create);
        ref.read(selectableElementForCreateProvider.notifier).state = RegisterBook;
      }
    );
  };
});