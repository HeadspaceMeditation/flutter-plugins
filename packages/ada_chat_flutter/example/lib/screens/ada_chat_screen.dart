import 'package:ada_chat_flutter/ada_chat_flutter.dart';
import 'package:example/webview_controls/page_with_controls.dart';
import 'package:example/widgets/commands_menu.dart';
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
  Widget build(BuildContext context) => SafeArea(
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
                handle: 'example-handle',
                name: 'User 1',
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
                rolloutOverride: 1,
                sensitiveMetaFields: const {
                  'keySens': 'valueSens',
                },
                onProgressChanged: (progress) => setState(() {
                  _progress = progress / 100;
                }),
                browserSettings: BrowserSettings(
                  pageBuilder: (context, browser, controller) => Scaffold(
                    body: SafeArea(
                      child: PageWithControls(
                        controller: controller,
                        child: browser,
                      ),
                    ),
                  ),
                ),
                onLoaded: (data) =>
                    debugPrint('AdaChatScreen:onLoaded: data=$data'),
                onAdaReady: (isRolledOut) {
                  debugPrint(
                      'AdaChatScreen:onAdaReady: isRolledOut=$isRolledOut');
                  setState(() => _progress = 0);
                },
                onEvent: (event) =>
                    debugPrint('AdaChatScreen:onEvent: event=$event'),
                onConsoleMessage: (level, message) =>
                    debugPrint('AdaChatScreen:onConsoleMessage: '
                        'level=$level, message=$message'),
                onConversationEnd: (event) =>
                    debugPrint('AdaChatScreen:onConversationEnd: event=$event'),
                onDrawerToggle: (isDrawerOpen) => debugPrint(
                    'AdaChatScreen:onConversationEnd: isDrawerOpen=$isDrawerOpen'),
                onLoadingError: (request, response) =>
                    debugPrint('AdaChatScreen:onLoadingError: '
                        'request=$request, response=$response'),
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

  bool get _isNotLoading => _progress == 0 || _progress == 1;
}
