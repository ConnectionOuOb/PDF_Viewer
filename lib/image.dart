import 'dart:async';
import 'package:flutter/material.dart';

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

class _ProgressiveImageState extends State<ProgressiveImage> with SingleTickerProviderStateMixin {
  bool _fullLoaded = false;
  bool _disposed = false;
  Timer? _debounce;
  ImageStreamListener? _imageListener;
  ImageStream? _imageStream;
  ImageProvider? _fullImageProvider;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _scheduleFullLoad();
  }

  @override
  void didUpdateWidget(covariant ProgressiveImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fullPath != widget.fullPath) {
      _cancelFullLoad();
      _fullLoaded = false;
      _fadeController.reset();
      _scheduleFullLoad();
    }
  }

  void _scheduleFullLoad() {
    _debounce = Timer(const Duration(milliseconds: 300), _startFullLoad);
  }

  void _startFullLoad() {
    if (!mounted || _disposed) return;
    _fullImageProvider = AssetImage(widget.fullPath);
    _imageStream = _fullImageProvider!.resolve(const ImageConfiguration());
    _imageListener = ImageStreamListener((_, __) {
      if (mounted && !_disposed) {
        setState(() => _fullLoaded = true);
        _fadeController.forward();
      }
    });
    _imageStream!.addListener(_imageListener!);
  }

  void _cancelFullLoad() {
    _debounce?.cancel();
    _debounce = null;

    if (_imageListener != null && _imageStream != null) {
      _imageStream!.removeListener(_imageListener!);
    }

    // 若高清圖尚未載入完成，將其從圖片快取中移除，
    // 釋放圖片解碼佇列，讓新頁面的預覽圖能優先載入
    if (!_fullLoaded && _fullImageProvider != null) {
      _fullImageProvider!.evict();
    }

    _imageListener = null;
    _imageStream = null;
    _fullImageProvider = null;
  }

  @override
  void dispose() {
    _disposed = true;
    _cancelFullLoad();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          widget.previewPath,
          fit: BoxFit.contain,
          gaplessPlayback: true,
        ),
        if (_fullLoaded)
          FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              widget.fullPath,
              fit: BoxFit.contain,
              gaplessPlayback: true,
            ),
          ),
      ],
    );
  }
}
