import 'dart:async';
import 'dart:convert';

import 'package:ada_chat_flutter/src/ada_controller.dart';
import 'package:ada_chat_flutter/src/ada_controller_init.dart';
import 'package:ada_chat_flutter/src/browser_settings.dart';
import 'package:ada_chat_flutter/src/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_android/webview_flutter_android.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

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
    this.browserSettings,
    this.onAdaReady,
    this.onLoaded,
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
  final Uri? urlRequest; // todo Rename to embedUri

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

  final BrowserSettings? browserSettings;

  final void Function(dynamic data)? onLoaded;
  final void Function(dynamic isRolledOut)? onAdaReady;
  final void Function(dynamic event)? onEvent;
  final void Function(dynamic event)? onConversationEnd;
  final void Function(dynamic isDrawerOpen)? onDrawerToggle;
  final void Function(String level, String message)? onConsoleMessage;
  final void Function(String request, String response)? onLoadingError;

  @override
  State<AdaWebView> createState() => _AdaWebViewState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('handle', handle));
    properties.add(StringProperty('name', name));
    properties.add(StringProperty('email', email));
    properties.add(StringProperty('phone', phone));
    properties.add(DiagnosticsProperty<Uri?>('urlRequest', urlRequest));
    properties.add(StringProperty('language', language));
    properties.add(StringProperty('cluster', cluster));
    properties.add(StringProperty('domain', domain));
    properties.add(DiagnosticsProperty<bool>('hideMask', hideMask));
    properties.add(StringProperty('greeting', greeting));
    properties
        .add(DiagnosticsProperty<Duration>('greetingDelay', greetingDelay));
    properties.add(DiagnosticsProperty<bool>('privateMode', privateMode));
    properties.add(DiagnosticsProperty<FlatObject>('metaFields', metaFields));
    properties.add(
      DiagnosticsProperty<FlatObject>(
        'sensitiveMetaFields',
        sensitiveMetaFields,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'crossWindowPersistence',
        crossWindowPersistence,
      ),
    );
    properties.add(DiagnosticsProperty<bool>('autostart', autostart));
    properties.add(DoubleProperty('rolloutOverride', rolloutOverride));
    properties.add(DiagnosticsProperty<bool>('testMode', testMode));
  }
}

