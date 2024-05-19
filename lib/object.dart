import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfInfo {
  final String title;
  final String path;
  PdfViewerController pdfViewerController;

  PdfInfo({
    required this.title,
    required this.path,
    required this.pdfViewerController,
  });
}
