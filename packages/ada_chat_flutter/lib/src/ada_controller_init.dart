import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:meta/meta.dart';

abstract class AdaControllerInit {
  @visibleForTesting
  @protected
  late InAppWebViewController webViewController;
  @visibleForTesting
  @protected
  late String handle;

  FutureOr<void> init({
    required InAppWebViewController webViewController,
    required String handle,
  }) {
    this.webViewController = webViewController;
    this.handle = handle;
  }

  FutureOr<void> start();

  FutureOr<void> triggerAnswer(String answerId);
}