class _AdaWebViewState extends State<AdaWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        limitsNavigationsToAppBoundDomains: false, // todo Remove?
      );
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params);

    final platform = _controller.platform;
    if (platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
    }
    // else if (platform is WebKitWebViewController) {}

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setOnConsoleMessage(_onConsoleMessage)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onHttpAuthRequest: _onHttpAuthRequest,
          onUrlChange: _onUrlChange,
          onProgress: _onProgress,
          onPageStarted: _onPageStarted,
          onPageFinished: _onPageFinished,
          onHttpError: _onHttpError,
          onWebResourceError: _onWebResourceError,
          onNavigationRequest: _onNavigationRequest,
        ),
      );

    if (widget.urlRequest == null) {
      _controller
          .loadFlutterAsset('packages/ada_chat_flutter/assets/embed.html');
    } else {
      _controller.loadRequest(widget.urlRequest!);
    }
  }

  void _onConsoleMessage(JavaScriptConsoleMessage message) =>
      widget.onConsoleMessage?.call(message.level.toString(), message.message);

  FutureOr<NavigationDecision> _onNavigationRequest(NavigationRequest request) {
    print('AdaWebView:onNavigationRequest: '
        'url=${request.url}');
    // if (request.url.startsWith('https://www.youtube.com/')) {
    //   return NavigationDecision.prevent;
    // }
    return NavigationDecision.navigate;
  }

  void _onWebResourceError(WebResourceError error) {
    print('AdaWebView:onWebResourceError: '
        'errorCode=${error.errorCode}, '
        'description=${error.description}');
  }

  void _onHttpError(HttpResponseError error) => widget.onLoadingError
      ?.call(error.request.toString(), error.response.toString());

  void _onPageFinished(String url) {
    print('AdaWebView:onPageFinished: url=$url');

    _start();
  }

  void _onPageStarted(String url) {
    print('AdaWebView:onPageStarted: url=$url');

    _init();
  }

  void _onProgress(int progress) => widget.onProgressChanged?.call(progress);

  void _onUrlChange(UrlChange change) {
    print('AdaWebView:onUrlChange: url=${change.url}');
  }

  void _onHttpAuthRequest(HttpAuthRequest request) {
    print('AdaWebView:onHttpAuthRequest: host=${request.host}');
  }

  @override
  Widget build(BuildContext context) => WebViewWidget(controller: _controller);

  Future<void> _start() async {
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

    await _controller.runJavaScript(
      '''
window.adaSettings = {
  ...$settingsJson,
  lazy: true,
  parentElement: "content_frame",
  adaReadyCallback: function(isRolledOut) {
    onAdaReady.postMessage(JSON.stringify(isRolledOut));
  },
  onAdaEmbedLoaded: () => {
    adaEmbed.subscribeEvent("ada:chat_frame_timeout", (data, context) => {
      onLoaded.postMessage(data === undefined ? "" : JSON.stringify(data));
    });
  },
  conversationEndCallback: function(event) {
    console.log("onConversationEnd: " + JSON.stringify(event));
    onConversationEnd.postMessage(JSON.stringify(event));
  },
  toggleCallback: function(isDrawerOpen) {
    console.log("onDrawerToggle: " + JSON.stringify(isDrawerOpen));
    onDrawerToggle.postMessage(JSON.stringify(isDrawerOpen));
  },
  eventCallbacks: {
    "*": function(event) {
      console.log("onEvent: " + JSON.stringify(event));
      onEvent.postMessage(JSON.stringify(event));
    }
  }
};
console.log("adaSettings: " + JSON.stringify(window.adaSettings));
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

  Future<void> _init() async {
    widget.controller?.init(
      webViewController: _controller,
      handle: widget.handle,
    );

    await _controller.addJavaScriptChannel(
      'onLoaded',
      onMessageReceived: (JavaScriptMessage message) {
        final json = jsonStrToMap(message.message);
        widget.onLoaded?.call(json);
      },
    );

    await _controller.addJavaScriptChannel(
      'onConversationEnd',
      onMessageReceived: (JavaScriptMessage message) {
        final json = jsonStrToMap(message.message);
        widget.onConversationEnd?.call(json);
      },
    );

    await _controller.addJavaScriptChannel(
      'onDrawerToggle',
      onMessageReceived: (JavaScriptMessage message) {
        final json = jsonStrToMap(message.message);
        widget.onDrawerToggle?.call(json);
      },
    );

    await _controller.addJavaScriptChannel(
      'onAdaReady',
      onMessageReceived: (JavaScriptMessage message) {
        final json = jsonStrToMap(message.message);
        widget.onAdaReady?.call(json);
      },
    );

    await _controller.addJavaScriptChannel(
      'onEvent',
      onMessageReceived: (JavaScriptMessage message) {
        final json = jsonStrToMap(message.message);
        widget.onEvent?.call(json);
      },
    );
  }

  dynamic jsonStrToMap(String message) {
    if (message.isEmpty) {
      return <String, dynamic>{};
    }

    return jsonDecode(message);
  }

  // Future<NavigationActionPolicy?> _shouldOverrideUrlLoading(
  //   InAppWebViewController controller,
  //   NavigationAction navigationAction,
  // ) async {
  //   final url = navigationAction.request.url;
  //   debugPrint('_shouldOverrideUrlLoading: $url, host=${url?.host}');
  //
  //   if (url == null ||
  //       url.toString() == 'about:blank' ||
  //       url.toString() == widget.urlRequest?.url.toString() ||
  //       url.toString().endsWith('/ada_chat_flutter/assets/embed.html') ||
  //       url.host == '${widget.handle}.ada.support') {
  //     return NavigationActionPolicy.ALLOW;
  //   }
  //
  //   unawaited(
  //     showAdaptiveDialog(
  //       context: context,
  //       barrierColor: Colors.transparent,
  //       builder: (context) => CustomizedWebView(
  //         url: url,
  //         browserSettings: widget.browserSettings,
  //       ),
  //       useRootNavigator: false,
  //     ),
  //   );
  //
  //   return NavigationActionPolicy.CANCEL;
  // }
}
