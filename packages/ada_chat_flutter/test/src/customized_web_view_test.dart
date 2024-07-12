import 'package:ada_chat_flutter/src/browser_settings.dart';
import 'package:ada_chat_flutter/src/customized_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../webview_mocks.dart';

const _uri = 'https://example.com/page.html';
const _title = '_title';
const _regexp = '_regexp';

const _keyLeft = Key('left');
const _keyRight = Key('right');
const _keyReload = Key('reload');

void main() {
  setUp(() {
    WebViewPlatform.instance = FakeWebViewPlatform();
  });

  group('CustomizedWebView tests - ', () {
    testWidgets(
      'WHEN the widget is pumped '
      'THEN should load the provided URL',
      (WidgetTester tester) async {
        await _pumpWidget(tester);

        expect(
          webViewCalls,
          equals(['loadRequest: uri=$_uri']),
        );
      },
    );

    testWidgets(
      'WHEN the widget is pumped '
      'THEN should contain correct widgets',
      (WidgetTester tester) async {
        await _pumpWidget(tester);

        expect(find.byType(WebViewWidget), findsOneWidget);
        expect(find.text(_title), findsOneWidget);
        expect(find.byKey(_keyLeft), findsOneWidget);
        expect(find.byKey(_keyRight), findsOneWidget);
        expect(find.byKey(_keyReload), findsOneWidget);
      },
    );

    testWidgets(
      'GIVEN the widget is pumped '
      'WHEN page controller methods called '
      'THEN should call correct webview controller methods',
      (WidgetTester tester) async {
        await _pumpWidget(tester);

        await _initAndGetWidgetState(tester);

        await tester.tap(find.byKey(_keyLeft));
        await tester.pumpAndSettle();

        expect(
          webViewCalls,
          equals(['loadRequest: uri=$_uri', 'goBack']),
        );

        await tester.tap(find.byKey(_keyRight));
        await tester.pumpAndSettle();

        expect(
          webViewCalls,
          equals(['loadRequest: uri=$_uri', 'goBack', 'goForward']),
        );

        await tester.tap(find.byKey(_keyReload));
        await tester.pumpAndSettle();

        expect(
          webViewCalls,
          equals(['loadRequest: uri=$_uri', 'goBack', 'goForward', 'reload']),
        );
      },
    );

    testWidgets(
      'GIVEN the widget is pumped '
      'WHEN progress is changed '
      'THEN should rebuild screen with updated value',
      (WidgetTester tester) async {
        await _pumpWidget(tester);

        final state = await _initAndGetWidgetState(tester);

        state.onProgress(50);
        await tester.pumpAndSettle();

        expect(find.text('50 %'), findsOneWidget);

        state.onProgress(100);
        await tester.pumpAndSettle();

        expect(find.text('100 %'), findsOneWidget);
      },
    );
  });
}

Future<CustomizedWebViewState> _initAndGetWidgetState(
    WidgetTester tester) async {
  final state =
      tester.state<CustomizedWebViewState>(find.byType(CustomizedWebView));
  await state.onPageFinished(_uri);
  return state;
}

Future<void> _pumpWidget(WidgetTester tester) => tester.pumpWidget(
      MaterialApp(
        home: CustomizedWebView(
          url: Uri.parse(_uri),
          browserSettings: BrowserSettings(
            pageBuilder: (
              context,
              browser,
              controller,
            ) =>
                Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      key: _keyLeft,
                      icon: Icon(Icons.keyboard_arrow_left),
                      onPressed: () => controller.goBack(),
                    ),
                    IconButton(
                      key: _keyRight,
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: () => controller.goForward(),
                    ),
                    Expanded(child: Text(_title)),
                    IconButton(
                      key: _keyReload,
                      icon: Icon(Icons.refresh),
                      onPressed: () => controller.reload(),
                    ),
                    ListenableBuilder(
                      listenable: controller,
                      builder: (context, _) {
                        return Text('${controller.progress} %');
                      },
                    ),
                  ],
                ),
                browser,
              ],
            ),
            adaHideUrls: [
              RegExp(_regexp),
            ],
          ),
        ),
      ),
    );
