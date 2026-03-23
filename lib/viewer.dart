import 'object.dart';
import 'package:flutter/material.dart';
import 'image.dart';

class BookPageViewer extends StatefulWidget {
  final BookInfo book;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;

  const BookPageViewer({
    super.key,
    required this.book,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  State<BookPageViewer> createState() => _BookPageViewerState();
}

class _BookPageViewerState extends State<BookPageViewer> {
  // 每頁獨立的縮放控制器，切換頁面時重置縮放
  final Map<int, TransformationController> _transformControllers = {};

  TransformationController _controllerFor(int pageIndex) {
    return _transformControllers.putIfAbsent(
      pageIndex,
      () => TransformationController(),
    );
  }

  @override
  void dispose() {
    for (final c in _transformControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.pageController,
      itemCount: widget.book.pageCount,
      physics: const ClampingScrollPhysics(),
      onPageChanged: (index) => widget.onPageChanged(index + 1),
      itemBuilder: (context, index) {
        final assetPath = 'assets/images/${widget.book.id}/${index + 1}.png';
        final transformCtrl = _controllerFor(index);

        return GestureDetector(
          onDoubleTapDown: (details) {
            // 雙點放大：若已放大則恢復原始比例
            if (transformCtrl.value != Matrix4.identity()) {
              transformCtrl.value = Matrix4.identity();
            } else {
              final position = details.localPosition;
              transformCtrl.value = Matrix4.identity()
                ..translate(-position.dx * 1.5, -position.dy * 1.5)
                ..scale(2.5);
            }
          },
          child: InteractiveViewer(
            transformationController: transformCtrl,
            minScale: 1.0,
            maxScale: 5.0,
            child: ProgressiveImage(assetPath: assetPath),
          ),
        );
      },
    );
  }
}
