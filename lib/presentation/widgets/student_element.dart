import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/mappers/student_mapper.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/presentation/features/create/providers/student/initial_student_form_data_provider.dart';
import 'package:nawiapp/presentation/features/create/providers/selectable_element_for_create_provider.dart';
import 'package:nawiapp/presentation/features/home/extra/menu_tabs.dart';
import 'package:nawiapp/presentation/features/home/providers/general_loading_provider.dart';
import 'package:nawiapp/presentation/features/home/providers/tab_index_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/register_book/search_register_book_list_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/selectable_element_for_search_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/student/search_student_list_provider.dart';
import 'package:nawiapp/presentation/widgets/delete_element_dialog.dart';
import 'package:nawiapp/presentation/widgets/notification_message.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class StudentElement extends StatelessWidget {

  final StudentSummary item;
  final bool isPreview;

  const StudentElement({ super.key, required this.item, this.isPreview = false});

  @override
  Widget build(BuildContext context) {

    final backgroundColor = NawiColorUtils.studentColorByAge(item.age.value, withOpacity: true);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor.withAlpha(20),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: backgroundColor.withAlpha(30),
          width: 1.5
        )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _StudentCircularAvatar(backgroundColor: backgroundColor, item: item),
          
          const SizedBox(width: 12),

          Expanded(child: _StudentElementInfo(item: item)),

          if(!isPreview) _StudentElementOptions(item: item)
        ],
      ),
    );
  }
}

class _StudentCircularAvatar extends ConsumerWidget {
  const _StudentCircularAvatar({
    required this.backgroundColor,
    required this.item,
  });

  final Color backgroundColor;
  final StudentSummary item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkResponse(
      containedInkWell: true,
      customBorder: const CircleBorder(),
      onTap: () {
        ref.read(registerBookFilterProvider.notifier).state = ref.read(registerBookFilterProvider.notifier).state.copyWith(searchByStudentsId: [item.id]);
        ref.read(selectableElementForSearchProvider.notifier).state = RegisterBook;
      },
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        child: Text(item.initalsName),
      ),
    );
  }
}

class _StudentElementOptions extends ConsumerWidget {
  const _StudentElementOptions({ required this.item });

  final StudentSummary item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: 10,
      children: [
        //* Editar
        IconButton(
          icon: const Icon(Icons.edit), style: Theme.of(context).elevatedButtonTheme.style,
          onPressed: () async {
            final loading = ref.read(generalLoadingProvider.notifier);
            loading.state = true;
        
            final studentToEdit = await GetIt.I<StudentServiceBase>().getOne(item.id);
        
            studentToEdit.onValue(
              withPopup: false,
              onError: (_, message) {
                loading.state = false;
                NotificationMessage.showErrorNotification(message);
              },
              onSuccessfully: (data, _) {
                loading.state = false;
        
                //* Ir al formulario de estudiante con el dato a editar
                ref.read(initialStudentFormDataProvider.notifier).state = data;
                ref.read(selectableElementForCreateProvider.notifier).state = Student;
                ref.read(tabMenuProvider.notifier).goTo(NawiMenuTabs.create);
              },
            );
          },
        ),

        //* Eliminar / Archivar
        IconButton(
          icon: const Icon(Icons.delete), style: Theme.of(context).elevatedButtonTheme.style,
          onPressed: () async {
            final service = GetIt.I<StudentServiceBase>();
            await DeleteElementAwesomeDialog(
              aboutDescription: "¿Estás seguro que deseas eliminar este estudiante? \n(Esta acción eliminará todos los registros relacionados al estudiante)",
              isArchived: ref.read(studentFilterProvider).showHidden,
              context: context,
              deleteAction: (() => service.deleteOne(item.id)),
              archieveAction: (() => service.archiveOne(item.id)),
              unarchieveAction: (() => service.unarchiveOne(item.id)),
              onActionSelected: () async {
                await ref.read(studentSummarySearchProvider.notifier).refresh();
                if(context.mounted) Navigator.of(context).pop();
              },
            ).show();
          },
        )
      ],
    );
  }
}

class _StudentElementInfo extends StatelessWidget {
  const _StudentElementInfo({ required this.item });

  final StudentSummary item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.name.isEmpty ? '<Sin nombre>' : item.name, style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis),
        Text(item.age.name, style: Theme.of(context).textTheme.titleSmall)
      ],
    );
  }
}