import 'package:ada_chat_flutter/src/ada_web_view.dart';
import 'package:ada_chat_flutter/src/test/mock_web_view_dependencies.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BuildContextMock extends Mock implements BuildContext {}

void main() {
  final mockWebViewDependencies = MockWebViewDependencies();

  setUpAll(() {
    registerFallbackValue(BuildContextMock());
  });

  setUp(() async {
    await mockWebViewDependencies.init();
  });

  tearDown(() async {
    mockWebViewDependencies.tearDown();
  });

  testWidgets(
    'WHEN AdaWebView is shown '
    'THEN should InAppWebView should be visible',
    (tester) async {
      await tester.pumpWidget(
        AdaWebView(handle: 'test_handle'),
      );

      expect(find.byType(InAppWebView), findsOne);
    },
  );
}
