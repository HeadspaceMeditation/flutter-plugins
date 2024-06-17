import 'package:example/screens/ada_chat_screen.dart';
import 'package:example/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
          useMaterial3: false,
        ),
        darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.orange,
            brightness: Brightness.dark,
          ),
          useMaterial3: false,
        ),
        themeMode: ThemeMode.system,
        onGenerateRoute: (route) {
          switch (route.name) {
            case '/ada':
              final greeting =
                  (route.arguments as Map<String, dynamic>?)?['greeting'];
              return MaterialPageRoute(
                builder: (_) => AdaChatScreen(
                  greeting: greeting,
                ),
              );
            case '/':
            default:
              return MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              );
          }
        },
      );
}
