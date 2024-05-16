import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// When you try to run test with widgets containing inappwebview
/// you will see following error:
/// A platform implementation for `flutter_inappwebview` has not been set. Please ensure that an
/// implementation of `InAppWebViewPlatform` has been set to `InAppWebViewPlatform.instance` before use.
/// For unit testing, `InAppWebViewPlatform.instance` can be set with your own test implementation.
///
/// The solution can be found here:
/// https://github.com/pichillilorenzo/flutter_inappwebview/issues/2019#issuecomment-1959601042
///
/// Usage of the solution in tests:
/// ```dart
/// void main() {
//   final mockWebViewDependencies = MockWebViewDependencies();
//
//   setUp(() {
//     mockWebViewDependencies.init();
//   });
//
//   tearDown(() {
//     mockWebViewDependencies.tearDown();
//   });
/// ```
class MockWebViewPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements InAppWebViewPlatform {}

class MockPlatformCookieManager extends Mock
    with MockPlatformInterfaceMixin
    implements PlatformCookieManager {}

class MockWebViewWidget extends Mock
    with MockPlatformInterfaceMixin
    implements PlatformInAppWebViewWidget {}

class FakeCookieParams extends Fake
    implements PlatformCookieManagerCreationParams {}

class FakeWebUri extends Fake implements WebUri {}

class FakeWidgetParams extends Fake
    implements PlatformInAppWebViewWidgetCreationParams {}

class MockWebViewDependencies {
  static const MethodChannel channel = MethodChannel('fk_user_agent');

  Future<void> init() async {
    registerFallbackValue(FakeCookieParams());
    registerFallbackValue(FakeWebUri());
    registerFallbackValue(FakeWidgetParams());

    // Mock webview widget
    final mockWidget = MockWebViewWidget();
    when(() => mockWidget.build(any())).thenReturn(const SizedBox.shrink());

    // Mock cookie manager
    final mockCookieManager = MockPlatformCookieManager();
    when(() => mockCookieManager.deleteAllCookies())
        .thenAnswer((_) => Future.value(true));
    when(() => mockCookieManager.setCookie(
          url: any(named: 'url'),
          name: any(named: 'name'),
          value: any(named: 'value'),
          path: any(named: 'path'),
          domain: any(named: 'domain'),
          expiresDate: any(named: 'expiresDate'),
          maxAge: any(named: 'maxAge'),
          isSecure: any(named: 'isSecure'),
          isHttpOnly: any(named: 'isHttpOnly'),
          sameSite: any(named: 'sameSite'),
          // ignore: deprecated_member_use
          iosBelow11WebViewController:
              any(named: 'iosBelow11WebViewController'),
          webViewController: any(named: 'webViewController'),
        )).thenAnswer((_) => Future.value(true));

    // Mock webview platform
    final mockPlatform = MockWebViewPlatform();
    when(() => mockPlatform.createPlatformInAppWebViewWidget(any()))
        .thenReturn(mockWidget);
    when(() => mockPlatform.createPlatformCookieManager(any()))
        .thenReturn(mockCookieManager);

    // Use mock
    InAppWebViewPlatform.instance = mockPlatform;

    // Mock user agent in setUp or setUpAll
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return {'webViewUserAgent': 'userAgent'};
    });
    FkUserAgent.init();
  }

  void tearDown() {
    channel.setMockMethodCallHandler(null);
  }

  /// This double pump is needed for triggering the build of the webview
  /// otherwise it will fail
  Future<void> doublePump(WidgetTester tester) async {
    await tester.pump();
    await tester.pump();
  }
}
