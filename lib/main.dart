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
  final List<PdfInfo> _pdfTitles = [
    PdfInfo(path: '1.pdf', title: '1. 華光三部曲', pdfViewerController: PdfViewerController()),
    PdfInfo(path: '2.pdf', title: '2. 孔孟老莊通覽圖', pdfViewerController: PdfViewerController()),
    PdfInfo(path: '3.pdf', title: '3. 孫子兵法幫你贏', pdfViewerController: PdfViewerController()),
    PdfInfo(path: '4.pdf', title: '4. 孔孟老莊一本通 + 演講連結', pdfViewerController: PdfViewerController()),
    PdfInfo(path: '5.pdf', title: '5. 哈佛學法案例', pdfViewerController: PdfViewerController()),
    PdfInfo(path: '6.pdf', title: '6. 決策一條龍', pdfViewerController: PdfViewerController()),
    PdfInfo(path: '7.pdf', title: '7. 心知力解64卦', pdfViewerController: PdfViewerController()),
  ];
  final Map<String, String> links = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pdfViewing = _pdfTitles[_selectedIndex];
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 0
            ? const Text('易經 今解')
            : _selectedIndex == 1
                ? const Text('連結')
                : Text(_pdfTitles[_selectedIndex - 2].title),
        actions: [
          IconButton(
            icon: Icon(Icons.zoom_in, color: pdfViewing.pdfViewerController.zoomLevel == 5 ? Colors.grey : Colors.black),
            onPressed: () {
              if (pdfViewing.pdfViewerController.zoomLevel < 5) {
                pdfViewing.pdfViewerController.zoomLevel += 1;
              }
              setState(() {});
            },
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.zoom_out, color: pdfViewing.pdfViewerController.zoomLevel == 1 ? Colors.grey : Colors.black),
            onPressed: () {
              if (pdfViewing.pdfViewerController.zoomLevel > 1) pdfViewing.pdfViewerController.zoomLevel -= 1;
              setState(() {});
            },
          ),
          const SizedBox(width: 10),
          DropdownButton<int>(
            value: pdfViewing.pdfViewerController.pageNumber,
            underline: Container(),
            items: List.generate(
              pdfViewing.pdfViewerController.pageCount,
              (index) => DropdownMenuItem(
                value: index + 1,
                child: Text('Page ${index + 1}'),
              ),
            ),
            onChanged: (int? value) {
              setState(() {
                if (value != null) {
                  pdfViewing.pdfViewerController.jumpToPage(value);
                }
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('易經 今解'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('連結'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ...List.generate(
              _pdfTitles.length,
              (index) => ListTile(
                title: Text(_pdfTitles[index].title),
                selected: index == _selectedIndex,
                onTap: () {
                  setState(() {
                    _selectedIndex = index + 2;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Center(
            child: Image.asset(
              'assets/images/professor.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
            ),
          ),
          ListView.builder(
            itemCount: links.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Text(links.keys.elementAt(index)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(links.values.elementAt(index)),
                  ),
                ],
              );
            },
          ),
          ...List.generate(
            _pdfTitles.length,
            (index) => SfPdfViewer.asset(
              'assets/pdfs/${_pdfTitles[index].path}',
              controller: _pdfTitles[index].pdfViewerController,
              maxZoomLevel: 5,
              enableDoubleTapZooming: true,
              pageLayoutMode: PdfPageLayoutMode.single,
              interactionMode: PdfInteractionMode.pan,
            ),
          ),
        ],
      ),
    );
  }
}

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
