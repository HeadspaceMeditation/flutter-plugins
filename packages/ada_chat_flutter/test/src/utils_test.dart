import 'package:ada_chat_flutter/src/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Utils tests - ', () {
    group('getOsName tests - ', () {
      tearDown(() => debugDefaultTargetPlatformOverride = null);

      test(
          'WHEN getOsName is called on Android '
          'THEN should return correct os name', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;

        expect(getOsName, equals('ANDROID'));
      });

      test(
          'WHEN getOsName is called on iOS '
          'THEN should return correct os name', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        expect(getOsName, equals('IOS'));
      });

      test(
          'WHEN getOsName is called on some other platform '
          'THEN should return N/A', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

        expect(getOsName, equals('N/A'));
      });
    });
  });
}
