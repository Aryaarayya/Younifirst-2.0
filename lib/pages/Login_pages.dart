import 'package:flutter/material.dart';
import 'package:younifirst_app/pages/Home_pages.dart';
import 'package:younifirst_app/widgets/bottom_navbar.dart';

class Login_pages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [

                SizedBox(height: 40),

                // 🔵 LOGO + ICON
                Stack(
                  alignment: Alignment.center,
                  children: [

                    // Lingkaran biru
                    Container(
                      width: screenWidth * 0.45,
                      height: screenWidth * 0.45,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/background_login.png'),
                          
                        ),
                      ),
                    ),

                    // Gambar utama (interaksi)
                    Image.asset(
                      'assets/images/icon_login.png',
                      width: screenWidth * 0.35,
                    ),

                    // Bintang
                    Positioned(
                      left: 20,
                      top: 30,
                      child: Image.asset(
                        'assets/images/item_login.png',
                        width: 30,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // TEXT
                Text(
                  "Selamat Datang!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 30),

                // EMAIL
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Email SSO"),
                ),
                SizedBox(height: 8),

                TextField(
                  decoration: InputDecoration(
                    hintText: "Masukkan email SSO Anda",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // PASSWORD
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Kata Sandi"),
                ),
                SizedBox(height: 8),

                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Masukkan kata sandi Anda",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // LUPA PASSWORD
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Lupa Kata Sandi?",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                SizedBox(height: 25),

                // BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavbar(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3D5AF1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      "MASUK",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}