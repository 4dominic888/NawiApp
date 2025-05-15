import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/infrastructure/fonts/open_sans_font.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

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

  Future<Uint8List> getBytes(Document document) async => await document.save();
  
  static Future<Result<bool>> saveToUserLocation(Uint8List bytes) async {
    try {
      final fileSaveLocation = await FilePicker.platform.saveFile(
        dialogTitle: 'Selecciona un directorio para guardar el reporte',
        fileName: 'cuaderno_de_registro_reporte_${DateFormat('ddMMyhhmm').format(DateTime.now())}.pdf',
        initialDirectory: (await path_provider.getApplicationDocumentsDirectory()).path,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        bytes: bytes,
      );
      
      if(fileSaveLocation == null) return Success(data: false);
      return Success(data: true, message: 'Se ha guardado el archivo correctamente');
    } catch (e) { return NawiError.onPresentation(message: e.toString()); }
  }
}