import 'package:ada_chat_flutter/ada_chat_flutter.dart';
import 'package:example/horizontal_line.dart';
import 'package:example/page_controls.dart';
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
