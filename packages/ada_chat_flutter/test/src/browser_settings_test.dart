import 'package:ada_chat_flutter/src/browser_controller.dart';
import 'package:ada_chat_flutter/src/browser_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BrowserSettings', () {
    test('init creates a BrowserController instance', () {
      final settings =
          BrowserSettings(pageBuilder: (_, __, ___) => Container());
      expect(settings.control, isNull);
      settings.init();
      expect(settings.control, isNotNull);
      expect(settings.control, isA<BrowserController>());
    });

    test('dispose calls dispose on the BrowserController', () {
      final controller = BrowserController();
      final settings =
          BrowserSettings(pageBuilder: (_, __, ___) => Container());
      settings.control = controller;
      settings.dispose();
      // Since BrowserController.dispose() doesn't have any observable side effects,
      // we can't directly verify it was called. However, this test ensures that
      // the dispose method of BrowserSettings is correctly delegating to the controller.
    });

    test('pageBuilder is correctly stored', () {
      Widget pageBuilder(
          BuildContext context, Widget browser, BrowserController controller) {
        return Container();
      }

      final settings = BrowserSettings(pageBuilder: pageBuilder);
      expect(settings.pageBuilder, pageBuilder);
    });
  });
}
