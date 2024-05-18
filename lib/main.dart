import 'object.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  runApp(const PdfViewerApp());
}

class PdfViewerApp extends StatelessWidget {
  const PdfViewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PDF Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange,
          errorColor: Colors.red,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const PdfViewerScreen(),
    );
  }
}

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  int _selectedIndex = 0;
  final _scrollController = ScrollController();
  final List<PdfInfo> _pdfTitles = [
    PdfInfo('1. 華光三部曲', '1.pdf'),
    PdfInfo('2. 孔孟老莊通覽圖', '2.pdf'),
    PdfInfo('3. 孫子兵法幫你贏', '3.pdf'),
    PdfInfo('4. 孔孟老莊一本通 + 演講連結', '4.pdf'),
    PdfInfo('5. 哈佛學法案例', '5.pdf'),
    PdfInfo('6. 決策一條龍', '6.pdf'),
    PdfInfo('7. 心知力解64卦', '7.pdf'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          color: Theme.of(context).colorScheme.surface,
          child: Scrollbar(
            thickness: 5,
            thumbVisibility: true,
            controller: _scrollController,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              itemCount: _pdfTitles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _pdfTitles[index].title,
                      style: TextStyle(
                        color: index == _selectedIndex ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: SfPdfViewer.asset(
        'assets/pdfs/${_pdfTitles[_selectedIndex].path}',
      ),
    );
  }
}
