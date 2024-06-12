import 'package:ada_chat_flutter/ada_chat_flutter.dart';
import 'package:example/widgets/set_meta_field_dialog.dart';
import 'package:flutter/material.dart';

class CommandsMenu extends StatelessWidget {
  const CommandsMenu({
    super.key,
    required this.adaController,
  });

  final AdaController adaController;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Icon(Icons.menu),
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () => _reopenWithGreeting(
                  context: context,
                  greeting: '65dcc11d3ca650a86a05847e',
                ),
                child: const Text("Hi I'm Frankie"),
              ),
              PopupMenuItem(
                onTap: () => _reopenWithGreeting(
                  context: context,
                  greeting: '65fb81bbb49313edcc214f67',
                ),
                child: const Text('Getting started'),
              ),
              PopupMenuItem(
                onTap: () => _reopenWithGreeting(
                  context: context,
                  greeting: '65dcc11d3ca650a86a0585f1',
                ),
                child: const Text('Email error'),
              ),
              PopupMenuItem(
                onTap: () => _reopenWithGreeting(
                  context: context,
                  greeting: '65dcc11d3ca650a86a0584a3',
                ),
                child: const Text('Choosing a clinician'),
              ),
              PopupMenuItem(
                onTap: () => _reopenWithGreeting(
                  context: context,
                  greeting: '65dcc11d3ca650a86a0584e0',
                ),
                child: const Text('MFA'),
              ),
            ],
            child: const ListTile(
              leading: Icon(Icons.hail),
              title: Text('Reopen with greeting...'),
            ),
          ),
        ),
        PopupMenuItem(
          child: PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () =>
                    adaController.triggerAnswer('65dcc11d3ca650a86a05847e'),
                child: const Text("Hi I'm Frankie"),
              ),
              PopupMenuItem(
                onTap: () =>
                    adaController.triggerAnswer('65fb81bbb49313edcc214f67'),
                child: const Text('Getting started'),
              ),
              PopupMenuItem(
                onTap: () =>
                    adaController.triggerAnswer('65dcc11d3ca650a86a0585f1'),
                child: const Text('Email error'),
              ),
              PopupMenuItem(
                onTap: () =>
                    adaController.triggerAnswer('65dcc11d3ca650a86a0584a3'),
                child: const Text('Choosing a clinician'),
              ),
              PopupMenuItem(
                onTap: () =>
                    adaController.triggerAnswer('65dcc11d3ca650a86a0584e0'),
                child: const Text('MFA'),
              ),
            ],
            child: const ListTile(
              leading: Icon(Icons.chat),
              title: Text('triggerAnswer...'),
            ),
          ),
        ),
        PopupMenuItem(
          child: PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () {
                  adaController.setLanguage('en');
                  Navigator.of(context).pop();
                },
                child: const Text('🇺🇸'),
              ),
              PopupMenuItem(
                onTap: () {
                  adaController.setLanguage('fr');
                  Navigator.of(context).pop();
                },
                child: const Text('🇫🇷'),
              ),
              PopupMenuItem(
                onTap: () {
                  adaController.setLanguage('es');
                  Navigator.of(context).pop();
                },
                child: const Text('🇪🇸'),
              ),
            ],
            child: const ListTile(
              leading: Icon(Icons.language),
              title: Text('setLanguage...'),
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            Future.delayed(
              Duration.zero,
              () => execSetMetaFields(context),
            );
          },
          child: const ListTile(
            leading: Icon(Icons.dataset),
            title: Text('setMetaFields...'),
          ),
        ),
        PopupMenuItem(
          onTap: () async => Future.delayed(
            Duration.zero,
            () => execSetSensMetaFields(context),
          ),
          child: const ListTile(
            leading: Icon(Icons.dataset_linked),
            title: Text('setSensitiveMetaFields...'),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            Future.delayed(
              Duration.zero,
              () => execGetInfo(context),
            );
          },
          child: const ListTile(
            leading: Icon(Icons.info),
            title: Text('getInfo'),
          ),
        ),
        PopupMenuItem(
          onTap: () => adaController.deleteHistory(),
          child: const ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text('deleteHistory'),
          ),
        ),
        PopupMenuItem(
          onTap: () => adaController.reset(),
          child: const ListTile(
            leading: Icon(Icons.refresh),
            title: Text('reset'),
          ),
        ),
        PopupMenuItem(
          onTap: () => adaController.stop(),
          child: const ListTile(
            leading: Icon(Icons.stop_circle),
            title: Text('stop'),
          ),
        ),
      ],
    );
  }

  void _reopenWithGreeting({
    required BuildContext context,
    required String greeting,
  }) {
    Navigator.of(context).popUntil((route) => route.isFirst);

    Navigator.of(context).pushNamed(
      '/ada',
      arguments: {
        'greeting': greeting,
      },
    );
  }

  Future<void> execSetSensMetaFields(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => const SetMetaFieldDialog(
        title: 'Set Sensitive Meta Field',
      ),
    );

    if (result is Map<String, String>) {
      adaController.setSensitiveMetaFields(result);
    }
  }

  Future<void> execSetMetaFields(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (_) => const SetMetaFieldDialog(
        title: 'Set Meta Field',
      ),
    );

    if (result is Map<String, String>) {
      adaController.setMetaFields(result);
    }
  }

  Future<void> execGetInfo(BuildContext context) async {
    final info = await adaController.getInfo();

    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Get Info Command Result',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          content: Text('$info'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}
