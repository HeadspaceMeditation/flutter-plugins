import 'dart:convert';

import 'package:ada_chat_flutter/src/ada_controller_init.dart';

typedef FlatObject = Map<String, Object?>;

/// More info about the Ada chat API can be found here:
/// https://developers.ada.cx/reference/embed2-reference
class AdaController extends AdaControllerInit {
  @override
  Future<void> start() => webViewController.runJavaScript(
        // todo Check if function(){}() wrapper is needed
        '''
(function() {
  adaEmbed.start({
    handle: "$handle",
    parentElement: "content_frame"
  });
})();
''',
      );

  Future<void> deleteHistory() => webViewController.runJavaScript(
        '''
(function() {
  adaEmbed.deleteHistory();
})();
''',
      );

  Future<Object> getInfo() async {
    return await webViewController.runJavaScriptReturningResult(
      '''
return await adaEmbed.getInfo();
''',
    );
  }

  Future<void> reset() => webViewController.runJavaScript(
        '''
(function() {
  adaEmbed.reset();
})();
''',
      );

  Future<void> setLanguage(String language) => webViewController.runJavaScript(
        '''
(function() {
  adaEmbed.setLanguage("$language");
})();
''',
      );

  Future<void> setMetaFields(FlatObject meta) async {
    final metaJson = jsonEncode(meta);

    await webViewController.runJavaScript(
      '''
(function() {
  adaEmbed.setMetaFields($metaJson);
})();
''',
    );
  }

  Future<void> setSensitiveMetaFields(FlatObject meta) async {
    final metaJson = jsonEncode(meta);

    await webViewController.runJavaScript(
      '''
(function() {
  adaEmbed.setSensitiveMetaFields($metaJson);
})();
''',
    );
  }

  Future<void> stop() => webViewController.runJavaScript(
        '''
(function() {
  adaEmbed.stop();
})();
''',
      );

  @override
  Future<void> triggerAnswer(String answerId) =>
      webViewController.runJavaScript(
        '''
(function() {
  adaEmbed.triggerAnswer("$answerId");
})();
''',
      );
}
