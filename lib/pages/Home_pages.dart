import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( // ✅ TAMBAHKAN INI
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 35,
                  ),

                  Stack(
                    children: [
                      Icon(Icons.notifications_none),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "2",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),

              Divider(),

              SizedBox(height: 10),

              Text(
                "Selamat datang kembali 👋",
                style: TextStyle(color: Colors.grey),
              ),

              SizedBox(height: 5),

              Text(
                "Rafayel Qi",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}