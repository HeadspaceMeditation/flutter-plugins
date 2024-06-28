import 'package:ada_chat_flutter/src/browser_controller.dart';
import 'package:ada_chat_flutter/src/browser_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BrowserSettings', () {
    test('init creates a BrowserController instance', () {
      final settings = BrowserSettings(
        pageBuilder: (_, __, ___) => Container(),
      );
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
    });

    test('pageBuilder is correctly stored', () {
      Widget pageBuilder(
        BuildContext context,
        Widget browser,
        BrowserController controller,
      ) {
        return Container();
      }

      final settings = BrowserSettings(pageBuilder: pageBuilder);
      expect(settings.pageBuilder, pageBuilder);
    });

    test('adaHideUrls is correctly stored', () {
      final regexp = RegExp(r'^something$');
      final settings = BrowserSettings(
        pageBuilder: (_, __, ___) => Container(),
        adaHideUrls: [regexp],
      );
      expect(settings.adaHideUrls.length, equals(1));
      expect(settings.adaHideUrls, contains(regexp));
    });
  });
}
