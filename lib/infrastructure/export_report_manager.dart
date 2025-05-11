import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/infrastructure/fonts/open_sans_font.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

abstract class ExportReportManager {

  List<Widget> buildContent(Context context, Iterable<RegisterBookSummary> data);
  Widget builHeader(Context context);

  Future<Result<Document>> generate(RegisterBookFilter registerBookFilter) async {
    final dataExportResult = await GetIt.I<RegisterBookServiceBase>().getAll(registerBookFilter);
    if(dataExportResult is NawiError) return dataExportResult.getError()!;

    await GetIt.I.isReady<OpenSansFont>();
    final openSansFont = GetIt.I<OpenSansFont>();
    final data = dataExportResult.getValue!;
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        crossAxisAlignment: CrossAxisAlignment.center,
        theme: ThemeData(defaultTextStyle: TextStyle(
          fontNormal: openSansFont.regular,
          fontBold: openSansFont.bold,
          fontItalic: openSansFont.italic
        )),
        header: (context) => builHeader(context),
        build: (context) => buildContent(context, data),
      )
    );

    return Success(data: pdf);

  }

  Future<File> saveTemporaly(Document document) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/report_${DateFormat('ddMMyhhmm').format(DateTime.now())}.pdf');
    await file.writeAsBytes(await document.save());
    return file;
  }
  
  Future<File?> saveToUserLocation(Document document) async {
    final bytes = await document.save();
    final fileSaveLocation = await getSaveLocation(suggestedName: 'cuaderno_de_registro_reporte_${DateFormat('ddMMyhhmm').format(DateTime.now())}.pdf');
    if(fileSaveLocation == null) return null;
    final file = File(fileSaveLocation.path);
    await file.writeAsBytes(bytes);
    return file;
  }
}