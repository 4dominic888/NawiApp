import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/infrastructure/export/export_report_manager.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class RegisterBookExportByDate extends ExportReportManager {

  @override
  Widget builHeader(Context context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Cuaderno de registro en base a fechas', style: TextStyle().copyWith(fontWeight: FontWeight.bold, fontSize: 17)),
        Text('Página ${context.pageNumber}')
      ]
    );
  }

  @override
  List<Widget> buildContent(Context context, Iterable<RegisterBookSummary> data) {
    final dataOrderedPerDay = groupBy(
      data, (e) => NawiGeneralUtils.getFormattedDate(DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day))
    );

    return dataOrderedPerDay.entries.map((entry) => [
      Header(child: Text(entry.key, style: TextStyle().copyWith(fontWeight: FontWeight.bold))),

      ...entry.value.expand((element) => [
        Row(
          children: [
            Expanded(
              child: Container(
                color: const PdfColor.fromInt(0xe9e9e9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Bullet(text: element.action, textAlign: TextAlign.start),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            element.mentions.map((student) => student.name).join(', '),
                            style: TextStyle().copyWith(fontSize: 8, color: const PdfColor.fromInt(0x2e2e2e)),
                            textAlign: TextAlign.end
                          )
                        ),
                        SizedBox(width: 8.0)
                      ]
                    )
                  ]
                ),
              )
            ),

            SizedBox(width: 8.0),

            Text(
              DateFormat('hh:mm a').format(element.createdAt),
              style: const TextStyle().copyWith(fontSize: 12, color: PdfColor.fromInt(0xFF555555))
            )
          ]
        ),

        SizedBox(height: 4.0)
      ])
    ]).expand((e) => e).toList();
  }
}

class RegisterBookExportByStudent extends ExportReportManager {
  @override
  Widget builHeader(Context context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Cuaderno de registro ordenado por estudiante', style: TextStyle().copyWith(fontWeight: FontWeight.bold, fontSize: 17)),
        Text('Página ${context.pageNumber}')
      ]
    );
  }

  @override
  List<Widget> buildContent(Context context, Iterable<RegisterBookSummary> data) {

    final mapStudentRegisterBook = data.expand((rb) {
      if(rb.mentions.isEmpty) return [MapEntry(StudentSummary(id: '*', name: '[Sin registrar]', age: StudentAge.custom), rb)];
      return rb.mentions.map((s) => MapEntry(s, rb));
    });
    final dataOrderedByStudent = groupBy(mapStudentRegisterBook, (entry) => entry.key)
      .map((key, value) => MapEntry(key, value.map((e) => e.value)));

    return dataOrderedByStudent.entries.map((entry) => [
      Header(child: Text('${entry.key.name} (${entry.key.age.name})', style: TextStyle().copyWith(fontWeight: FontWeight.bold))),

      ...entry.value.expand((element) => [
        Row(
          children: [
            Expanded(
              child: Container(
                color: const PdfColor.fromInt(0xe9e9e9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Bullet(text: element.action, textAlign: TextAlign.start),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            NawiGeneralUtils.getFormattedDate(element.createdAt),
                            style: TextStyle().copyWith(fontSize: 8, color: const PdfColor.fromInt(0x2e2e2e)),
                            textAlign: TextAlign.end
                          )
                        ),
                        SizedBox(width: 8.0)
                      ]
                    )
                  ]
                ),
              )
            ),

            SizedBox(width: 8.0),

            Text(
              DateFormat('hh:mm a').format(element.createdAt),
              style: const TextStyle().copyWith(fontSize: 12, color: PdfColor.fromInt(0xFF555555))
            )
          ]
        ),

        SizedBox(height: 4.0)
      ])

    ]).expand((e) => e).toList();
  }

}