import 'package:flutter/material.dart';
import 'package:younifirst_app/widgets/bottom_navbar.dart';
import 'package:younifirst_app/services/auth_service.dart';
import 'pages/splashscreen.dart';
import 'pages/login_pages.dart';

void main() async {
  // Pastikan WidgetsFlutterBinding di-initialize sebelum memanggil fungsi async
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load session pengguna dari SharedPreferences
  await AuthService.loadSession();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Younifirst App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Splashscreen(),
        '/login': (context) => Login_pages(),
        '/home': (context) => BottomNavbar(),
      },
    );
  }
}