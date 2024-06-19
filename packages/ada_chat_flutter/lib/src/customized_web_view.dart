import 'package:ada_chat_flutter/src/browser_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
  final _settings = InAppWebViewSettings(
    useWideViewPort: false,
  );

  @override
  void initState() {
    super.initState();
    widget.browserSettings?.init();
  }

  @override
  void dispose() {
    widget.browserSettings?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = InAppWebView(
      initialUrlRequest: URLRequest(url: widget.url),
      initialSettings: _settings,
      onLoadStop: (
        InAppWebViewController webViewController,
        WebUri? url,
      ) async {
        if (widget.browserSettings == null) {
          return;
        }

        widget.browserSettings?.control?.init(webViewController);

        final title = await webViewController.getTitle();
        widget.browserSettings?.control?.setTitle(title ?? '');

        final webUri = await webViewController.getUrl();
        widget.browserSettings?.control?.setHost(webUri?.host ?? '');
        widget.browserSettings?.control
            ?.setIsHttps(webUri?.isScheme('https') ?? false);

        final canGoBack = await webViewController.canGoBack();
        widget.browserSettings?.control?.setBackIsAvailable(canGoBack);

        final canGoForward = await webViewController.canGoForward();
        widget.browserSettings?.control?.setForwardIsAvailable(canGoForward);
      },
    );

    final pageBuilder = widget.browserSettings?.pageBuilder;
    final browserController = widget.browserSettings?.control;
    if (pageBuilder != null && browserController != null) {
      return pageBuilder(context, child, browserController);
    }

    return child;
  }
}
