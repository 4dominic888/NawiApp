import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';
import 'package:nawiapp/presentation/features/search/providers/register_book/count_register_book_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/student/count_student_provider.dart';

class StatElement extends ConsumerWidget {
  const StatElement({
    super.key,
    required this.item,
  });

  final Classroom item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final studentCount = ref.watch(countStudentProvider(item.id));

    final registerBookCount = ref.watch(countRegisterBookProvider(item.id));

    return Wrap(
      spacing: 10,
      direction: Axis.vertical,
      children: [
        Text('Cantidad de estudiantes: ${studentCount.when(
          data: (data) => data,
          error: (_, __) => '0',
          loading: () => '-'
        )}'),

        Text('Cantidad de registros: ${registerBookCount.when(
          data: (data) => data,
          error: (_, __) => '0',
          loading: () => '-'
        )}'),
      ],
    );
  }
}
