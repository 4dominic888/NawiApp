import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/infrastructure/export_report_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class RegisterBookExport extends ExportReportManager {
  @override
  Future<Result<Document>> generate(RegisterBookFilter registerBookFilter) async {
    final dataExportResult = await GetIt.I<RegisterBookServiceBase>().getAll(registerBookFilter);
    if(dataExportResult is NawiError) return dataExportResult.getError()!;

    final data = dataExportResult.getValue!;

    final pdf = Document();
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        crossAxisAlignment: CrossAxisAlignment.center,
        build: (context) {
          final dataOrderedPerDay = groupBy(
            data, (e) => DateFormat('EEEE, d MMMM y').format(DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day))
          );

          return dataOrderedPerDay.entries.map((entry) => [
            Header(child: Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold))),

            ...entry.value.expand((element) => [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: const PdfColor.fromInt(0xe9e9e9),
                      child: Bullet(text: element.action),
                    )
                  ),

                  SizedBox(width: 8.0),

                  Text(
                    DateFormat('hh:mm a').format(element.createdAt),
                    style: const TextStyle(fontSize: 12, color: PdfColor.fromInt(0xFF555555))
                  )
                ]
              ),

              SizedBox(height: 4.0)
            ])
          ]).expand((e) => e).toList();
        },
      )
    );

    return Success(data: pdf);
  }
}