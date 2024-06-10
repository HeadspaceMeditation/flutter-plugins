import 'package:ada_chat_flutter/src/ada_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdaException', () {
    test('toString returns correct format', () {
      const error = 'Some error message';
      final exception = AdaException(error);
      expect(exception.toString(), 'AdaException{error: $error}');
    });
  });

  group('AdaExecException', () {
    test('toString returns correct format', () {
      const error = 'Execution error';
      final exception = AdaExecException(error);
      expect(exception.toString(), 'AdaExecException{error: $error}');
    });
  });

  group('AdaNullResultException', () {
    test('toString returns correct format', () {
      final exception = AdaNullResultException();
      expect(
        exception.toString(),
        'AdaNullResultException{error: Result is null}',
      );
    });
  });
}
