import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nawiapp/domain/classes/stat_summary/register_book_stat.dart';
import 'package:nawiapp/presentation/features/select_classroom/widgets/indicator.dart';

class RegisterBookStatPieChart extends StatelessWidget {
  const RegisterBookStatPieChart({
    super.key,
    required this.screenWidth,
    required this.data,
  });

  final RegisterBookStat data;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final bool hasValue = switch([data.incidentCount.count, data.anecdoteCount.count, data.registerCount.count]) {
      [0, 0, 0] => false,
      _ => true
    };

    return hasValue ? Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Column(
          children: [
            const Text('Registros'),
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(PieChartData(sections: [
                    PieChartSectionData(
                      value: data.incidentCount.percent,
                      title: data.incidentCount.count.toString(),
                      color: Colors.red.shade200,
                    ),
                    PieChartSectionData(
                      value: data.anecdoteCount.percent,
                      title: data.anecdoteCount.count.toString(),
                      color: Colors.blue.shade200,
                    ),
                    PieChartSectionData(
                      value: data.registerCount.percent,
                      title: data.registerCount.count.toString(),
                      color: Colors.green.shade200,
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
              ),
            ),
          ],
        ),

        //* Leyeda
        Column(
          children: [
            Indicator(
              color: Colors.red.shade200,
              text: 'Incidentes',
              isSquare: false,
            ),
            Indicator(
              color: Colors.blue.shade200,
              text: 'Anécdotas',
              isSquare: false,
            ),
            Indicator(
              color: Colors.green.shade200,
              text: 'Registros',
              isSquare: false,
            ),
            Indicator(
              color: Colors.transparent,
              text: 'Total ${data.total}',
              isSquare: false,
              bold: false,
            )
          ],
        ),
      ],
    ) : 
    Align(
      alignment: Alignment.centerLeft,
      child: const Text('Sin registros...')
    );
  }

}