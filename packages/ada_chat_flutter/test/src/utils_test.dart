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

    group('isBlankPage tests - ', () {
      test('isBlankPage returns true for about:blank', () {
        expect(isBlankPage(Uri.parse('about:blank')), isTrue);
      });

      test('isBlankPage returns false for other URLs', () {
        expect(isBlankPage(Uri.parse('https://example.com')), isFalse);
      });
    });

    group('isAdaSupportLink tests - ', () {
      const handle = 'test-handle';

      test('isAdaSupportLink returns true for valid Ada support links', () {
        expect(
            isAdaSupportLink(
                Uri.parse('https://test-handle.ada.support'), handle),
            isTrue);
      });

      test('isAdaSupportLink returns false for invalid Ada support links', () {
        expect(isAdaSupportLink(Uri.parse('https://example.com'), handle),
            isFalse);
      });
    });

    group('isAdaChatLink tests - ', () {
      final embedUri = Uri.parse('https://example.com/embed.html');

      test('isAdaChatLink returns true for matching embed URIs', () {
        expect(isAdaChatLink(embedUri, embedUri), isTrue);
      });

      test('isAdaChatLink returns false for non-matching embed URIs', () {
        expect(
            isAdaChatLink(Uri.parse('https://example.com'), embedUri), isFalse);
      });
    });

    group('isInternalAdaUrl tests - ', () {
      final embedUri = Uri.parse('https://example.com/embed.html');
      const handle = 'test-handle';

      test('isInternalAdaUrl returns true for valid internal Ada URLs', () {
        expect(isInternalAdaUrl(embedUri, embedUri, handle), isTrue);
        expect(
            isInternalAdaUrl(
                Uri.parse('https://test-handle.ada.support'), embedUri, handle),
            isTrue);
        expect(isInternalAdaUrl(Uri.parse('about:blank'), embedUri, handle),
            isTrue);
      });

      test('isInternalAdaUrl returns false for invalid internal Ada URLs', () {
        expect(
            isInternalAdaUrl(
                Uri.parse('https://example.com'), embedUri, handle),
            isFalse);
      });
    });

    group('jsonStrToMap', () {
      test('returns empty map for empty string', () {
        expect(jsonStrToMap(''), isEmpty);
        expect(jsonStrToMap(''), isA<Map<String, dynamic>>());
      });

      test('decodes valid JSON string to map', () {
        const jsonString = '{"key1": "value1", "key2": 123}';
        final result = jsonStrToMap(jsonString);

        expect(result, isA<Map<String, dynamic>>());
        expect(result['key1'], equals('value1'));
        expect(result['key2'], equals(123));
      });
    });
  });
}
