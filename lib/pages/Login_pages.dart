import 'package:flutter/material.dart';
import 'package:younifirst_app/pages/Home_pages.dart';
import 'package:younifirst_app/pages/lupa_katasandi/Lupa_katasandi.dart';
import 'package:younifirst_app/widgets/bottom_navbar.dart';
import 'package:younifirst_app/services/auth_service.dart';

class Login_pages extends StatefulWidget {
  @override
  _Login_pagesState createState() => _Login_pagesState();
}

class _Login_pagesState extends State<Login_pages> {
  // Controllers untuk text field
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // State untuk loading
  bool _isLoading = false;
  
  // State untuk hide/show password
  bool _obscurePassword = true;
  
  // Future untuk proses login api
  Future<bool> _loginProcess() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      return false;
    }

    try {
      // Menggunakan login payload sesuai request (loginWithFirebase)
      await AuthService.loginWithFirebase(
        email: _emailController.text,
        password: _passwordController.text,
      );
      return true; // Jika sukses
    } catch (e) {
      throw e; // Lemparkan error agar ditangkap di _handleLogin
    }
  }
  
  // Fungsi untuk handle login
  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Panggil proses login
      bool success = await _loginProcess();
      
      if (success) {
        // Jika login berhasil, navigasi ke halaman berikutnya
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavbar(),
          ),
        );
      } else {
        // Jika login gagal, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email atau password salah'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
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
                  controller: _emailController,
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
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Masukkan kata sandi Anda",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // LUPA PASSWORD
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => Lupa_katasandi(),
                        ),
                      );
                    },
                    child: Text(
                      "Lupa Kata Sandi?",
                      style: TextStyle(color: Colors.grey),
                      ),
                  ),
                ),
                      

                SizedBox(height: 25),

                // BUTTON dengan animasi loading
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3D5AF1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
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