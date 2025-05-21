import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';
import 'package:nawiapp/domain/services/classroom_service_base.dart';
import 'package:nawiapp/presentation/features/select_classroom/providers/select_classroom_grid_provider.dart';
import 'package:nawiapp/presentation/features/select_classroom/screens/add_classroom_modal.dart';
import 'package:nawiapp/presentation/widgets/loading_process_button.dart';
import 'package:nawiapp/presentation/widgets/warning_awesome_dialog.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class ClassroomElement extends StatelessWidget {

  final Classroom item;

  const ClassroomElement({ super.key, required this.item });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(IconData(item.iconCode, fontFamily: 'MaterialIcons')),
                SizedBox(
                  width: 200,
                  child: Text(item.name, overflow: TextOverflow.ellipsis)
                )
              ]
            ),

            //TODO Estadisticas info
            Placeholder(),

            Divider(),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Visitar aula')
                  ),
                ),
                _PopupClassroomOptions(item: item),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _PopupClassroomOptions extends ConsumerWidget {
  const _PopupClassroomOptions({
    required this.item,
  });

  final Classroom item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text('Editar'),
          onTap: () => Navigator.of(context).push(
            DialogRoute(context: context, builder: (_) => AddClassroomModal(data: item))
          ),
        ),
    
        PopupMenuItem(
          child: const Text('Eliminar'),
          onTap: () async {
            final deleteBtnController = RoundedLoadingButtonController();
            await WarningAwesomeDialog(
              title: "Confirmación de eliminación",
              desc: '¿Estás seguro/a que deseas eliminar esta aula? \n(Esta acción eliminará todos los estudiantes y registros dentro)',
              context: context,
              btnOk: LoadingProcessButton(
                controller: deleteBtnController,
                autoResetable: true,
                proccess: () async {
                  final result = await GetIt.I<ClassroomServiceBase>().deleteOne(item.id);
                  result.onValue(
                    onSuccessfully: (__, _) => deleteBtnController.success(),
                    onError: (__, _) => deleteBtnController.error(),
                  );
                  ref.read(classroomSearchProvider.notifier).refresh();
                  if(context.mounted) Navigator.of(context).pop();
                },
                color: Colors.redAccent.shade200,
                label: const Text("Eliminar", style: TextStyle(color: Colors.white))
              ),
            ).show();
          },
        )
      ],
    );
  }
}