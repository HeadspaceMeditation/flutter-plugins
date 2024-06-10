import 'package:ada_chat_flutter/src/browser_controller.dart';
import 'package:ada_chat_flutter/src/browser_settings.dart';
import 'package:ada_chat_flutter/src/customized_web_view.dart';
import 'package:ada_chat_flutter/src/test/mock_web_view_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockInAppWebViewController extends Mock
    implements InAppWebViewController {}

class MockBrowserSettings extends Mock implements BrowserSettings {}

class MockBrowserController extends Mock implements BrowserController {}

class BuildContextMock extends Mock implements BuildContext {}

void main() {
  late MockInAppWebViewController mockWebViewController;
  late MockBrowserSettings mockBrowserSettings;
  late MockBrowserController mockBrowserController;

  final mockWebViewDependencies = MockWebViewDependencies();

  setUpAll(() {
    registerFallbackValue(BuildContextMock());
  });

  tearDown(() async {
    mockWebViewDependencies.tearDown();
  });

  setUp(() async {
    await mockWebViewDependencies.init();

    mockWebViewController = MockInAppWebViewController();
    mockBrowserSettings = MockBrowserSettings();
    mockBrowserController = MockBrowserController();

    when(() => mockBrowserSettings.control).thenReturn(mockBrowserController);
    when(() => mockBrowserSettings.pageBuilder).thenReturn(
      (context, browser, controller) => Container(child: browser),
    );
    when(() => mockWebViewController.getTitle())
        .thenAnswer((_) async => 'Test Title');
    when(() => mockWebViewController.canGoBack()).thenAnswer((_) async => true);
    when(() => mockWebViewController.canGoForward())
        .thenAnswer((_) async => false);
  });

  group('CustomizedWebView', () {
    testWidgets('initializes BrowserSettings', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CustomizedWebView(
            url: WebUri('https://www.example.com'),
            browserSettings: mockBrowserSettings,
          ),
        ),
      );

      verify(() => mockBrowserSettings.init()).called(1);
    });

    testWidgets('disposes BrowserSettings', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CustomizedWebView(
            url: WebUri('https://www.example.com'),
            browserSettings: mockBrowserSettings,
          ),
        ),
      );
      await tester.pumpWidget(Container()); // Trigger dispose

      verify(() => mockBrowserSettings.dispose()).called(1);
    });

    testWidgets('uses pageBuilder if provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CustomizedWebView(
            url: WebUri('https://www.example.com'),
            browserSettings: mockBrowserSettings,
          ),
        ),
      );

      expect(find.byType(Container),
          findsOneWidget); // Assuming pageBuilder returns a Container
    });
  });
}
