import 'dart:convert';

import 'package:ada_chat_flutter/src/ada_controller_init.dart';
import 'package:ada_chat_flutter/src/ada_exception.dart';

typedef FlatObject = Map<String, Object?>;

/// More info about the Ada chat API can be found here:
/// https://developers.ada.cx/reference/embed2-reference
class AdaController extends AdaControllerInit {
  @override
  Future<void> start() => webViewController.evaluateJavascript(
        source: '''
(function() {
  adaEmbed.start({
    handle: "$handle",
    parentElement: "content_frame"
  });
})();
''',
      );

  Future<void> deleteHistory() => webViewController.evaluateJavascript(
        source: '''
(function() {
  adaEmbed.deleteHistory();
})();
''',
      );

  Future<Map<String, bool>> getInfo() async {
    final result = await webViewController.callAsyncJavaScript(
      functionBody: '''
return await adaEmbed.getInfo();
''',
    );

    if (result == null) {
      throw const AdaNullResultException();
    } else if (result.error != null) {
      throw AdaExecException(result.error!);
    }

    return (result.value as Map<Object?, Object?>)
        .map((key, value) => MapEntry(key as String, value as bool));
  }

  Future<void> reset() => webViewController.evaluateJavascript(
        source: '''
(function() {
  adaEmbed.reset();
})();
''',
      );

  Future<void> setLanguage(String language) =>
      webViewController.evaluateJavascript(
        source: '''
(function() {
  adaEmbed.setLanguage("$language");
})();
''',
      );

  Future<void> setMetaFields(FlatObject meta) async {
    final metaJson = jsonEncode(meta);

    await webViewController.evaluateJavascript(
      source: '''
(function() {
  adaEmbed.setMetaFields($metaJson);
})();
''',
    );
  }

  Future<void> setSensitiveMetaFields(FlatObject meta) async {
    final metaJson = jsonEncode(meta);

    await webViewController.evaluateJavascript(
      source: '''
(function() {
  adaEmbed.setSensitiveMetaFields($metaJson);
})();
''',
    );
  }

  Future<void> stop() => webViewController.evaluateJavascript(
        source: '''
(function() {
  adaEmbed.stop();
})();
''',
      );

  @override
  Future<void> triggerAnswer(String answerId) =>
      webViewController.evaluateJavascript(
        source: '''
(function() {
  adaEmbed.triggerAnswer("$answerId");
})();
''',
      );
}
