import 'package:ada_chat_flutter/src/browser_controller.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockInAppWebViewController extends Mock
    implements InAppWebViewController {}

void main() {
  late BrowserController browserController;
  late MockInAppWebViewController mockController;

  setUp(() {
    mockController = MockInAppWebViewController();
    browserController = BrowserController();
    browserController.init(mockController);

    when(() => mockController.goBack()).thenAnswer((_) async {});
    when(() => mockController.goForward()).thenAnswer((_) async {});
    when(() => mockController.reload()).thenAnswer((_) async {});
  });

  group('BrowserController', () {
    test('goBack calls controller.goBack', () async {
      await browserController.goBack();
      verify(() => mockController.goBack()).called(1);
    });

    test('goForward calls controller.goForward', () async {
      await browserController.goForward();
      verify(() => mockController.goForward()).called(1);
    });

    test('reload calls controller.reload', () async {
      await browserController.reload();
      verify(() => mockController.reload()).called(1);
    });

    test('title getter returns correct value', () {
      const newTitle = 'New Title';
      browserController.setTitle(newTitle);
      expect(browserController.title, newTitle);
    });

    test('backIsAvailable getter returns correct value', () {
      browserController.setBackIsAvailable(true);
      expect(browserController.backIsAvailable, true);
    });

    test('forwardIsAvailable getter returns correct value', () {
      browserController.setForwardIsAvailable(true);
      expect(browserController.forwardIsAvailable, true);
    });

    test('notifyListeners is called when properties are updated', () {
      var listenerCallCount = 0;
      browserController.addListener(() => listenerCallCount++);

      browserController.setTitle('New Title');
      browserController.setBackIsAvailable(true);
      browserController.setForwardIsAvailable(false);

      expect(listenerCallCount, 3);
    });
  });
}
