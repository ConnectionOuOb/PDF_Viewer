import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange,
          errorColor: Colors.red,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<String> _pdfTitles = [
    '華光三部曲',
    '孔孟老莊通覽圖',
    '孫子兵法幫你贏',
    '孔孟老莊一本通＋演講連結',
    '哈佛學法案例',
    '決策一條龍',
    '心知力解64卦',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _pdfTitles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_pdfTitles[index]),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: PDFView(
              filePath: 'assets/pdfs/${_pdfTitles[_currentIndex]}.pdf',
            ),
          ),
        ],
      ),
    );
  }
}
