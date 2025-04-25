import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/mappers/student_mapper.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/presentation/features/create/providers/initial_student_form_data_provider.dart';
import 'package:nawiapp/presentation/features/create/providers/selectable_element_for_create_provider.dart';
import 'package:nawiapp/presentation/features/home/providers/tab_index_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/general_loading_search_student_provider.dart';
import 'package:nawiapp/presentation/widgets/notification_message.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class AnotherStudentElement extends ConsumerWidget {

  final StudentSummary item;
  final bool isPreview;

  const AnotherStudentElement({ super.key, required this.item, this.isPreview = false });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final backgroundColor = NawiColorUtils.studentColorByAge(item.age.value, withOpacity: true);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: backgroundColor.withAlpha(30),
          width: 1.5
        )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: backgroundColor,
            child: Text(item.initalsName),
          ),
          
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                Text(item.age.name, style: Theme.of(context).textTheme.titleSmall)
              ],
            )
          ),

          if(!isPreview) ...[
            IconButton(
              icon: const Icon(Icons.edit), style: Theme.of(context).elevatedButtonTheme.style,
              onPressed: () async {
                final loading = ref.read(generalLoadingSearchStudentProvider.notifier);
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
                    ref.read(tabIndexProvider.notifier).goCreate();
                  },
                );
              },
            ),

            IconButton(
              icon: const Icon(Icons.delete), style: Theme.of(context).elevatedButtonTheme.style,
              onPressed: () {

              },
            )
          ]

        ],
      ),
    );
  }
}