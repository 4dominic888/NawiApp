import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/data/mappers/register_book_mapper.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/domain/records/button_controller_with_process.dart';
import 'package:nawiapp/presentation/registration_book/add_registers_book/screens/add_register_book_screen.dart';
import 'package:nawiapp/presentation/widgets/loading_process_button.dart';
import 'package:nawiapp/presentation/widgets/warning_awesome_dialog.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class RegisterBookElement extends StatelessWidget {
  const RegisterBookElement({
    super.key,
    required this.item,
    required this.delete,
    required this.archive,
    required this.unarchive,
    this.isArchived = false
  });

  final RegisterBookSummary item;
  final ButtonControllerWithProcess delete;
  final ButtonControllerWithProcess archive;
  final ButtonControllerWithProcess unarchive;
  final bool isArchived;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
      child: Dismissible(        
        key: Key(item.id),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if(direction == DismissDirection.startToEnd) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AddRegisterBookScreen(idToEdit: item.id)));
          }
          if(direction == DismissDirection.endToStart) {
            await WarningAwesomeDialog(
              context: context,
              title: "Confirmación de eliminación",
              desc: "¿Estás seguro que deseas eliminar este registro? (Esta acción eliminará todos los registros relacionados)"
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
          title: Text(item.actionUnslug),
          trailing: 
          Column(
            children: [
              switch (item.type) {
                RegisterBookType.register => const Icon(Icons.app_registration_rounded),
                RegisterBookType.incident => const Icon(Icons.warning),
                RegisterBookType.anecdotal => const Icon(Icons.star)
              },
              Text(item.type.name)
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('dd/MM/y hh:mm a').format(item.createdAt)),
              Wrap(
                spacing: 10,
                children: (item.mentions.toSet()).map((student) => 
                  Chip(
                    label: Text(student.name),
                    backgroundColor: NawiColorUtils.studentColorByAge(student.age.value).withAlpha(80),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold)
                  )
                ).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}