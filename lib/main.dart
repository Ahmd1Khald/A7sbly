import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'هتعدي يادفعة',
      theme: ThemeData(
        focusColor: Colors.deepPurple,
        disabledColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
        splashColor: Colors.deepPurple,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        focusColor: Colors.deepPurple,
        disabledColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
        splashColor: Colors.deepPurple,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      themeMode: ThemeMode
          .system, // Automatically switch between light and dark mode based on system settings
      home: const HomeScreen(),
    );
  }
}
