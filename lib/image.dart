import 'dart:ui';
import 'package:flutter/material.dart';

class ProgressiveImage extends StatelessWidget {
  final String assetPath;

  const ProgressiveImage({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 低解析度模糊佔位（cacheWidth 極小，解碼速度極快）
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Image.asset(
            assetPath,
            cacheWidth: 80,
            fit: BoxFit.contain,
            gaplessPlayback: true,
          ),
        ),

        // 全解析度圖片，解碼完成後淡入
        Image.asset(
          assetPath,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            // 圖片已在快取中，直接顯示不需動畫
            if (wasSynchronouslyLoaded) return child;

            return AnimatedOpacity(
              opacity: frame == null ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              child: child,
            );
          },
        ),
      ],
    );
  }
}
