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
  late final WebViewController _controller = WebViewController();

  @override
  void initState() {
    super.initState();
    widget.browserSettings?.init();

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: _onUrlChange,
          onPageStarted: _onPageStarted,
          onPageFinished: _onPageFinished,
          onNavigationRequest: _onNavigationRequest,
        ),
      );

    _controller.loadRequest(widget.url);
  }

  void _onUrlChange(change) {
    print('CustomizedWebView:onUrlChange: url=${change.url}');
  }

  void _onPageFinished(String url) {
    print('CustomizedWebView:onPageFinished: url=$url');
  }

  void _onPageStarted(String url) {
    print('CustomizedWebView:onPageStarted: url=$url');
  }

  Future<NavigationDecision> _onNavigationRequest(
      NavigationRequest request) async {
    print('CustomizedWebView:onNavigationRequest: '
        'url=${request.url}');
    // if (request.url.startsWith('https://www.youtube.com/')) {
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
    final child = WebViewWidget(controller: _controller);

    final pageBuilder = widget.browserSettings?.pageBuilder;
    final browserController = widget.browserSettings?.control;
    if (pageBuilder != null && browserController != null) {
      return pageBuilder(context, child, browserController);
    }

    return child;
  }
}
