import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:younifirst_app/services/api_services.dart';
import 'package:younifirst_app/services/auth_service.dart';

class TambahEventPage extends StatefulWidget {
  const TambahEventPage({super.key});

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

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateStartController = TextEditingController();
  final TextEditingController _timeStartController = TextEditingController();
  final TextEditingController _dateEndController = TextEditingController();
  final TextEditingController _timeEndController = TextEditingController();

  bool _isLoading = false;
  String? _userId; // Untuk menyimpan ID user (String, misal: USRBSEW4XN)
  int _jenisTiket = 1; // 1 = Gratis, 2 = Berbayar
  String _selectedCategory = 'Seminar';

  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImageBytes;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? idFromPrefs = prefs.getString('user_id');

    // Fallback: ambil dari AuthService jika SharedPreferences kosong
    String? idFromMemory = AuthService.loggedInUserId;

    setState(() {
      _userId = idFromPrefs ?? idFromMemory;
    });

    // Debug
    print('🔍 user_id dari SharedPrefs: $idFromPrefs');
    print('🔍 user_id dari AuthService: $idFromMemory');
    print('✅ _userId yang dipakai: $_userId');
  }

  Future<void> _pickPoster() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _selectedImageBytes = bytes);
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _dateStartController.dispose();
    _timeStartController.dispose();
    _dateEndController.dispose();
    _timeEndController.dispose();
    super.dispose();
  }

  Future<void> _submitEvent() async {
    // Validasi form
    if (_titleController.text.isEmpty) {
      _showSnackBar('Harap isi judul event');
      return;
    }
    
    if (_locationController.text.isEmpty) {
      _showSnackBar('Harap isi lokasi event');
      return;
    }
    
    if (_selectedCategory.isEmpty) {
      _showSnackBar('Harap pilih kategori event');
      return;
    }
    
    if (_dateStartController.text.isEmpty) {
      _showSnackBar('Harap pilih tanggal mulai');
      return;
    }
    
    if (_timeStartController.text.isEmpty) {
      _showSnackBar('Harap pilih waktu mulai');
      return;
    }
    
    if (_dateEndController.text.isEmpty) {
      _showSnackBar('Harap pilih tanggal selesai');
      return;
    }
    
    if (_timeEndController.text.isEmpty) {
      _showSnackBar('Harap pilih waktu selesai');
      return; 
    }

    if (_userId == null) {
      _showSnackBar('User ID Anda kosong. Mohon logout, lalu login kembali agar ID tersimpan.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Format datetime
      final startDateTime = "${_dateStartController.text} ${_timeStartController.text}:00";
      final endDateTime = "${_dateEndController.text} ${_timeEndController.text}:00";

      // Mapping kategori ke ID
      final Map<String, String> categoryMapping = {
        'Kompetisi': '1',
        'Seminar': '2',
        'Pameran': '3',
        'Turnamen': '4',
        'Konser': '5',
      };

      // ✅ Data lengkap dengan created_by
      final Map<String, String> data = {
        'title': _titleController.text,
        'location': _locationController.text,
        'description': _descriptionController.text,
        'category_id': categoryMapping[_selectedCategory] ?? '1',
        'start_date': startDateTime,
        'end_date': endDateTime,
        'created_by': _userId.toString(), // ✅ Mengirim ID secara benar
      };

      // Panggil API
      final success = await ApiService.createEvent(data, _selectedImageBytes);
      
      if (success) {
        _showSnackBar('Event berhasil diposting!', isError: false);
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context, true);
      }
      
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '').replaceAll('Gagal membuat event: ', '');
      _showSnackBar(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
              // 🔥 UPLOAD POSTER
              GestureDetector(
                onTap: _pickPoster,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFF0F4FA),
                        borderRadius: BorderRadius.circular(16),
                        image: _selectedImageBytes != null 
                          ? DecorationImage(image: MemoryImage(_selectedImageBytes!), fit: BoxFit.cover)
                          : null,
                      ),
                      child: _selectedImageBytes == null ? Column(
                        children: [
                          Icon(Icons.image_search_outlined, size: 50, color: Colors.black87),
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
                      ) : Container(height: 120),
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
                          onPressed: _pickPoster,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 20),

              textField("Nama Event", controller: _titleController),
              SizedBox(height: 16),
              textField("Lokasi Event", controller: _locationController, icon: Icons.location_on),
              SizedBox(height: 20),

              // SECTION TANGGAL DAN WAKTU
              Text("Tanggal dan Waktu Pelaksanaan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              SizedBox(height: 16),

              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    datePickerField("Tanggal Event", _dateStartController),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: timePickerField("Waktu Mulai", _timeStartController)),
                        SizedBox(width: 10),
                        Expanded(child: timePickerField("Waktu Selesai", _timeEndController)),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),
              Text("Batas Akhir (End Date)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              SizedBox(height: 8),
              datePickerField("Tanggal Berakhir", _dateEndController),

              SizedBox(height: 16),

              // GRATIS / BERBAYAR
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

              SizedBox(height: 24),

              // TAG TERKAIT
              Text("Tag Terkait", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                          if (isSelected) _selectedTags.remove(tag);
                          else _selectedTags.add(tag);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue.shade100 : Color(0xFFC3CAF5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? Colors.blue.shade600 : Colors.blue.shade300),
                        ),
                        child: Text(tag, style: TextStyle(color: Colors.black87, fontSize: 12)),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 24),

              // KETERANGAN EVENT
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Keterangan Event",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

              SizedBox(height: 30),

              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitEvent,
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3D5AFE)),
                    child: _isLoading 
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("BUAT EVENT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget textField(String hint, {TextEditingController? controller, IconData? icon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget datePickerField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(controller),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget timePickerField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectTime(controller),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(Icons.access_time),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}