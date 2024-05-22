import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// User's method to wrap the browser widget in a custom user's page
///
/// context - Current context
/// browser - Browser widget that is opened by the Ada chat
/// controls - Controls for browser widget
typedef PageBuilder = Widget Function(
  BuildContext context,
  Widget browser,
  BrowserControls controls,
);

typedef BooleanCallback = void Function(bool isAvailable);
typedef StringCallback = void Function(String text);

class BrowserInit {
  InAppWebViewController? _controller;

  set controller(InAppWebViewController controller) => _controller = controller;
}

class BrowserControls extends BrowserInit {
  Future<void> goBack() async => _controller?.goBack();

  Future<void> goForward() async => _controller?.goForward();
}

class BrowserController extends BrowserControls {
  BrowserController({
    required this.pageBuilder,
    this.onTitleChanged,
    this.onGoBackChanged,
    this.onGoForwardChanged,
  });

  /// Custom page builder
  final PageBuilder pageBuilder;

  final StringCallback? onTitleChanged;

  final BooleanCallback? onGoBackChanged;

  final BooleanCallback? onGoForwardChanged;
}
