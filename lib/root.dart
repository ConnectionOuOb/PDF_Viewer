import 'define.dart';
import 'page20.dart';
import 'viewer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const Text page20Title = Text('19. 喫茶易');

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  late final List<PageController?> _pageControllers;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageControllers = books.map((b) => b.pageCount > 0 ? PageController() : null).toList();
  }

  @override
  void dispose() {
    for (final c in _pageControllers) {
      c?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final int bookIndex = _selectedIndex - 2;
    final bool isBookView = _selectedIndex > 1 && _selectedIndex < 20;
    final int numPages = isBookView ? books[bookIndex].pageCount : 0;
    final bool bookHasPages = isBookView && numPages > 0;
    final bool notSinglePageBook = numPages != 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade100,
        title: _selectedIndex == 0
            ? const Text('知識通覧法（Hippocampus maps)')
            : _selectedIndex == 1
                ? const Text('連結')
                : _selectedIndex == 20
                    ? page20Title
                : Text(books[bookIndex].title),
        actions: bookHasPages && notSinglePageBook
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: DropdownButton<int>(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    borderRadius: BorderRadius.circular(10),
                    value: books[bookIndex].currentPage,
                    underline: Container(),
                    items: List.generate(
                      numPages,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text('Page ${index + 1}'),
                      ),
                    ),
                    onChanged: (int? value) {
                      if (value != null) {
                        _pageControllers[bookIndex]?.jumpToPage(value - 1);
                      }
                    },
                  ),
                ),
              ]
            : [],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('易經 今解'),
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('連結'),
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ...List.generate(
              books.length,
              (index) => ListTile(
                title: Text(books[index].title),
                onTap: () {
                  setState(() => _selectedIndex = index + 2);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: page20Title,
              onTap: () {
                setState(() => _selectedIndex = 20);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return Center(
        child: Image.asset(
          'assets/images/professor.jpg',
          fit: BoxFit.cover,
          height: double.infinity,
        ),
      );
    } else if (_selectedIndex == 1) {
      return _buildLinksTable();
    } else if (_selectedIndex == 20) {
      return Page20();
    } else {
      final int bookIndex = _selectedIndex - 2;
      final book = books[bookIndex];

      if (book.pageCount == 0) {
        return const Center(
          child: Text(
            '此書籍尚未轉換，敬請期待',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        );
      }

      return BookPageViewer(
        book: book,
        pageController: _pageControllers[bookIndex]!,
        onPageChanged: (page) {
          setState(() => book.currentPage = page);
        },
      );
    }
  }

  Widget _buildLinksTable() {
    return Container(
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
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(e.title, style: const TextStyle(fontSize: 20)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () => launchUrl(Uri.parse(e.url)),
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
    );
  }
}
