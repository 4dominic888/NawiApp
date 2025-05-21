import 'package:flutter/material.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';
import 'package:nawiapp/presentation/features/select_classroom/screens/add_classroom_modal.dart';

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Icon(IconData(item.iconCode, fontFamily: 'MaterialIcons')),
                Text(item.name, overflow: TextOverflow.ellipsis),
                IconButton(
                  onPressed: () {
                    
                  },
                  icon: const Icon(Icons.play_circle_fill_outlined)
                )
              ],
            ),

            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Editar'),
                  onTap: () => Navigator.of(context).push(
                    DialogRoute(context: context, builder: (_) => AddClassroomModal(data: item))
                  ),
                ),

                PopupMenuItem(
                  child: const Text('Eliminar'),
                  onTap: () {
                    
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}