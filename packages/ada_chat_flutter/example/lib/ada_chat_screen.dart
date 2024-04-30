import 'package:ada_chat_flutter/ada_chat_flutter.dart';
import 'package:example/commands_menu.dart';
import 'package:flutter/material.dart';

class AdaChatScreen extends StatefulWidget {
  const AdaChatScreen({
    super.key,
    this.greeting,
  });

  final String? greeting;

  @override
  State<AdaChatScreen> createState() => _AdaChatScreenState();
}

class _AdaChatScreenState extends State<AdaChatScreen> {
  final _adaController = AdaController();
  var _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Ada chat'),
          actions: [
            CommandsMenu(adaController: _adaController),
          ],
        ),
        body: Stack(
          children: [
            AdaWebView(
              handle: 'headspace-sandbox',
              name: 'Example user',
              email: 'qqq@google.com',
              phone: '+5342342131324',
              greeting: widget.greeting,
              controller: _adaController,
              language: 'en',
              metaFields: const {
                'userid': '1234567890',
                'keyStr': 'value3',
                'keyBool': false,
                'keyDouble': 3.456789,
                'keyInt': 42,
                'keyNull': null,
              },
              sensitiveMetaFields: const {
                'keySens': 'valueSens',
              },
              onProgressChanged: (progress) => setState(() {
                _progress = progress / 100;
              }),
              onAdaReady: () {
                debugPrint('AdaChatScreen:onAdaReady');
                setState(() => _progress = 0);
              },
              onLoaded: (data) =>
                  debugPrint('AdaChatScreen:onLoaded: data=$data'),
              onEvent: (event) =>
                  debugPrint('AdaChatScreen:onEvent: event=$event'),
              onConsoleMessage: (level, message) =>
                  debugPrint('AdaChatScreen:onConsoleMessage: '
                      'level=$level, message=$message'),
              onConversationEnd: (event) =>
                  debugPrint('AdaChatScreen:onConversationEnd: event=$event'),
              onDrawerToggle: (isDrawerOpen) => debugPrint(
                  'AdaChatScreen:onConversationEnd: isDrawerOpen=$isDrawerOpen'),
              onLoadingError: (request, error) =>
                  debugPrint('AdaChatScreen:onLoadingError: '
                      'request=$request, error=$error'),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              top: _isNotLoading ? -5 : 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(value: _progress, minHeight: 5),
            ),
          ],
        ),
      ),
    );
  }

  bool get _isNotLoading => _progress == 0 || _progress == 1;
}
