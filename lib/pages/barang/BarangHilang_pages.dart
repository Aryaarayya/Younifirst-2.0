import 'package:flutter/material.dart';

class BarangHilangPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Postingan Kehilangan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // TextField Area
            Container(
              height: 180,
              padding: EdgeInsets.all(16),
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Barang apa yang sedang kamu cari?",
                  hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
            
            // Garis pembatas
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Colors.grey.shade300, thickness: 1),
            ),
            
            SizedBox(height: 8),
            
            // Menu Items
            _buildListItem(Icons.camera_alt, "Foto/Video"),
            _buildListItem(Icons.location_on, "Tambahkan Lokasi Terakhir"),
            _buildListItem(Icons.phone, "Tambahkan Nomor"),
            _buildListItem(Icons.email, "Tambahkan Email"),
          ],
        ),
      ),
    );
  }

  // Komponen Reusable untuk List Item
  Widget _buildListItem(IconData icon, String title) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: Colors.black, size: 24),
      title: Text(
        title, 
        style: TextStyle(fontSize: 14, color: Colors.black87),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.black87, size: 20),
      onTap: () {
        // Aksi ketika diklik
      },
    );
  }
}
