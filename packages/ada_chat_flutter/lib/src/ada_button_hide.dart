import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Ada button and balloon hide or un-hide logic
/// Doc: https://developers.ada.cx/reference/customize-chat#hide-the-default-chat-button
class AdaButtonHide {
  AdaButtonHide({
    required this.webViewController,
    this.adaHideUrls = const [],
  });

  @protected
  final WebViewController webViewController;

  /// List of URLs where the Ada chat button and balloon will be hidden
  @protected
  final List<RegExp> adaHideUrls;

  Future<void> maybeHideButton(String url) async {
    if (_urlIsInAdaHideUrls(url)) {
      await _hideAdaButton();
    }
  }

  bool _urlIsInAdaHideUrls(String url) {
    if (url.isEmpty || adaHideUrls.isEmpty) {
      return false;
    }

    return adaHideUrls.any((regex) => url.contains(regex));
  }

  Future<void> _hideAdaButton() => webViewController.runJavaScript('''
var parent = document.getElementsByTagName('body').item(0);
var style = document.createElement('style');
style.type = 'text/css';
style.innerHTML = "#ada-button-frame{ display: none; }";
parent.appendChild(style);
''');

  bool _isAdaEmbedLink(String uri) =>
      uri.contains(RegExp(r'^https://\S+.ada.support/embed/'));

  bool mustHideBalloon(String currentUrl, String requestUrl) =>
      _urlIsInAdaHideUrls(currentUrl) && _isAdaEmbedLink(requestUrl);
}
