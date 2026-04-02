import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [

              // 🔥 HEADER (LOGO + NOTIF)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 35,
                  ),

                  Stack(
                    children: [
                      Icon(Icons.notifications_none, size: 28),

                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
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

              SizedBox(height: 20),

              // 🔥 CARD PROFILE
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 6)
                  ],
                ),
                child: Column(
                  children: [

                    // AVATAR
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue,
                      child: Text(
                        "RQ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Rafayel Qi",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "e41240238@student.polije.ac.id",
                      style: TextStyle(color: Colors.grey),
                    ),

                    SizedBox(height: 16),

                    // 🔥 INFO GRID
                    Row(
                      children: [
                        infoBox("NIM", "E41240238"),
                        SizedBox(width: 10),
                        infoBox("Program Studi", "Teknik Informatika"),
                      ],
                    ),

                    SizedBox(height: 10),

                    Row(
                      children: [
                        infoBox("Angkatan", "2024"),
                        SizedBox(width: 10),
                        infoBox("Bergabung", "Maret 2026"),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // 🔥 MENU LIST
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [

                      menuItem(Icons.edit, "Edit Profil"),
                      menuItem(Icons.notifications_none, "Pengaturan Notifikasi"),
                      menuItem(Icons.security, "Keamanan Akun"),
                      menuItem(Icons.settings, "Pengaturan"),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 BOX INFO
  Widget infoBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 MENU ITEM
  Widget menuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}