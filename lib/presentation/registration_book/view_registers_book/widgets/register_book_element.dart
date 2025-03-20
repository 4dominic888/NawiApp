import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/domain/models/register_book.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';

class RegisterBookElement extends StatelessWidget {
  const RegisterBookElement({
    super.key,
    required this.data,
    required this.index,
    // required this.deleteButton,
    // required this.archiveButton,
    // required this.unarchiveButton,
    this.isArchived = false
  });

  final RegisterBookDAO data;
  final int index;
  // final Widget deleteButton;
  // final Widget archiveButton;
  // final Widget unarchiveButton;
  final bool isArchived;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
      child: Dismissible(
        
        //TODO: cambiar por la clave o identificador real
        key: Key("-"),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if(direction == DismissDirection.startToEnd) {
            //* Action when edit
          }
          if(direction == DismissDirection.endToStart) {
            //* Action when delete
            //TODO: agregar un modal para confirmar la eliminacion.
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
          title: Text(data.action),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('dd/MM/y').format(data.createdAt)),
              Wrap(
                spacing: 10,
                children: (data.mentions).map((e) => 
                  Chip(
                    label: Text(e.name),
                    backgroundColor: NawiColor.iconColorMap(e.age.value),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold)
                  )).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}