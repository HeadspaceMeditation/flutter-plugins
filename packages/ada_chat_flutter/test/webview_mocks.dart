import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/src/platform_navigation_delegate.dart';
import 'package:webview_flutter_platform_interface/src/platform_webview_controller.dart';
import 'package:webview_flutter_platform_interface/src/platform_webview_cookie_manager.dart';
import 'package:webview_flutter_platform_interface/src/platform_webview_widget.dart';
import 'package:webview_flutter_platform_interface/src/types/load_request_params.dart';

final webViewCalls = <String>[];

class FakePlatformWebViewCookieManager extends PlatformWebViewCookieManager {
  FakePlatformWebViewCookieManager(
    super.params,
  ) : super.implementation();

  @override
  Future<bool> clearCookies() async {
    return false;
  }

  @override
  Future<void> setCookie(WebViewCookie cookie) async {}
}

class FakeWebViewController extends PlatformWebViewController {
  FakeWebViewController(super.params) : super.implementation();

  @override
  Future<void> addJavaScriptChannel(
    JavaScriptChannelParams javaScriptChannelParams,
  ) async =>
      webViewCalls.add(
        'addJavaScriptChannel: name=${javaScriptChannelParams.name}',
      );

  @override
  Future<bool> canGoBack() async {
    return true;
  }

  @override
  Future<bool> canGoForward() async {
    return true;
  }

  @override
  Future<void> clearCache() async {}

  @override
  Future<void> clearLocalStorage() async {}

  @override
  Future<String?> currentUrl() async {
    return 'https://example.com/page.html';
  }

  @override
  Future<void> enableZoom(bool enabled) async {}

  @override
  Future<Offset> getScrollPosition() async {
    return Offset(0, 0);
  }

  @override
  Future<String?> getTitle() async {
    return null;
  }

  @override
  Future<String?> getUserAgent() async {
    return null;
  }

  @override
  Future<void> goBack() async => webViewCalls.add('goBack');

  @override
  Future<void> goForward() async => webViewCalls.add('goForward');

  @override
  Future<void> loadFile(String absoluteFilePath) async {}

  @override
  Future<void> loadFlutterAsset(String key) async {}

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {}

  @override
  Future<void> loadRequest(LoadRequestParams params) async {
    webViewCalls.add('loadRequest: uri=${params.uri}');
  }

  @override
  PlatformWebViewControllerCreationParams get params =>
      PlatformWebViewControllerCreationParams();

  @override
  Future<void> reload() async => webViewCalls.add('reload');

  @override
  Future<void> removeJavaScriptChannel(String javaScriptChannelName) async {}

  @override
  Future<void> runJavaScript(String javaScript) async => webViewCalls.add(
        'runJavaScript: javaScript=$javaScript',
      );

  @override
  Future<Object> runJavaScriptReturningResult(String javaScript) async {
    webViewCalls.add(
      'runJavaScriptReturningResult: javaScript=$javaScript',
    );
    return '{}';
  }

  @override
  Future<void> scrollBy(int x, int y) async {}

  @override
  Future<void> scrollTo(int x, int y) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {}

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setOnConsoleMessage(
    void Function(JavaScriptConsoleMessage consoleMessage) onConsoleMessage,
  ) async {}

  @override
  Future<void> setOnPlatformPermissionRequest(
    void Function(PlatformWebViewPermissionRequest request) onPermissionRequest,
  ) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> setUserAgent(String? userAgent) async {}
}

class FakeWebViewWidget extends PlatformWebViewWidget {
  FakeWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FakePlatformNavigationDelegate extends PlatformNavigationDelegate {
  FakePlatformNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnPageStarted(PageEventCallback onPageStarted) async {}

  @override
  Future<void> setOnNavigationRequest(
    NavigationRequestCallback onNavigationRequest,
  ) async {}

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {}

  @override
  Future<void> setOnProgress(ProgressCallback onProgress) async {}

  @override
  Future<void> setOnWebResourceError(
      WebResourceErrorCallback onWebResourceError) async {}

  @override
  Future<void> setOnUrlChange(UrlChangeCallback onUrlChange) async {}

  @override
  Future<void> setOnHttpAuthRequest(
      HttpAuthRequestCallback onHttpAuthRequest) async {}

  @override
  Future<void> setOnHttpError(HttpResponseErrorCallback onHttpError) async {}
}

class FakeWebViewPlatform extends WebViewPlatform {
  FakeWebViewPlatform() : super() {
    webViewCalls.clear();
  }

  @override
  PlatformWebViewCookieManager createPlatformCookieManager(
    PlatformWebViewCookieManagerCreationParams params,
  ) {
    return FakePlatformWebViewCookieManager(params);
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return FakePlatformNavigationDelegate(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return FakeWebViewWidget(params);
  }

  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return FakeWebViewController(params);
  }
}
