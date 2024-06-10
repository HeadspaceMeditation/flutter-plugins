import 'package:flutter/material.dart';

class SetMetaFieldDialog extends StatefulWidget {
  const SetMetaFieldDialog({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<SetMetaFieldDialog> createState() => _SetMetaFieldDialogState();
}

class _SetMetaFieldDialogState extends State<SetMetaFieldDialog> {
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _keyController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'key',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _valueController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'value',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          TextButton(
            child: const Text('Set'),
            onPressed: () => Navigator.of(context).pop({
              _keyController.text: _valueController.text,
            }),
          ),
        ],
      );
}
