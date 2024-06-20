import 'package:ada_chat_flutter/src/ada_controller_init.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AdaControllerInitImpl extends AdaControllerInit {
  @override
  void start() {}

  @override
  void triggerAnswer(String answerId) {}
}

void main() {
  group('AdaControllerInit tests - ', () {
    late AdaControllerInitImpl adaControllerInit;
    late MockInAppWebViewController mockInAppWebViewController;

    setUp(() {
      mockInAppWebViewController = MockInAppWebViewController();
      adaControllerInit = AdaControllerInitImpl();
    });

    test(
        'WHEN init called '
        'THEN should initialize inner state', () {
      adaControllerInit.init(
        webViewController: mockInAppWebViewController,
        handle: 'testHandle',
      );
      expect(adaControllerInit.webViewController, mockInAppWebViewController);
      expect(adaControllerInit.handle, 'testHandle');
    });
  });
}
