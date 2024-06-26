import 'package:ada_chat_flutter/src/ada_controller.dart';
import 'package:ada_chat_flutter/src/ada_controller_init.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MockWebViewController extends Mock implements WebViewController {}

void main() {
  group('AdaControllerInit tests - ', () {
    late AdaControllerInit adaController;
    late MockWebViewController mockWebViewController;

    setUp(() {
      adaController = AdaController();
      mockWebViewController = MockWebViewController();
    });

    test(
        'WHEN init called '
        'THEN should initialize inner state', () {
      adaController.init(
        webViewController: mockWebViewController,
        handle: 'testHandle',
      );

      expect(adaController.webViewController, mockWebViewController);
      expect(adaController.handle, 'testHandle');
    });
  });
}
