import 'dart:developer';

import 'package:ada_chat_flutter/ada_chat_flutter.dart';
import 'package:example/webview_controls/page_with_controls.dart';
import 'package:example/widgets/commands_menu.dart';
import 'package:example/widgets/progress_bar.dart';
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
  var _progress = 0;

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
                urlRequest: Uri.parse(
                  'https://your.domain.com/embed.html',
                ),
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
                  _progress = progress;
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
                onLoaded: (data) => log('AdaChatScreen:onLoaded: data=$data'),
                onAdaReady: (isRolledOut) {
                  log('AdaChatScreen:onAdaReady: isRolledOut=$isRolledOut');
                  setState(() => _progress = 0);
                },
                onEvent: (event) => log('AdaChatScreen:onEvent: event=$event'),
                onConsoleMessage: (level, message) =>
                    log('AdaChatScreen:onConsoleMessage: '
                        'level=$level, message=$message'),
                onConversationEnd: (event) =>
                    log('AdaChatScreen:onConversationEnd: event=$event'),
                onDrawerToggle: (isDrawerOpen) =>
                    log('AdaChatScreen:onDrawerToggle: '
                        'isDrawerOpen=$isDrawerOpen'),
                onLoadingError: (request, response) =>
                    log('AdaChatScreen:onLoadingError: '
                        'request=$request, response=$response'),
              ),
              ProgressBar(progress: _progress),
            ],
          ),
        ),
      );
}
