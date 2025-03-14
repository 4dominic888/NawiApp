import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';
import 'package:nawiapp/presentation/students/add_students/screens/add_students_screen.dart';

class StudentElement extends StatelessWidget {
  const StudentElement({
    super.key,
    required this.context,
    required this.item,
    required this.index,
    required this.deleteButton,
    required this.archiveButton
  });

  final BuildContext context;
  final StudentDAO item;
  final int index;
  final Widget deleteButton;
  final Widget archiveButton;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Dismissible(
          key: Key("-"),
          direction: DismissDirection.horizontal,
          confirmDismiss: (direction) async {
            if(direction == DismissDirection.startToEnd) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AddStudentsScreen(idToEdit: item.id)));
              return false;
            }
            if(direction == DismissDirection.endToStart) {
              await AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                headerAnimationLoop: false,
                showCloseIcon: true,
                closeIcon: const Icon(Icons.close),
                animType: AnimType.scale,
                title: "Confirmación de eliminación",
                desc: "¿Estás seguro que deseas eliminar este estudiante? (Esta acción eliminará todos los registros relacionados) \n\nCaso contrario, ¿Archivarlo?",
                btnOk: deleteButton,
                btnCancel: archiveButton
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
            color: Colors.red.shade400,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(left: 20),
            child: Icon(Icons.delete, color: Colors.white)              
          ),
          child: ListTile(
            title: Text(item.name),
            subtitle: Text(item.age.name),
            tileColor: index % 2 == 0 ?Colors.grey.shade200.withAlpha(80) : Colors.grey.shade200.withAlpha(100),
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