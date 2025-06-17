import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nawiapp/data/local/views/register_book_view.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/infrastructure/export/export_report_manager.dart';
import 'package:nawiapp/infrastructure/export/register_book_export.dart';

import '../nawi_test_utils.dart' as testil;

void main() {
  setUp(() async => await testil.setupIntegrationTestLocator(withRegisterBook: true));
  tearDown(testil.onTearDownSetupIntegrationTestLocator);  
  test("Correcta estructura de pdf", () async {
    final query = RegisterBookFilter(orderBy: RegisterBookViewOrderByType.timestampOldy, classroomId: '6615024f-0153-4492-b06e-0cb108f90ac6');
    final ExportReportManager exporter = RegisterBookExportByDate();
    
    final result = await exporter.generate(query);
    testil.customExpect(result, isA<Success>(),
      about: "Query valida", n: 1
    );

    final doc = result.getValue!;

    final outputDir = Directory('test/pdf_test_output');
    if(!await outputDir.exists()) await outputDir.create(recursive: true);

    final outputFile = File('${outputDir.path}/report.pdf');
    await outputFile.writeAsBytes(await doc.save());

    testil.customExpect(await outputFile.exists(), isTrue,
      about: "PDF generado", n: 2
    );

    testil.customExpect(await outputFile.length(), greaterThan(0),
      about: "PDF con datos", n: 2
    );
    
  });
}