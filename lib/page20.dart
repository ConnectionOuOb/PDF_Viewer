import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';

const String iframeSrc = 'https://nycu-tce.github.io/TeaHexagram/';

class Page20 extends StatelessWidget {
  const Page20({super.key});

  @override
  Widget build(BuildContext context) {
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = iframeSrc
          ..style.border = 'none';
        return iframe;
      },
    );

    return const Scaffold(
        body: HtmlElementView(
          viewType: 'iframeElement',
        ),
    );
  }
}