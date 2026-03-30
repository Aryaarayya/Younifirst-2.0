import 'package:flutter/material.dart';
import 'dart:async';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<Offset> topAnimation;
  late Animation<Offset> bottomAnimation;
  late Animation<Offset> rightAnimation;

  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    // 🎓 dari atas
    topAnimation = Tween<Offset>(
      begin: Offset(0, -2),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    //dari tengah 
    
    // 📝 dari bawah
    bottomAnimation = Tween<Offset>(
      begin: Offset(0, 2),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // ✨ dari kanan
    rightAnimation = Tween<Offset>(
      begin: Offset(2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // fade
    fadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(_controller);

    _controller.forward();

    // pindah ke login
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [

          // 🎓 Topi Wisuda (dari atas)
          SlideTransition(
            position: topAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 220),
                  child: Image.asset(
                    'assets/images/Topi Wisuda.png',
                    width: 100,
                  ),
                ),
              ),
            ),
          ),

          // ✨ Bintang (dari kanan)
          SlideTransition(
            position: rightAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Align(
                alignment: Alignment(0.9 , -0.1),
                child: Padding(
                  padding: EdgeInsets.only(right: 150),
                  child: Image.asset(
                    'assets/images/Bintang.png',
                    width: 60,
                  ),
                ),
              ),
            ),
          ),

          // 🌐 Lingkaran dalam (dari tengah)
            FadeTransition(
              opacity: fadeAnimation,
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/Lingkaran dalam.png',
                  width: 200,
                ),
              ),
            ),
            
          // 🌐 Interaksi (dari tengah)
            FadeTransition(
              opacity: fadeAnimation,
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/Interaksi.png',
                  width: 150,
                ),
              ),
            ),
          
          // 📝 Younifirst (dari bawah)
          SlideTransition(
            position: bottomAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 200),
                  child: Image.asset(
                    'assets/images/Younifirst.png',
                    width: 180,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

