import 'dart:convert';

import 'package:ada_chat_flutter/src/ada_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MockWebViewController extends Mock implements WebViewController {}

const _handle = '_testHandle';

void main() {
  group('AdaController tests - ', () {
    late AdaController adaController;
    late MockWebViewController mockWebViewController;

    setUp(() {
      mockWebViewController = MockWebViewController();
      adaController = AdaController();

      adaController.init(
        webViewController: mockWebViewController,
        handle: _handle,
      );

      when(
        () => mockWebViewController.runJavaScript(any()),
      ).thenAnswer((_) async {});
    });

    test(
        'WHEN start is called '
        'THEN should call evaluateJavascript with correct args', () {
      adaController.start();
      verify(
        () => mockWebViewController.runJavaScript(
          any(
            that: predicate(
              (arg) =>
                  arg is String &&
                  arg.contains('adaEmbed.start') &&
                  arg.contains('handle: "$_handle"') &&
                  arg.contains('parentElement: "content_frame"'),
            ),
          ),
        ),
      ).called(1);
    });

    test(
        'WHEN deleteHistory is called '
        'THEN should call evaluateJavascript with correct args', () {
      adaController.deleteHistory();
      verify(
        () => mockWebViewController.runJavaScript(
          any(
            that: predicate(
              (arg) =>
                  arg is String && arg.contains('adaEmbed.deleteHistory()'),
            ),
          ),
        ),
      ).called(1);
    });

    test(
        'WHEN getInfo is called '
        'THEN should call callAsyncJavaScript with correct args', () async {
      when(
        () => mockWebViewController.runJavaScriptReturningResult(any()),
      ).thenAnswer((_) async => '{"info": true}');

      final result = await adaController.getInfo();
      expect(result, '{"info": true}');
      verify(
        () => mockWebViewController.runJavaScriptReturningResult(
          any(
            that: predicate(
              (arg) => arg is String && arg.contains('adaEmbed.getInfo()'),
            ),
          ),
        ),
      ).called(1);
    });

    test(
        'WHEN reset is called '
        'THEN should call evaluateJavascript with correct args', () {
      adaController.reset();
      verify(
        () => mockWebViewController.runJavaScript(
          any(
            that: predicate(
              (arg) => arg is String && arg.contains('adaEmbed.reset()'),
            ),
          ),
        ),
      ).called(1);
    });

    test(
        'WHEN setLanguage is called '
        'THEN should call evaluateJavascript with correct args', () {
      adaController.setLanguage('en');
      verify(
        () => mockWebViewController.runJavaScript(
          any(
            that: predicate(
              (arg) =>
                  arg is String && arg.contains('adaEmbed.setLanguage("en")'),
            ),
          ),
        ),
      ).called(1);
    });

    test(
        'WHEN setMetaFields is called '
        'THEN should call evaluateJavascript with correct args', () async {
      final fields = {'key': 'value'};

      await adaController.setMetaFields(fields);
      verify(
        () => mockWebViewController.runJavaScript(
          any(
            that: predicate(
              (arg) =>
                  arg is String &&
                  arg.contains('adaEmbed.setMetaFields') &&
                  arg.contains(jsonEncode(fields).toString()),
            ),
          ),
        ),
      ).called(1);
    });

    test(
        'WHEN setSensitiveMetaFields is called '
        'THEN should call evaluateJavascript with correct args', () async {
      final fields = {'key': 'value'};

      await adaController.setSensitiveMetaFields(fields);
      verify(
        () => mockWebViewController.runJavaScript(
          any(
            that: predicate(
              (arg) =>
                  arg is String &&
                  arg.contains('adaEmbed.setSensitiveMetaFields') &&
                  arg.contains(jsonEncode(fields).toString()),
            ),
          ),
        ),
      ).called(1);
    });

    test(
        'WHEN stop is called '
        'THEN should call evaluateJavascript with correct args', () {
      adaController.stop();
      verify(
        () => mockWebViewController.runJavaScript(
          any(
            that: predicate(
              (arg) => arg is String && arg.contains('adaEmbed.stop()'),
            ),
          ),
        ),
      ).called(1);
    });

    test(
        'WHEN triggerAnswer is called '
        'THEN should call evaluateJavascript with correct args', () {
      adaController.triggerAnswer('answerId');
      verify(
        () => mockWebViewController.runJavaScript(
          any(
            that: predicate(
              (arg) =>
                  arg is String &&
                  arg.contains('adaEmbed.triggerAnswer("answerId")'),
            ),
          ),
        ),
      ).called(1);
    });
  });
}
