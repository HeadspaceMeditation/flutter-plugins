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
  String? _title;
  bool _goBackIsAvailable = false;
  bool _goForwardIsAvailable = false;

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
              onAdaReady: (isRolledOut) {
                debugPrint(
                    'AdaChatScreen:onAdaReady: isRolledOut=$isRolledOut');
                setState(() => _progress = 0);
              },
              browserController: _getBrowserController,
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

  BrowserController get _getBrowserController {
    return BrowserController(
      pageBuilder: (context, browser, controls) => Stack(
        children: [
          browser,
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: _goBackIsAvailable ? controls.goBack : null,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _goForwardIsAvailable ? controls.goForward : null,
                ),
                Expanded(
                  child: Text(
                    _title ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.green),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: Navigator.of(context).pop,
                ),
              ],
            ),
          ),

          // Placeholder(),
        ],
      ),
      onGoBackChanged: (isAvailable) {
        debugPrint('@@@ onGoBackChanged: isAvailable=$isAvailable');
        setState(() {
          _goBackIsAvailable = isAvailable;
        });
      },
      onGoForwardChanged: (isAvailable) {
        debugPrint('@@@ onGoForwardChanged: isAvailable=$isAvailable');
        setState(() {
          _goForwardIsAvailable = isAvailable;
        });
      },
      onTitleChanged: (text) {
        debugPrint('@@@ onTitleChanged: text=$text');
        setState(() {
          _title = text;
        });
      },
    );
  }

  bool get _isNotLoading => _progress == 0 || _progress == 1;
}
