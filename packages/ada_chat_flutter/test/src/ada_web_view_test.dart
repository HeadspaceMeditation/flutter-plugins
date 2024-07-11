import 'package:ada_chat_flutter/src/ada_controller.dart';
import 'package:ada_chat_flutter/src/ada_web_view.dart';
import 'package:ada_chat_flutter/src/browser_settings.dart';
import 'package:ada_chat_flutter/src/customized_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../webview_mocks.dart';

class _MockAdaController extends Mock implements AdaController {}

const _title = '_title';
const _regexp = '_regexp';
const _handle = '_handle';
const _embedUri = 'https://example.com/embed.html';

final _browserSettings = BrowserSettings(
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
);

void main() {
  late _MockAdaController mockAdaController;

  setUp(() {
    WebViewPlatform.instance = FakeWebViewPlatform();

    mockAdaController = _MockAdaController();

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

    testWidgets(
      'GIVEN the widget is pumped '
      'WHEN onNavigationRequest is called for external page '
      'THEN should show customized webview',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _buildAdaWebView(mockAdaController),
          ),
        );

        final state = tester.state<AdaWebViewState>(find.byType(AdaWebView));

        state.onNavigationRequest(
          NavigationRequest(
            url: 'https://external-page.com/index.html',
            isMainFrame: true,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(_title), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is CustomizedWebView && w.browserSettings == _browserSettings,
          ),
          findsOneWidget,
        );
      },
    );
  });
}

Widget _buildAdaWebView(_MockAdaController mockAdaController) {
  return AdaWebView(
    embedUri: Uri.parse(_embedUri),
    handle: _handle,
    controller: mockAdaController,
    rolloutOverride: 1,
    language: 'en',
    metaFields: const {'key': 'value'},
    browserSettings: _browserSettings,
  );
}
