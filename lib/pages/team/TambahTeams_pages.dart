import 'package:flutter/material.dart';

class TambahTeamsPage extends StatefulWidget {
  @override
  _TambahTeamsPageState createState() => _TambahTeamsPageState();
}

class _TambahTeamsPageState extends State<TambahTeamsPage> {

  int memberSaatIni = 1;
  int memberMax = 2;
  int jumlahOrang = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Buat Tim", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 NAMA TIM
            textField("Nama Tim", suffix: "0/20"),

            SizedBox(height: 20),

            // 🔥 JUMLAH MEMBER
            Text("Jumlah Dibutuhkan", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(
              "Tentukan jumlah anggota yang kamu butuhkan.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: counterBox("Member saat ini", memberSaatIni, (v) {
                  setState(() => memberSaatIni = v);
                })),
                SizedBox(width: 10),
                Expanded(child: counterBox("Member maksimal", memberMax, (v) {
                  setState(() => memberMax = v);
                })),
              ],
            ),

            SizedBox(height: 20),

            // 🔥 TANGGAL PENDAFTARAN
            Text("Batas Tanggal Pendaftaran", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(
              "Tentukan kapan pendaftaran kandidat ditutup.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            SizedBox(height: 10),

            textField("Tanggal Tutup", icon: Icons.calendar_today),

            SizedBox(height: 20),

            // 🔥 POSISI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Posisi yang dibutuhkan", style: TextStyle(fontWeight: FontWeight.bold)),
                OutlinedButton(
                  onPressed: () {},
                  child: Text("+ Tambah Posisi"),
                )
              ],
            ),

            SizedBox(height: 4),

            Text(
              "Tulis posisi/tugas yang kamu butuhkan serta ketentuan dasar untuk posisi tsb.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            SizedBox(height: 12),

            posisiCard(),

            SizedBox(height: 16),

            // 🔥 LINK PENDAFTARAN
            textField("Link Pendaftaran", icon: Icons.link),

            SizedBox(height: 24),

            // 🔥 INFORMASI LOMBA
            Text("Informasi Lomba", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(
              "Tulis informasi lomba yang kamu dan tim-mu akan ikuti.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            
            SizedBox(height: 12),
            textField("Nama Lomba"),
            
            SizedBox(height: 12),
            textField("Nama Penyelenggara"),

            SizedBox(height: 12),
            textField("Link Postingan Lomba", icon: Icons.link),

            SizedBox(height: 12),
            textField("Tulis Hadiah Untuk Menarik Minat Anggota", icon: Icons.workspace_premium_outlined),

            SizedBox(height: 30),

            // 🔥 BUAT TIM BUTTON
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC6D2F6), // light blue button color
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Buat Tim",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🔥 TEXTFIELD
  Widget textField(String hint, {IconData? icon, String? suffix}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black87),
        prefixIcon: icon != null ? Icon(icon, size: 20, color: Colors.black87) : null,
        suffixText: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue)
        ),
      ),
    );
  }

  // 🔥 COUNTER BOX
  Widget counterBox(String title, int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12)),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  if (value > 0) onChanged(value - 1);
                },
              ),

              Text(value.toString()),

              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  onChanged(value + 1);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🔥 CARD POSISI
  Widget posisiCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Posisi 1", style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.close, size: 20),
            ],
          ),

          SizedBox(height: 10),

          textField("Nama Posisi/Tugas", icon: Icons.work_outline),

          SizedBox(height: 10),

          // JUMLAH ORANG
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Jumlah Orang :", style: TextStyle(fontSize: 13)),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: 20),
                    onPressed: () {
                      if (jumlahOrang > 1) {
                        setState(() => jumlahOrang--);
                      }
                    },
                  ),
                  Text(jumlahOrang.toString(), style: TextStyle(fontSize: 14)),
                  IconButton(
                    icon: Icon(Icons.add, size: 20),
                    onPressed: () {
                      setState(() => jumlahOrang++);
                    },
                  ),
                ],
              )
            ],
          ),

          SizedBox(height: 10),

          Text("Ketentuan :", style: TextStyle(fontSize: 13)),

          SizedBox(height: 8),

          ketentuanItem("Ketentuan 1"),
          SizedBox(height: 6),
          ketentuanItem("Ketentuan 2"),

          SizedBox(height: 12),

          // Tombol Tambah Ketentuan
          Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
              color: Color(0xFFC6D2F6), // warna biru muda
              border: Border.all(color: Colors.blue.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.blue.shade600, size: 18),
                    SizedBox(width: 4),
                    Text(
                      "Tambah Ketentuan", 
                      style: TextStyle(color: Colors.blue.shade600, fontWeight: FontWeight.w500)
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 12),

          Text("Bonus/Nilai Plus (opsional)", style: TextStyle(fontSize: 12)),
          SizedBox(height: 8),

          textField("Contoh : punya pengalaman kompetisi", icon: Icons.auto_awesome),

        ],
      ),
    );
  }

  // 🔥 ITEM KETENTUAN
  Widget ketentuanItem(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.blue.shade600, size: 20),
              SizedBox(width: 8),
              Text(text, style: TextStyle(color: Colors.black87)),
            ],
          ),
          Icon(Icons.close, size: 18, color: Colors.black87),
        ],
      ),
    );
  }
}