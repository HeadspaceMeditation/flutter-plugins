import 'dart:async';

import 'package:meta/meta.dart';
import 'package:webview_flutter/webview_flutter.dart';

abstract class AdaControllerInit {
  @visibleForTesting
  @protected
  late WebViewController webViewController;
  @visibleForTesting
  @protected
  late String handle;

  FutureOr<void> init({
    required WebViewController webViewController,
    required String handle,
  }) {
    this.webViewController = webViewController;
    this.handle = handle;
  }

  FutureOr<void> start();

  FutureOr<void> triggerAnswer(String answerId);
}
