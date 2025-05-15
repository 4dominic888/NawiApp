import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/infrastructure/export/export_report_manager.dart';
import 'package:nawiapp/presentation/features/export/providers/initial_pdf_bytes_data_provider.dart';
import 'package:nawiapp/presentation/features/export/widgets/empty_export_widget.dart';
import 'package:nawiapp/presentation/widgets/notification_message.dart';
import 'package:pdfrx/pdfrx.dart';

class ExportScreen extends ConsumerWidget {
  const ExportScreen({ super.key });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final pdfData = ref.watch(initialPdfBytesDataProvider);

    if(pdfData == null) return const EmptyExportWidget();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              final fileResult = await ExportReportManager.saveToUserLocation(pdfData);
              fileResult.onValue(
                withPopup: false,
                onSuccessfully: (hasCreated, message) {
                  if(hasCreated) NotificationMessage.showSuccessNotification(message);
                },
                onError: (error, message) => NotificationMessage.showErrorNotification(message),
              );
            },
            child: const Text('Guardar en mi dispositivo')
          ),
        ),
        Expanded(
          child: PdfViewer.data(
            pdfData,
            sourceName: 'report_${DateTime.now().millisecondsSinceEpoch}.pdf',
            params: PdfViewerParams(
              enableTextSelection: true
            ),
          ),
        ),
      ],
    );
  }
}
