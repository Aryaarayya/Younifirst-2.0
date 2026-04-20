import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:younifirst_app/services/api_services.dart';

class BarangHilangPage extends StatefulWidget {
  const BarangHilangPage({super.key});

  @override
  _BarangHilangPageState createState() => _BarangHilangPageState();
}

class _BarangHilangPageState extends State<BarangHilangPage> {
  String _selectedKategori = 'Hilang'; // default
  File? _imageFile;
  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitData() async {
    if (_namaBarangController.text.isEmpty || _lokasiController.text.isEmpty || _deskripsiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap lengkapi semua data wajib')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool result = await ApiService.addLostAndFound(
        type: _selectedKategori,
        itemName: _namaBarangController.text,
        location: _lokasiController.text,
        description: _deskripsiController.text,
        imageFile: _imageFile,
      );

      if (result) {
        Navigator.pop(context, true); // return true to refresh list
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memposting: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Posting Lost and Found",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kategori
              const Text("Kategori Lost and Found", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(
                "(pilih salah satu kategori lost and found, apakah barang hilang atau ditemukan)",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildCategoryButton('Hilang'),
                  const SizedBox(width: 12),
                  _buildCategoryButton('Ditemukan'),
                ],
              ),
              const SizedBox(height: 24),

              // Gambar barang
              Row(
                children: [
                  const Text("Gambar barang", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(width: 4),
                  Text("(opsional)", style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: CustomPaint(
                  painter: DashedRectPainter(color: Colors.blue.shade300, strokeWidth: 1, gap: 5.0),
                  child: Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF), // light blue bg
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_imageFile!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.image_outlined, size: 36, color: Color(0xFF3D5AFE)),
                              const SizedBox(height: 8),
                              const Text("Tambahkan Gambar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text("Format jpg/jpeg/png, Maks 2 GB", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Nama Barang
              const Text("Nama Barang", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _namaBarangController,
                hint: "Masukkan nama barang...",
              ),
              const SizedBox(height: 24),

              // Lokasi Terakhir
              Row(
                children: const [
                  Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF3D5AFE)),
                  SizedBox(width: 4),
                  Text("Lokasi Terakhir", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _lokasiController,
                hint: "Masukkan lokasi barang hilang...",
              ),
              const SizedBox(height: 24),

              // Deskripsi
              const Text("Deksripsi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Stack(
                children: [
                  _buildTextField(
                    controller: _deskripsiController,
                    hint: "Ciri-ciri barang, kondisi, dll...",
                    maxLines: 6,
                    maxLength: 500,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // POSTING BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D5AFE),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading 
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          "POSTING",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    bool isSelected = _selectedKategori == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedKategori = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3D5AFE) : Colors.grey.shade200,
           borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black87, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3D5AFE), width: 1.5),
        ),
        counterText: maxLength != null ? null : '', // default show counter if maxLength is set
      ),
      onChanged: (val) {
        if (maxLength != null) {
          setState(() {}); // to update counter inside the textfield if needed
        }
      },
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    var path = Path();
    // draw a round rect with dashed line manually
    RRect rrect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(8));
    
    Path extractPath = Path()..addRRect(rrect);
    PathMetrics pathMetrics = extractPath.computeMetrics();
    Path dashedPath = Path();

    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;
      while (distance < pathMetric.length) {
        double len = gap;
        if (distance + len > pathMetric.length) {
          len = pathMetric.length - distance;
        }
        if (draw) {
          dashedPath.addPath(pathMetric.extractPath(distance, distance + len), Offset.zero);
        }
        distance += len;
        draw = !draw;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
