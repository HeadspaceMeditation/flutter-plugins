import 'dart:convert';
import 'dart:io';

import 'package:ada_chat_flutter/src/ada_controller.dart';
import 'package:ada_chat_flutter/src/ada_controller_init.dart';
import 'package:ada_chat_flutter/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Ada chat WebView widget.
///
/// Read fields description (here)[https://developers.ada.cx/reference/embed2-reference].
class AdaWebView extends StatefulWidget {
  const AdaWebView({
    super.key,
    required this.handle,
    this.name,
    this.email,
    this.phone,
    this.urlRequest,
    this.controller,
    this.language = 'en',
    this.cluster,
    this.domain,
    this.hideMask = false,
    this.greeting,
    this.greetingDelay = const Duration(seconds: 5),
    this.privateMode = false,
    this.metaFields = const {},
    this.sensitiveMetaFields = const {},
    this.crossWindowPersistence = true,
    this.autostart = true,
    this.rolloutOverride,
    this.testMode = false,
    this.onProgressChanged,
    this.onLoaded,
    this.onAdaReady,
    this.onEvent,
    this.onConversationEnd,
    this.onDrawerToggle,
    this.onConsoleMessage,
    this.onLoadingError,
  });

  final String handle;

  /// User name, an additional field to add to the metadata
  final String? name;

  /// User e-mail, an additional field to add to the metadata
  final String? email;

  /// User phone, an additional field to add to the metadata
  final String? phone;

  /// Url to your own page with assets/embed.html file.
  /// The domain must be added to approved domains. (Doc)[https://docs.ada.cx/docs/scripted/use-ada-with-your-website/deploy-ada-on-your-website-or-app/restrict-your-bot-to-a-list-of-approved-domains/].
  final URLRequest? urlRequest;

  /// Controller for Ada chat. The default implementation is [AdaController].
  final AdaControllerInit? controller;
  final String language;
  final String? cluster;
  final String? domain;
  final bool hideMask;
  final String? greeting;

  /// Show greeting message after some delay to make sure that chat is loaded
  final Duration greetingDelay;
  final bool privateMode;
  final FlatObject metaFields;
  final FlatObject sensitiveMetaFields;
  final bool crossWindowPersistence;

  /// Show chat immediately without need to call start() method of [AdaController]
  final bool autostart;
  final double? rolloutOverride;
  final bool testMode;

  /// Loading progress [0, 100].
  final void Function(int progress)? onProgressChanged;

  final void Function(dynamic data)? onLoaded;
  final VoidCallback? onAdaReady;
  final void Function(dynamic event)? onEvent;
  final void Function(dynamic event)? onConversationEnd;
  final void Function(bool isDrawerOpen)? onDrawerToggle;
  final void Function(String level, String message)? onConsoleMessage;
  final void Function(String request, String error)? onLoadingError;

  @override
  State<AdaWebView> createState() => _AdaWebViewState();
}

class _AdaWebViewState extends State<AdaWebView> {
  late final _settings = InAppWebViewSettings(
    supportZoom: false,
    horizontalScrollBarEnabled: false,
    verticalScrollBarEnabled: false,
    useWideViewPort: false,
    disableDefaultErrorPage: true,
    allowFileAccessFromFileURLs: _allowFileAccessFromFileURLs,
    allowsBackForwardNavigationGestures: false,
  );

  /// Unsafe feature. Needed if the embed.html file is not hosted anywhere, then
  /// the file from the assets will be used.
  /// More about it (here)[https://inappwebview.dev/docs/webview/in-app-webview#antipatterns].
  late final bool _allowFileAccessFromFileURLs = widget.urlRequest == null;

  @override
  Widget build(BuildContext context) => InAppWebView(
        initialUrlRequest: widget.urlRequest,
        initialFile: _getInitialFile,
        initialSettings: _settings,
        shouldOverrideUrlLoading: _shouldOverrideUrlLoading,
        onCreateWindow: _onCreateWindow,
        onProgressChanged: (_, progress) =>
            widget.onProgressChanged?.call(progress),
        onReceivedError: (controller, request, error) =>
            widget.onLoadingError?.call(
          request.toString(),
          error.toString(),
        ),
        onReceivedHttpError: (controller, request, errorResponse) =>
            widget.onLoadingError?.call(
          request.toString(),
          errorResponse.toString(),
        ),
        onWebViewCreated: _init,
        onLoadStop: _start,
        onConsoleMessage: (controller, consoleMessage) =>
            widget.onConsoleMessage?.call(
          consoleMessage.messageLevel.toString(),
          consoleMessage.message,
        ),
      );

