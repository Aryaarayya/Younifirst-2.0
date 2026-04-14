import 'package:flutter/material.dart';

class TambahEventPage extends StatefulWidget {
  @override
  _TambahEventPageState createState() => _TambahEventPageState();
}

class _TambahEventPageState extends State<TambahEventPage> {
  // State untuk Tag Terkait
  List<String> _selectedTags = [];
  final List<String> _availableTags = [
    'Seminar', 'Webinar', 'Konser', 'Pameran',
    'Turnamen', 'Festival', 'Online', 'Offline',
    'Umum', 'Hanya Mahasiswa'
  ];

  int _jenisTiket = 1; // 1 = Gratis, 2 = Berbayar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),

      // 🔥 APPBAR (BACK + TITLE)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // No shadow in image
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Buat Event",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔥 UPLOAD POSTER (dengan tombol refresh biru)
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F4FA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.image_search_outlined, size: 50, color: Colors.black87), // Assuming close icon
                        SizedBox(height: 10),
                        Text(
                          "Tambahkan Poster Event",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Format jpg/jpeg/png, Maks 15MB",
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.refresh, color: Colors.white, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(height: 20),

              // 🔥 NAMA EVENT
              textField("Nama Event", suffix: "0/30"),

              SizedBox(height: 16),

              // 🔥 LOKASI
              textField("Lokasi Event", icon: Icons.location_on),

              SizedBox(height: 20),

              // 🔥 SECTION TANGGAL DAN WAKTU PELAKSANAAN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal dan Waktu Pelaksanaan",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Atur tanggal dan waktu event. Tambahkan hari jika berlangsung lebih dari satu.",
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC3D4FB), // Light blue Background
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.blue.shade300),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.black87, size: 16),
                          SizedBox(width: 4),
                          Text("Tambah Hari", style: TextStyle(color: Colors.black87, fontSize: 12)),
                        ],
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(height: 16),

              // 🔥 CARD HARI
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // HEADER HARI
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Hari 1", style: TextStyle(fontSize: 14)),
                        Icon(Icons.close, size: 18),
                      ],
                    ),

                    SizedBox(height: 16),

                    textField("Tanggal Event Hari ke-1", icon: Icons.calendar_today_outlined),

                    SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: textField("Waktu Mulai", icon: Icons.access_time)),
                        SizedBox(width: 10),
                        Expanded(child: textField("Waktu Selesai", icon: Icons.access_time)),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // 🔥 RADIO GRATIS / BERBAYAR
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Radio(
                            value: 1, 
                            groupValue: _jenisTiket, 
                            onChanged: (int? v) { setState(() => _jenisTiket = 1); },
                            activeColor: Colors.black,
                          ),
                          Text("Gratis", style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio(
                            value: 2, 
                            groupValue: _jenisTiket, 
                            onChanged: (int? v) { setState(() => _jenisTiket = 2); },
                            activeColor: Colors.black,
                          ),
                          Text("Berbayar", style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // 🔥 LINK PENDAFTARAN
              textField("Link Pendaftaran", icon: Icons.link),

              SizedBox(height: 24),

              // 🔥 BATAS TANGGAL DAN WAKTU PENDAFTARAN
              Text("Batas Tanggal dan Waktu Pendaftaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              SizedBox(height: 4),
              Text(
                "Tentukan kapan pendaftaran dibuka dan ditutup.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(child: textField("Tanggal Mulai", icon: Icons.calendar_today_outlined)),
                  SizedBox(width: 10),
                  Expanded(child: textField("Waktu Mulai", icon: Icons.access_time)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: textField("Tanggal Tutup", icon: Icons.calendar_today_outlined)),
                  SizedBox(width: 10),
                  Expanded(child: textField("Waktu Tutup", icon: Icons.access_time)),
                ],
              ),

              SizedBox(height: 24),

              // 🔥 TAG TERKAIT
              Text("Tag Terkait", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              SizedBox(height: 4),
              Text(
                "Pilih atau ketuk tag yang sesuai dengan jenis event",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),

              Container(
                padding: EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _availableTags.map((tag) {
                    bool isSelected = _selectedTags.contains(tag);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedTags.remove(tag);
                          } else {
                            _selectedTags.add(tag);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue.shade100 : Color(0xFFC3CAF5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? Colors.blue.shade600 : Colors.blue.shade300),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 24),

              // 🔥 KETERANGAN EVENT
              TextField(
                maxLines: 7,
                decoration: InputDecoration(
                  hintText: "Keterangan Event",
                  hintStyle: TextStyle(color: Colors.black87, fontSize: 13, height: 1.5),
                  suffixText: "0/1500  \n\n\n\n\n\n ", // hack for top right
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // 🔥 MEDIA SOSIAL
              Text("Media Sosial", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              SizedBox(height: 4),
              Text(
                "Tambahkan media sosial agar peserta mudah terhubung dengan Anda. (Opsional)",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              SizedBox(height: 16),
              
              Row(
                children: [
                  socialButton(Icons.camera_alt_outlined), // Placeholder for Instagram icon
                  SizedBox(width: 16),
                  socialButton(Icons.chat_bubble_outline), // Placeholder for WhatsApp/Chat icon
                ],
              ),

              SizedBox(height: 40),

              // 🔥 BUAT EVENT (Text in Center based on image)
              Center(
                child: Text(
                  "Buat Event",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 SOCIAL MEDIA ROUND BUTTON
  Widget socialButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Color(0xFFF0F4FA),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.black87),
    );
  }

  // 🔥 TEXTFIELD REUSABLE
  Widget textField(String hint, {IconData? icon, String? suffix}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black87, fontSize: 13),
        prefixIcon: icon != null ? Icon(icon, size: 20, color: Colors.black87) : null,
        suffixText: suffix,
        suffixStyle: TextStyle(fontSize: 12),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
}