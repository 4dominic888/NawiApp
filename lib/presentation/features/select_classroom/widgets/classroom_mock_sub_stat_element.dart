import 'package:flutter/material.dart';
import 'package:nawiapp/domain/classes/count_ratio.dart';
import 'package:nawiapp/domain/classes/stat_summary/register_book_stat.dart';
import 'package:nawiapp/domain/classes/stat_summary/student_stat.dart';
import 'package:nawiapp/presentation/features/select_classroom/widgets/register_book_stat_pie_chart.dart';
import 'package:nawiapp/presentation/features/select_classroom/widgets/student_age_stat_pie_chart.dart';

class ClassroomMockSubStatElement extends StatelessWidget {
  const ClassroomMockSubStatElement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width / 5.5;

    const mockStudentStat = StudentStat(
      fiveAgeCount: CountRatio(count: 5, percent: 0.5),
      fourAgeCount: CountRatio(count: 4, percent: 0.4),
      threeAgeCount: CountRatio(count: 1, percent: 0.1),
      total: 10
    );

    const mockRegisterBookStat = RegisterBookStat(
      anecdoteCount: CountRatio(count: 2, percent: 0.30),
      registerCount: CountRatio(count: 2, percent: 0.30),
      incidentCount: CountRatio(count: 1, percent: 0.20),
      total: 5
    );

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        runSpacing: 20,
        spacing: 20,
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceAround,
        children: [
          StudentAgeStatPieChart(screenWidth: screenWidth, data: mockStudentStat),
          RegisterBookStatPieChart(screenWidth: screenWidth, data: mockRegisterBookStat),
        ],
      ),
    );
  }
}