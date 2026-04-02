import 'package:flutter/material.dart';

class TeamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [

              // 🔥 HEADER
              teamsHeader(),

              SizedBox(height: 16),

              // 🔥 LIST TEAM
              Expanded(
                child: ListView(
                  children: [

                    teamCard(
                      title: "Cocomelon",
                      subtitle: "Lomba apa saja",
                      desc: "Pengembangan perangkat lunak",
                      status: "Open",
                      isOpen: true,
                      members: ["1", "2"],
                      total: "2/4 Anggota",
                      tags: ["UI/UX", "Backend"],
                    ),

                    SizedBox(height: 16),

                    teamCard(
                      title: "Arirang",
                      subtitle: "Lomba apa saja",
                      desc: "Desain UI/UX",
                      status: "Full",
                      isOpen: false,
                      members: ["1", "2", "3", "4"],
                      total: "6/6 Anggota",
                      tags: ["Frontend", "Backend"],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 HEADER UI
  Widget teamsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        // LOGO
        Image.asset(
          'assets/images/logo.png',
          width: 35,
        ),

        // ACTION BUTTON
        Row(
          children: [

            iconCircle(Icons.search),
            SizedBox(width: 8),

            iconCircle(Icons.add),
            SizedBox(width: 8),

            iconCircle(Icons.tune),
            SizedBox(width: 8),

            // NOTIF + BADGE
            Stack(
              children: [
                iconCircle(Icons.notifications_none),

                Positioned(
                  right: 6,
                  top: 6,
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
            ),
          ],
        )
      ],
    );
  }

  // 🔥 ICON BULAT
  Widget iconCircle(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Color(0xFFE0E7FF),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 20,
        color: Colors.blue,
      ),
    );
  }

  // 🔥 CARD TEAM
  Widget teamCard({
    required String title,
    required String subtitle,
    required String desc,
    required String status,
    required bool isOpen,
    required List<String> members,
    required String total,
    required List<String> tags,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // HEADER CARD
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isOpen ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isOpen ? Colors.green : Colors.red,
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: 5),

          Text(subtitle, style: TextStyle(color: Colors.grey)),

          SizedBox(height: 5),

          Text(desc),

          SizedBox(height: 10),

          // TAG
          Wrap(
            spacing: 8,
            children: tags.map((tag) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: TextStyle(color: Colors.blue),
                ),
              );
            }).toList(),
          ),

          Divider(height: 20),

          // MEMBER + TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              // AVATAR
              Row(
                children: members.map((e) {
                  return Container(
                    margin: EdgeInsets.only(right: 6),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),

              Text(
                total,
                style: TextStyle(color: Colors.blue),
              )
            ],
          )
        ],
      ),
    );
  }
}