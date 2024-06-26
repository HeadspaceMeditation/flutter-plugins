import 'dart:developer';

import 'package:ada_chat_flutter/src/ada_button_hide.dart';
import 'package:ada_chat_flutter/src/browser_settings.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomizedWebView extends StatefulWidget {
  const CustomizedWebView({
    super.key,
    required this.url,
    this.browserSettings,
  });

  final Uri url;
  final BrowserSettings? browserSettings;

  @override
  State<CustomizedWebView> createState() => _CustomizedWebViewState();
}

class _CustomizedWebViewState extends State<CustomizedWebView> {
  late final WebViewController _webViewController = WebViewController();
  late final AdaButtonHide _adaButtonHide = AdaButtonHide(
    webViewController: _webViewController,
    adaHideUrls: widget.browserSettings?.adaHideUrls ?? [],
  );

  @override
  void initState() {
    super.initState();

    widget.browserSettings?.init();

    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: _onUrlChange,
          onProgress: _onProgress,
          onPageStarted: _onPageStarted,
          onPageFinished: _onPageFinished,
          onNavigationRequest: _onNavigationRequest,
        ),
      )
      ..setOnConsoleMessage(_onConsoleMessage);

    _webViewController.loadRequest(widget.url);
  }

  void _onConsoleMessage(JavaScriptConsoleMessage message) =>
      log('CustomizedWebView:onConsoleMessage: '
          'level=${message.level.toString()}, '
          'message=${message.message}');

  void _onUrlChange(change) =>
      log('CustomizedWebView:onUrlChange: url=${change.url}');

  Future<void> _onPageFinished(String url) async {
    log('CustomizedWebView:onPageFinished: url=$url');

    final pageController = widget.browserSettings?.control;
    if (pageController == null) {
      return;
    }

    pageController.init(_webViewController);

    final title = await _webViewController.getTitle();
    pageController.setTitle(title ?? '');

    final currentUrl = await _webViewController.currentUrl();
    if (currentUrl != null) {
      final currentUri = Uri.parse(currentUrl);
      pageController.setHost(currentUri.host);
      pageController.setIsHttps(currentUri.isScheme('https'));
    }

    final canGoBack = await _webViewController.canGoBack();
    pageController.setBackIsAvailable(canGoBack);

    final canGoForward = await _webViewController.canGoForward();
    pageController.setForwardIsAvailable(canGoForward);

    await _adaButtonHide.maybeHideButton(url);
  }

  void _onProgress(int progress) {
    log('CustomizedWebView:onProgress: progress=$progress');

    final pageController = widget.browserSettings?.control;
    if (pageController == null) {
      return;
    }

    pageController.setProgress(progress);
  }

  Future<void> _onPageStarted(String url) async =>
      log('CustomizedWebView:onPageStarted: url=$url');

  Future<NavigationDecision> _onNavigationRequest(
    NavigationRequest request,
  ) async {
    final requestUrl = request.url;
    final currentUrl = await _webViewController.currentUrl() ?? '';

    log('CustomizedWebView:onNavigationRequest: currentUrl=$currentUrl, '
        'requestUrl=$requestUrl');

    if (_adaButtonHide.mustHideBalloon(currentUrl, requestUrl)) {
      log('CustomizedWebView:onNavigationRequest: Hide Ada url=$requestUrl');
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  @override
  void dispose() {
    widget.browserSettings?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = WebViewWidget(controller: _webViewController);

    final pageBuilder = widget.browserSettings?.pageBuilder;
    final browserController = widget.browserSettings?.control;
    if (pageBuilder != null && browserController != null) {
      return pageBuilder(context, child, browserController);
    }

    return child;
  }
}
