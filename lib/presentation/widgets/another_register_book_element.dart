import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/data/mappers/register_book_mapper.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class AnotherRegisterBookElement extends StatelessWidget {

  final RegisterBookSummary item;

  const AnotherRegisterBookElement({ super.key, required this.item });

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
            Text(item.type.name)
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('dd/MM/y hh:mm a').format(item.createdAt)),
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