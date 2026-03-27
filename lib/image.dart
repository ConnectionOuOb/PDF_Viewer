import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class ProgressiveImage extends StatefulWidget {
  final String previewPath;
  final String fullPath;

  const ProgressiveImage({
    super.key,
    required this.previewPath,
    required this.fullPath,
  });

  @override
  State<ProgressiveImage> createState() => _ProgressiveImageState();
}

class _ProgressiveImageState extends State<ProgressiveImage> {
  late AssetImage _fullImageProvider;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _fullImageProvider = AssetImage(widget.fullPath);
  }

  @override
  void didUpdateWidget(covariant ProgressiveImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fullPath != widget.fullPath) {
      if (!_loaded) _fullImageProvider.evict();
      _loaded = false;
      _fullImageProvider = AssetImage(widget.fullPath);
    }
  }

  @override
  void dispose() {
    // 若高清圖尚未載入完成，將其從圖片快取中移除，
    // 釋放圖片解碼佇列，讓新頁面的預覽圖能優先載入
    if (!_loaded) _fullImageProvider.evict();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OctoImage(
      image: _fullImageProvider,
      imageBuilder: (context, child) {
        _loaded = true;
        return child;
      },
      placeholderBuilder: (context) => Image.asset(
        widget.previewPath,
        fit: BoxFit.contain,
        gaplessPlayback: true,
      ),
      fadeInDuration: const Duration(milliseconds: 300),
      errorBuilder: OctoError.icon(color: Colors.red),
      fit: BoxFit.contain,
    );
  }
}
