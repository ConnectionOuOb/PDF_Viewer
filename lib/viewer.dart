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
  final Map<int, TransformationController> _transformControllers = {};
  int _currentIndex = 0;

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

  void _goToPage(int index) {
    widget.pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final notSinglePageBook = widget.book.pageCount != 1;
    final bookId = widget.book.id;
    final pageCount = widget.book.pageCount;

    return Stack(
      children: [
        PageView.builder(
          controller: widget.pageController,
          itemCount: pageCount,
          physics: const ClampingScrollPhysics(),
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
            widget.onPageChanged(index + 1);
          },
          itemBuilder: (context, index) {
            final previewPath = 'assets/images/preview/$bookId/${index + 1}.png';
            final fullPath = 'assets/images/full/$bookId/${index + 1}.png';
            final transformCtrl = _controllerFor(index);

            return GestureDetector(
              onDoubleTapDown: (details) {
                if (transformCtrl.value != Matrix4.identity()) {
                  transformCtrl.value = Matrix4.identity();
                } else {
                  final pos = details.localPosition;
                  transformCtrl.value = Matrix4.identity()
                    ..translate(-pos.dx * 1.5, -pos.dy * 1.5)
                    ..scale(2.5);
                }
              },
              child: InteractiveViewer(
                transformationController: transformCtrl,
                minScale: 1.0,
                maxScale: 5.0,
                child: ProgressiveImage(
                  previewPath: previewPath,
                  fullPath: fullPath,
                ),
              ),
            );
          },
        ),

        if (_currentIndex > 0 && notSinglePageBook)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: _PageNavButton(
              icon: Icons.chevron_left,
              onTap: () => _goToPage(_currentIndex - 1),
            ),
          ),

        if (_currentIndex < pageCount - 1 && notSinglePageBook)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: _PageNavButton(
              icon: Icons.chevron_right,
              onTap: () => _goToPage(_currentIndex + 1),
            ),
          ),
      ],
    );
  }
}

class _PageNavButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _PageNavButton({required this.icon, required this.onTap});

  @override
  State<_PageNavButton> createState() => _PageNavButtonState();
}

class _PageNavButtonState extends State<_PageNavButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.translucent,
        child: AnimatedOpacity(
          opacity: _hovering ? 0.7 : 0.15,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: widget.icon == Icons.chevron_left
                  ? const BorderRadius.horizontal(right: Radius.circular(8))
                  : const BorderRadius.horizontal(left: Radius.circular(8)),
            ),
            child: Icon(widget.icon, color: Colors.white, size: 32),
          ),
        ),
      ),
    );
  }
}
