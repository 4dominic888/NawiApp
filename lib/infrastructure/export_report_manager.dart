import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

abstract class ExportReportManager {
  Future<Result<Document>> generate(RegisterBookFilter registerBookFilter);

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