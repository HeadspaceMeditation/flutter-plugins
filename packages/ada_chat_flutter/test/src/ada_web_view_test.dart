import 'package:ada_chat_flutter/src/ada_controller.dart';
import 'package:ada_chat_flutter/src/ada_web_view.dart';
import 'package:ada_chat_flutter/src/browser_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../webview_mocks.dart';

class MockAdaController extends Mock implements AdaController {}

const _title = '_title';
const _regexp = '_regexp';
const _handle = '_handle';
const _embedUri = 'https://example.com/embed.html';

void main() {
  late MockAdaController mockAdaController;

  setUp(() {
    WebViewPlatform.instance = FakeWebViewPlatform();

    mockAdaController = MockAdaController();

    when(() => mockAdaController.start()).thenAnswer((_) async {});
  });

  group('AdaWebView tests - ', () {
    testWidgets(
      'WHEN AdaWebView is pumped '
      'THEN should show correct widgets',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _buildAdaWebView(mockAdaController),
          ),
        );

        expect(
          webViewCalls,
          equals(['loadRequest: uri=$_embedUri']),
        );
      },
    );

    testWidgets(
      'GIVEN the widget is pumped '
      'WHEN isInternalAdaUrl is called '
      'THEN should rebuild correct result',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _buildAdaWebView(mockAdaController),
          ),
        );

        final state = tester.state<AdaWebViewState>(find.byType(AdaWebView));

        expect(state.isInternalAdaUrl(Uri.parse('about:blank')), true);
        expect(
          state.isInternalAdaUrl(Uri.parse('https://$_handle.ada.support/asd')),
          true,
        );
        expect(state.isInternalAdaUrl(Uri.parse(_embedUri)), true);

        expect(state.isInternalAdaUrl(Uri.parse('google.com')), false);
      },
    );

    testWidgets(
      'GIVEN the widget is pumped '
      'WHEN onPageFinished is called '
      'THEN should init and start Ada with correct params',
      (WidgetTester tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(
            MaterialApp(
              home: _buildAdaWebView(mockAdaController),
            ),
          );

          final state = tester.state<AdaWebViewState>(find.byType(AdaWebView));

          state.onPageFinished(_embedUri);
          await Future.delayed(Duration.zero);

          verify(() => mockAdaController.start()).called(1);
          expect(
            webViewCalls,
            contains('loadRequest: uri=https://example.com/embed.html'),
          );
          expect(
            webViewCalls,
            contains('addJavaScriptChannel: name=onLoaded'),
          );
          expect(
            webViewCalls,
            anyElement(contains('"metaFields":{"key":"value"')),
          );
          expect(
            webViewCalls,
            anyElement(
              contains('{"handle":"$_handle","language":"en","cluster":'
                  'null,"domain":null,"hideMask":false'),
            ),
          );
        });
      },
    );
  });
}

Widget _buildAdaWebView(MockAdaController mockAdaController) {
  return AdaWebView(
    embedUri: Uri.parse(_embedUri),
    handle: _handle,
    controller: mockAdaController,
    rolloutOverride: 1,
    language: 'en',
    metaFields: const {'key': 'value'},
    browserSettings: BrowserSettings(
      pageBuilder: (
        context,
        browser,
        controller,
      ) =>
          Column(
        children: [
          Text(_title),
          browser,
        ],
      ),
      adaHideUrls: [
        RegExp(_regexp),
      ],
    ),
  );
}
