import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/data/mappers/register_book_mapper.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/presentation/features/create/providers/register_book/initial_register_book_form_data_provider.dart';
import 'package:nawiapp/presentation/features/create/providers/selectable_element_for_create_provider.dart';
import 'package:nawiapp/presentation/features/home/extra/menu_tabs.dart';
import 'package:nawiapp/presentation/features/home/providers/tab_index_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/register_book/search_register_book_list_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/student/general_loading_search_student_provider.dart';
import 'package:nawiapp/presentation/widgets/delete_element_dialog.dart';
import 'package:nawiapp/presentation/widgets/notification_message.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class AnotherRegisterBookElement extends StatelessWidget {

  final RegisterBookSummary item;
  final bool isPreview;

  const AnotherRegisterBookElement({ super.key, required this.item, this.isPreview = false });

  @override
  Widget build(BuildContext context) {

    return Card(
      child: ListTile(
        title: Text(item.actionUnslug),
        trailing: 
        Column(
          children: [
            switch (item.type) {
              RegisterBookType.register => const Icon(Icons.app_registration_rounded),
              RegisterBookType.incident => const Icon(Icons.warning),
              RegisterBookType.anecdotal => const Icon(Icons.star)
            },
            Text(item.type.name),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('dd/MM/y hh:mm a').format(item.createdAt)),

            if(!isPreview) _RegisterBookElementOptions(item: item),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Wrap(
                spacing: 10,
                children: (item.mentions.toSet()).map((student) => 
                  Chip(
                    label: Text(student.name, style: const TextStyle(fontSize: 10)),
                    backgroundColor: NawiColorUtils.studentColorByAge(student.age.value).withAlpha(80),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold)
                  )
                ).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _RegisterBookElementOptions extends ConsumerWidget {

  final RegisterBookSummary item;

  const _RegisterBookElementOptions({ required this.item });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      children: [
        //* Editar
        IconButton(
          icon: const Icon(Icons.edit), style: Theme.of(context).elevatedButtonTheme.style,
          onPressed: () async {
            final loading = ref.read(generalLoadingSearchStudentProvider.notifier);
            loading.state = true;

            final studentToEdit = await GetIt.I<RegisterBookServiceBase>().getOne(item.id);

            studentToEdit.onValue(
              withPopup: false,
              onError: (_, message) {
                loading.state = false;
                NotificationMessage.showSuccessNotification(message);
              },
              onSuccessfully: (data, _) {
                loading.state = false;
                ref.read(initialRegisterBookFormDataProvider.notifier).state = data;
                ref.read(selectableElementForCreateProvider.notifier).state = RegisterBook;
                ref.read(tabMenuProvider.notifier).goTo(NawiMenuTabs.create);
              }
            );
          },
        ),

        //* Eliminar / Archivar
        IconButton(
          icon: const Icon(Icons.delete), style: Theme.of(context).elevatedButtonTheme.style,
          onPressed: () async {
            final service = GetIt.I<RegisterBookServiceBase>();
            await DeleteElementAwesomeDialog(
              context: context,
              aboutDescription: "¿Estás seguro que deseas eliminar este registro?",
              isArchived: ref.read(registerBookFilterProvider).showHidden,
              deleteAction: (() => service.deleteOne(item.id)),
              archieveAction: (() => service.archiveOne(item.id)),
              unarchieveAction: (() => service.unarchiveOne(item.id)),
              onActionSelected: () async {
                if(context.mounted) Navigator.of(context).pop();
                ref.read(registerBookSummarySearchProvider.notifier).refresh();
              }
            ).show();
          },
        )
      ],
    );
  }
}