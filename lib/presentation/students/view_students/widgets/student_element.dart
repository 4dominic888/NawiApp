import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';
import 'package:nawiapp/presentation/students/add_students/screens/add_students_screen.dart';
import 'package:nawiapp/presentation/widgets/loading_process_button.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

typedef ButtonControllerWithProcess = ({
  RoundedLoadingButtonController controller,
  Future<void> Function() action
});

class StudentElement extends StatelessWidget {
  const StudentElement({
    super.key,
    required this.item,
    required this.index,
    required this.delete,
    required this.archive,
    required this.unarchive,
    this.isArchived = false
  });

  final StudentDAO item;
  final int index;
  final ButtonControllerWithProcess delete;
  final ButtonControllerWithProcess archive;
  final ButtonControllerWithProcess unarchive;
  final bool isArchived;

  @override
  Widget build(BuildContext context) {
    final colorTile = (!isArchived ? Colors.grey : Colors.deepOrange).shade200;
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Dismissible(
          key: Key("-"),
          direction: DismissDirection.horizontal,
          confirmDismiss: (direction) async {
            //* Edit
            if(direction == DismissDirection.startToEnd) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AddStudentsScreen(idToEdit: item.id)));
              return false;
            }

            //* Delete, archive or unarchive
            if(direction == DismissDirection.endToStart) {
              await AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                headerAnimationLoop: false,
                showCloseIcon: true,
                closeIcon: const Icon(Icons.close),
                animType: AnimType.scale,
                title: "Confirmación de eliminación",
                desc: "¿Estás seguro que deseas eliminar este estudiante? (Esta acción eliminará todos los registros relacionados)"
                "\n\nCaso contrario, ${!isArchived ? "¿Archivarlo?" : "¿Desarchivarlo?"}",
                btnOk: LoadingProcessButton(
                  controller: delete.controller,
                  proccess: delete.action,
                  label: Text("Eliminar", style: TextStyle(color: Colors.white)),
                  color: Colors.redAccent.shade200
                ),
                btnCancel: !isArchived ? 
                  LoadingProcessButton(
                    controller: archive.controller,
                    proccess: archive.action,
                    label: Text("Archivar", style: TextStyle(color: Colors.white)),
                    color: Colors.orangeAccent.shade200
                  ) :
                  LoadingProcessButton(
                    controller: unarchive.controller,
                    proccess: unarchive.action,
                    label: const Text("Desarchivar", style: TextStyle(color: Colors.white)),
                    color: Colors.green.shade200,
                  )
              ).show();
              return false;
            }
            return false;
          },
          background: Container(
            color: Colors.cyan.shade300,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20),
            child: Icon(Icons.edit, color: Colors.white)
          ),
          secondaryBackground: Container(
            color: (!isArchived ? Colors.red : Colors.orange).shade400,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(left: 20),
            child: Icon(!isArchived ? Icons.delete : Icons.restore, color: Colors.white)
          ),
          child: ListTile(
            title: Text(item.name),
            subtitle: Text(item.age.name),
            tileColor: index % 2 == 0 ? colorTile.withAlpha(80) : colorTile.withAlpha(100),
            leading: CircleAvatar(
              backgroundColor: NawiColor.iconColorMap(item.age.value, withOpacity: true),
              child: Icon(Icons.person, color: NawiColor.iconColorMap(item.age.value)),
            ),
          ),
        ),
      ),
    );
  }
}