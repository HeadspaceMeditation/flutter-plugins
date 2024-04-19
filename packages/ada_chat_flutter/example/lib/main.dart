import 'package:example/ada_chat_screen.dart';
import 'package:example/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
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
