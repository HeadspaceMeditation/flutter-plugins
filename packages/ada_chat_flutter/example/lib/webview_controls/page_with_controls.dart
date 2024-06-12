import 'package:ada_chat_flutter/ada_chat_flutter.dart';
import 'package:example/webview_controls/page_controls.dart';
import 'package:example/widgets/horizontal_line.dart';
import 'package:flutter/material.dart';

class PageWithControls extends StatelessWidget {
  const PageWithControls({
    super.key,
    required this.controller,
    required this.child,
  });

  final BrowserController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PageControls(controller: controller),
            const HorizontalLine(),
          ],
        ),
      ],
    );
  }
}
