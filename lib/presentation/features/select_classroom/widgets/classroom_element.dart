import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom_status.dart';

class ClassroomElement extends StatelessWidget {

  final Classroom item;

  const ClassroomElement({ super.key, required this.item });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.name.isEmpty ? '[Sin nombre]' : item.name),
        trailing: Column(
          children: [
            switch (item.status) {
              ClassroomStatus.notStarted => const Icon(Icons.watch_later_outlined),
              ClassroomStatus.inProgress => const Icon(Icons.timeline),
              ClassroomStatus.ended => const Icon(Icons.done),
            },
            Text(item.status.name)
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ClassroomElementOptions(item: item),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(item.description ?? ''),
            )
          ],
        ),
      ),
    );
  }
}

class _ClassroomElementOptions extends ConsumerWidget {
  final Classroom item;

  const _ClassroomElementOptions({ required this.item });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      children: [
        IconButton(
          icon: const Icon(Icons.edit), style: Theme.of(context).elevatedButtonTheme.style,
          onPressed: () async {

          },
        ),

        IconButton(
          icon: const Icon(Icons.delete), style: Theme.of(context).elevatedButtonTheme.style,
          onPressed: () async {

          }
        )
      ],
    );
  }
}