import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/mappers/student_mapper.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/presentation/features/create/providers/student/edit_student_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/register_book/search_register_book_list_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/selectable_element_for_search_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/student/search_student_list_provider.dart';
import 'package:nawiapp/presentation/widgets/delete_element_dialog.dart';
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
        color: backgroundColor.withAlpha(40),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: backgroundColor.withAlpha(30),
          width: 1.5
        )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _StudentCircularAvatar(backgroundColor: backgroundColor, item: item, isPreview: isPreview),
          
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
    this.isPreview = false
  });

  final Color backgroundColor;
  final StudentSummary item;
  final bool isPreview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkResponse(
      containedInkWell: true,
      customBorder: const CircleBorder(),
      onTap: !isPreview ? () {
        ref.read(registerBookFilterProvider.notifier).state = ref.read(registerBookFilterProvider.notifier).state.copyWith(searchByStudentsId: [item.id]);
        ref.read(selectableElementForSearchProvider.notifier).state = RegisterBook;
      } : null,
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
          onPressed: () => ref.read(editStudentProvider)(item.id),
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