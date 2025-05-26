import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nawiapp/domain/classes/stat_summary/student_stat.dart';
import 'package:nawiapp/presentation/features/select_classroom/widgets/indicator.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class StudentAgeStatPieChart extends StatelessWidget {
  const StudentAgeStatPieChart({
    super.key,
    required this.screenWidth,
    required this.data
  });

  final double screenWidth;
  final StudentStat data;

  @override
  Widget build(BuildContext context) {
    final bool hasValue = switch([data.threeAgeCount.count, data.fourAgeCount.count, data.fiveAgeCount.count]) {
      [0,0,0] => false,
      _ => true
    };

    return hasValue ? Row(
      spacing: 10,
      children: [
        Column(
          children: [
            const Text('Estudiantes'),
            SizedBox(
              width: screenWidth,
              height: screenWidth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(PieChartData(sections: [
                    PieChartSectionData(
                      value: data.threeAgeCount.percent,
                      title: data.threeAgeCount.count.toString(),
                      color: NawiColorUtils.studentColorByAge(3, withOpacity: true)
                    ),
                      
                    PieChartSectionData(
                      value: data.fourAgeCount.percent,
                      title: data.fourAgeCount.count.toString(),
                      color: NawiColorUtils.studentColorByAge(4, withOpacity: true)
                    ),
                      
                    PieChartSectionData(
                      value: data.fiveAgeCount.percent,
                      title: data.fiveAgeCount.count.toString(),
                      color: NawiColorUtils.studentColorByAge(5, withOpacity: true)
                    ),
                  ])),
            
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Text(data.total.toString())
                  )
                ],
              )
            ),
          ],
        ),

        //* Leyenda
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Indicator(
              color: NawiColorUtils.studentColorByAge(3, withOpacity: true),
              text: '3 años',
              isSquare: false
            ),

            Indicator(
              color: NawiColorUtils.studentColorByAge(4, withOpacity: true),
              text: '4 años',
              isSquare: false
            ),

            Indicator(
              color: NawiColorUtils.studentColorByAge(5, withOpacity: true),
              text: '5 años',
              isSquare: false
            ),
          ],
        )
      ],
    ) : const SizedBox.shrink();
  }
}
