import 'package:flutter/material.dart';
import 'package:nawiapp/data/mappers/student_mapper.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class AnotherStudentElement extends StatelessWidget {

  final StudentSummary item;

  const AnotherStudentElement({ super.key, required this.item });

  @override
  Widget build(BuildContext context) {
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
                Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                Text(item.age.name, style: Theme.of(context).textTheme.titleSmall)
              ],
            )
          ),

          IconButton(onPressed: () {}, icon: const Icon(Icons.edit), style: Theme.of(context).elevatedButtonTheme.style),
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete), style: Theme.of(context).elevatedButtonTheme.style)
        ],
      ),
    );
  }
}