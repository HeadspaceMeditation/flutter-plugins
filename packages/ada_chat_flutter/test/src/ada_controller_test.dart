import 'dart:convert';

import 'package:ada_chat_flutter/src/ada_controller.dart';
import 'package:ada_chat_flutter/src/ada_exception.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWebViewController extends Mock implements InAppWebViewController {}

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
        () => mockWebViewController.evaluateJavascript(
          source: any(named: 'source'),
        ),
      ).thenAnswer((_) async => null);
    });

    test(
        'WHEN start is called '
        'THEN should call evaluateJavascript with correct args', () {
      adaController.start();
      verify(
        () => mockWebViewController.evaluateJavascript(
          source: any(
            named: 'source',
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
        () => mockWebViewController.evaluateJavascript(
          source: any(
            named: 'source',
            that: predicate(
              (arg) =>
                  arg is String && arg.contains('adaEmbed.deleteHistory()'),
            ),
          ),
        ),
      ).called(1);
    });

    group('getInfo', () {
      test(
          'WHEN getInfo is called '
          'THEN should call callAsyncJavaScript with correct args', () async {
        when(
          () => mockWebViewController.callAsyncJavaScript(
            functionBody: any(named: 'functionBody'),
          ),
        ).thenAnswer(
          (_) async => CallAsyncJavaScriptResult(
            value: {
              'info': true,
            },
          ),
        );
        final result = await adaController.getInfo();
        expect(result, {'info': true});
        verify(
          () => mockWebViewController.callAsyncJavaScript(
            functionBody: any(
              named: 'functionBody',
              that: predicate(
                (arg) => arg is String && arg.contains('adaEmbed.getInfo()'),
              ),
            ),
          ),
        ).called(1);
      });

      test(
          'WHEN getInfo is called and it throws an AdaNullResultException'
          'THEN should throw AdaNullResultException', () async {
        when(
          () => mockWebViewController.callAsyncJavaScript(
            functionBody: any(named: 'functionBody'),
          ),
        ).thenAnswer((_) async => null);
        expect(
          () async => await adaController.getInfo(),
          throwsA(isA<AdaNullResultException>()),
        );
      });

      test(
          'WHEN getInfo is called and it completes with an error'
          'THEN should throw AdaExecException', () async {
        when(
          () => mockWebViewController.callAsyncJavaScript(
            functionBody: any(named: 'functionBody'),
          ),
        ).thenAnswer((_) async => CallAsyncJavaScriptResult(error: 'Error'));
        expect(
          () async => await adaController.getInfo(),
          throwsA(isA<AdaExecException>()),
        );
      });
    });

    test(
        'WHEN reset is called '
        'THEN should call evaluateJavascript with correct args', () {
      adaController.reset();
      verify(
        () => mockWebViewController.evaluateJavascript(
          source: any(
            named: 'source',
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
        () => mockWebViewController.evaluateJavascript(
          source: any(
            named: 'source',
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
        () => mockWebViewController.evaluateJavascript(
          source: any(
            named: 'source',
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
        () => mockWebViewController.evaluateJavascript(
          source: any(
            named: 'source',
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
        () => mockWebViewController.evaluateJavascript(
          source: any(
            named: 'source',
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
        () => mockWebViewController.evaluateJavascript(
          source: any(
            named: 'source',
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
