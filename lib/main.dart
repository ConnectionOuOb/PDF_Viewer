import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final List<LinkInfo> links = [
    LinkInfo(title: 'HBR Ball', url: 'http://140.113.72.120/caseball/examples/caseball.html'),
    LinkInfo(title: '管理學家', url: 'http://140.113.72.120/ManagstBall/examples/gbball.html'),
    LinkInfo(title: '西洋藝術球', url: 'http://140.113.72.120/Artball/Art_ball/gookon/examples/index.html'),
    LinkInfo(title: '電影球', url: 'http://140.113.72.120/MovieBall/examples/movieball.html'),
    LinkInfo(title: '易孔孟老莊', url: 'http://140.113.72.119/gbball/examples/I_Ching.html'),
    LinkInfo(title: '莊子通覽圖網站', url: 'https://connectionouob.github.io/zhuangzi/'),
    LinkInfo(title: '易方陣網站', url: 'https://connectionouob.github.io/YiFangJhen/'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int nowPDF = _selectedIndex - 2;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: _selectedIndex == 0
            ? const Text('易經 今解')
            : _selectedIndex == 1
                ? const Text('連結')
                : Text(_pdfTitles[nowPDF].title),
        actions: _selectedIndex > 1
            ? [
                IconButton(
                  icon: Icon(Icons.zoom_in, color: _pdfTitles[nowPDF].pdfViewerController.zoomLevel == 5 ? Colors.grey : Colors.black),
                  onPressed: () {
                    if (_pdfTitles[nowPDF].pdfViewerController.zoomLevel < 5) {
                      _pdfTitles[nowPDF].pdfViewerController.zoomLevel += 1;
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.zoom_out, color: _pdfTitles[nowPDF].pdfViewerController.zoomLevel == 1 ? Colors.grey : Colors.black),
                  onPressed: () {
                    if (_pdfTitles[nowPDF].pdfViewerController.zoomLevel > 1) _pdfTitles[nowPDF].pdfViewerController.zoomLevel -= 1;
                    setState(() {});
                  },
                ),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: _pdfTitles[nowPDF].pdfViewerController.pageNumber,
                  underline: Container(),
                  items: List.generate(
                    _pdfTitles[nowPDF].pdfViewerController.pageCount,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text('Page ${index + 1}'),
                    ),
                  ),
                  onChanged: (int? value) {
                    setState(() {
                      if (value != null) {
                        _pdfTitles[nowPDF].pdfViewerController.jumpToPage(value);
                      }
                    });
                  },
                ),
                const SizedBox(width: 10),
              ]
            : [],
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
          Container(
            padding: const EdgeInsets.all(80),
            alignment: Alignment.center,
            child: Table(
              border: TableBorder.all(),
              children: [
                const TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          '網站標題',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          '網站連結',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                ...links.map(
                  (e) => TableRow(
                    children: [
                      TableCell(child: Padding(padding: const EdgeInsets.all(20), child: Text(e.title, style: const TextStyle(fontSize: 20)))),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse(e.url));
                            },
                            child: Text(
                              e.url,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

class LinkInfo {
  final String title;
  final String url;

  LinkInfo({required this.title, required this.url});
}
