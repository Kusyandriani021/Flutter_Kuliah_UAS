import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/todo_controller.dart';
import 'views/home_page.dart';
import 'views/add_todo_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/add': (_) => const AddTodoPage(),
      },
    );
  }
}
