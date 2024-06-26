import 'package:ada_chat_flutter/src/browser_controller.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// User's method to wrap the browser widget in a custom user's page
///
/// context - Current context
/// browser - Browser widget that is opened by the Ada chat
/// controller - Controller for browser widget
typedef PageBuilder = Widget Function(
  BuildContext context,
  Widget browser,
  BrowserController controller,
);

class BrowserSettings {
  BrowserSettings({
    required this.pageBuilder,
    this.adaHideUrls = const [],
  });

  @internal
  BrowserController? control;

  /// Custom page builder
  final PageBuilder pageBuilder;

  /// List of URLs where the Ada chat button will be hidden
  final List<RegExp> adaHideUrls;

  @internal
  void init() => control = BrowserController();

  @internal
  void dispose() => control?.dispose();
}
