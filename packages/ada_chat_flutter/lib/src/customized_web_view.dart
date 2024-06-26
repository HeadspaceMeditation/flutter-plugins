import 'dart:developer';

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

    // todo POC for MSE-187, move outside of the library
    // await _hideAdaButton();
  }

  // todo POC for MSE-187, move outside of the library
  /// Explanation: https://developers.ada.cx/reference/customize-chat#hide-the-default-chat-button
//   Future<void> _hideAdaButton() {
//     return _webViewController.runJavaScript('''
// var parent = document.getElementsByTagName('body').item(0);
// var style = document.createElement('style');
// style.type = 'text/css';
// style.innerHTML = "#ada-button-frame{ display: none; }";
// parent.appendChild(style);
// ''');
//   }

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
    final uri = Uri.parse(request.url);
    log('CustomizedWebView:onNavigationRequest: url=$uri');

    // todo POC for MSE-187, move outside of the library
    // if (uri
    //     .toString()
    //     .contains(RegExp(r'^https://headspace.ada.support/embed/'))) {
    //   log('CustomizedWebView:onNavigationRequest: skip url=$uri');
    //   return NavigationDecision.prevent;
    // }

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
