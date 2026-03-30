import 'package:flutter/material.dart';
import 'package:younifirst_app/widgets/bottom_navbar.dart';
import 'pages/Splashscreen.dart';
import 'pages/Login_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Splashscreen(),
        '/login': (context) => Login_pages(),
        '/home': (context) => BottomNavbar(),
      },
    );
  }
}