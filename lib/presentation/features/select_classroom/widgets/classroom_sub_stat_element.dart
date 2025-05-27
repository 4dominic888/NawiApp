import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';
import 'package:nawiapp/presentation/features/search/providers/register_book/count_register_book_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/student/count_student_provider.dart';
import 'package:nawiapp/presentation/features/select_classroom/widgets/register_book_stat_pie_chart.dart';
import 'package:nawiapp/presentation/features/select_classroom/widgets/student_age_stat_pie_chart.dart';

class ClassroomSubStatElement extends ConsumerWidget {
  const ClassroomSubStatElement({
    super.key,
    required this.item,
  });

  final Classroom item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final studentStat = ref.watch(studentStatProvider(item.id));
    final registerBookStat = ref.watch(registerBookStatProvider(item.id));

    final screenWidth = MediaQuery.of(context).size.width / 5.5;

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        runSpacing: 20,
        spacing: 20,
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceAround,
        children: [
      
          studentStat.when(
            data: (data) => StudentAgeStatPieChart(screenWidth: screenWidth, data: data),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('No se ha podido recuperar la información'),
          ),
      
          registerBookStat.when(
            data: (data) => RegisterBookStatPieChart(screenWidth: screenWidth, data: data),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('No se ha podido recuperar la información'),
          ),
        ],
      ),
    );
  }
}