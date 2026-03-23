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

class _ProgressiveImageState extends State<ProgressiveImage>
    with SingleTickerProviderStateMixin {
  bool _fullLoaded = false;
  Timer? _debounce;
  ImageStreamListener? _imageListener;
  ImageStream? _imageStream;
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

    _debounce = Timer(const Duration(milliseconds: 300), _startFullLoad);
  }

  void _startFullLoad() {
    if (!mounted) return;
    final fullImage = AssetImage(widget.fullPath);
    _imageStream = fullImage.resolve(const ImageConfiguration());
    _imageListener = ImageStreamListener((_, __) {
      if (mounted) {
        setState(() => _fullLoaded = true);
        _fadeController.forward();
      }
    });
    _imageStream!.addListener(_imageListener!);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (_imageListener != null && _imageStream != null) {
      _imageStream!.removeListener(_imageListener!);
    }
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
