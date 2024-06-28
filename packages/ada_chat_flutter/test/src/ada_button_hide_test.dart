import 'package:ada_chat_flutter/src/ada_button_hide.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MockWebViewController extends Mock implements WebViewController {}

void main() {
  late MockWebViewController mockWebViewController;
  late AdaButtonHide adaButtonHide;

  setUp(() {
    mockWebViewController = MockWebViewController();
    adaButtonHide = AdaButtonHide(
      webViewController: mockWebViewController,
      adaHideUrls: [RegExp(r'^https://help.my-company.com/')],
    );

    when(() => mockWebViewController.runJavaScript(any()))
        .thenAnswer((_) async {});
  });

  group('AdaButtonHide tests - ', () {
    group('maybeHideButton tests - ', () {
      test('hides button when URL matches adaHideUrls', () async {
        await adaButtonHide
            .maybeHideButton('https://help.my-company.com/something');

        verify(() => mockWebViewController.runJavaScript(any())).called(1);
      });

      test('does not hide button when URL does not match adaHideUrls',
          () async {
        await adaButtonHide
            .maybeHideButton('https://help.other-company.com/something');

        verifyNever(() => mockWebViewController.runJavaScript(any()));
      });
    });

    group('mustHideBalloon tests - ', () {
      test(
          'returns true when current URL matches adaHideUrls and request URL is an Ada embed link',
          () {
        expect(
          adaButtonHide.mustHideBalloon(
            'https://help.my-company.com/something',
            'https://my-company.ada.support/embed/something',
          ),
          isTrue,
        );
      });

      test('returns false when current URL does not match adaHideUrls', () {
        expect(
          adaButtonHide.mustHideBalloon(
            'https://example.com/',
            'https://my-company.ada.support/embed/something',
          ),
          isFalse,
        );
      });

      test('returns false when request URL is not an Ada embed link', () {
        expect(
          adaButtonHide.mustHideBalloon(
            'https://help.my-company.com/something',
            'https://example.com/',
          ),
          isFalse,
        );
      });

      test('returns false when both urls are not satisfy conditions', () {
        expect(
          adaButtonHide.mustHideBalloon(
            'https://example.com/',
            'https://example.com/',
          ),
          isFalse,
        );
      });
    });
  });
}