  String? get _getInitialFile {
    return widget.urlRequest != null
        ? null
        : 'packages/ada_chat_flutter/assets/embed.html';
  }

  Future<void> _start(controller, url) async {
    final metaFields = {
      ...widget.metaFields,
      'sdkType': getOsName,
      'sdkSupportsDownloadLink': true,
    };

    if (widget.name != null) {
      metaFields['name'] = widget.name;
    }
    if (widget.email != null) {
      metaFields['email'] = widget.email;
    }
    if (widget.phone != null) {
      metaFields['phone'] = widget.phone;
    }

    final settings = <String, dynamic>{
      'handle': widget.handle,
      'language': widget.language,
      'cluster': widget.cluster,
      'domain': widget.domain,
      'hideMask': widget.hideMask,
      'privateMode': widget.privateMode,
      'rolloutOverride': widget.rolloutOverride,
      'metaFields': metaFields,
      'sensitiveMetaFields': widget.sensitiveMetaFields,
      'testMode': widget.testMode,
      'crossWindowPersistence': widget.crossWindowPersistence,
    };

    final settingsJson = jsonEncode(settings);

    await controller.evaluateJavascript(
      source: '''
window.adaSettings = {
  ...$settingsJson,
  lazy: true,
  parentElement: "content_frame",
  onAdaEmbedLoaded: () => {
     adaEmbed.subscribeEvent("ada:chat_frame_timeout", (data, context) => {
       window.flutter_inappwebview.callHandler("onLoaded", data);
     });
  },
  conversationEndCallback: function(event) {
    window.flutter_inappwebview.callHandler("onConversationEnd", event);
  },
  adaReadyCallback: function() {
    window.flutter_inappwebview.callHandler("onAdaReady");
  },
  toggleCallback: function(isDrawerOpen) {
    window.flutter_inappwebview.callHandler("onDrawerToggle", isDrawerOpen);
  },
  eventCallbacks: {
    "*": function(event) {
     window.flutter_inappwebview.callHandler("onEvent", JSON.stringify(event));
    }
  }
};
console.log("adaSettings updated");
''',
    );

    if (widget.autostart) {
      widget.controller?.start();
    }

    Future.delayed(
      widget.greetingDelay,
      () {
        if (widget.greeting != null && mounted) {
          widget.controller?.triggerAnswer(widget.greeting!);
        }
      },
    );
  }

  Future<void> _init(controller) async {
    widget.controller?.init(
      webViewController: controller,
      handle: widget.handle,
    );

    controller.addJavaScriptHandler(
      handlerName: 'onLoaded',
      callback: (data) => widget.onLoaded?.call(data),
    );

    controller.addJavaScriptHandler(
      handlerName: 'onConversationEnd',
      callback: (event) => widget.onConversationEnd?.call(event),
    );

    controller.addJavaScriptHandler(
      handlerName: 'onDrawerToggle',
      callback: (isDrawerOpen) =>
          widget.onDrawerToggle?.call(isDrawerOpen as bool),
    );

    controller.addJavaScriptHandler(
      handlerName: 'onAdaReady',
      callback: (_) => widget.onAdaReady?.call(),
    );

    controller.addJavaScriptHandler(
      handlerName: 'onEvent',
      callback: (event) => widget.onEvent?.call(event),
    );
  }

  Future<bool?> _onCreateWindow(
    InAppWebViewController controller,
    CreateWindowAction createWindowAction,
  ) async {
    /// This method is needed to open the link in the chat after user clicks on it.
    /// onCreateWindow() is called only on iOS, so for Android we need to have
    /// shouldOverrideUrlLoading() implemented.
    final uri = createWindowAction.request.url;

    if (!Platform.isIOS || uri == null) {
      return false;
    }

    InAppBrowser.openWithSystemBrowser(url: uri);
    return true;
  }

  Future<NavigationActionPolicy?> _shouldOverrideUrlLoading(
    InAppWebViewController controller,
    NavigationAction navigationAction,
  ) async {
    /// This method is needed to open the link in the chat after user clicks on it.
    /// shouldOverrideUrlLoading() is called both on iOS and Android, but for iOS
    /// openWithSystemBrowser() is not working here so we are just skipping
    /// with ALLOW and let the flow to get to the onCreateWindow() where opening
    /// the browser on iOS is working.
    final uri = navigationAction.request.url;

    if (!Platform.isAndroid || uri == null) {
      return NavigationActionPolicy.ALLOW;
    }

    InAppBrowser.openWithSystemBrowser(url: uri);
    return NavigationActionPolicy.CANCEL;
  }
}
