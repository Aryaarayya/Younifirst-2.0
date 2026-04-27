import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'https://unelusive-lylah-goodheartedly.ngrok-free.dev/api/login';
  
  // Variabel untuk menyimpan token dan user id secara sementara di memori aplikasi
  static String? authToken;
  static String? loggedInUserId;

  // Endpoint login menggunakan Firebase (sesuai req payload)
  static Future<Map<String, dynamic>> loginWithFirebase({
    String name = "User Testing Firebase",
    required String email,
    required String password,
    String role = "user",
    String status = "active",
  }) async {
    final url = Uri.parse(baseUrl);
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "role": role,
          "status": status,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        if (kDebugMode) {
          print('========================================');
          print('🔥 RESPONS LOGIN LENGKAP DARI BACKEND 🔥');
          print(data);
          print('========================================');
        }

        // Simpan token (sesuaikan dengan format response backend Laravel)
        String? tokenToSave;
        if (data['token'] != null) {
          tokenToSave = data['token'];
        } else if (data['access_token'] != null) {
          tokenToSave = data['access_token'];
        } else if (data['data'] != null && data['data']['token'] != null) {
          tokenToSave = data['data']['token'];
        }

        if (tokenToSave != null) {
          authToken = tokenToSave;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', authToken!);
        }

        // Simpan user_id ke SharedPreferences dan memory
        final prefs = await SharedPreferences.getInstance();
        dynamic idToSave;

        // Cek berbagai kemungkinan struktur response
        if (data['data'] != null && data['data']['user'] != null) {
          if (data['data']['user']['user_id'] != null) {
            idToSave = data['data']['user']['user_id'];
          } else if (data['data']['user']['id'] != null) {
            idToSave = data['data']['user']['id'];
          }
        } else if (data['user'] != null) {
          if (data['user']['user_id'] != null) {
            idToSave = data['user']['user_id'];
          } else if (data['user']['id'] != null) {
            idToSave = data['user']['id'];
          }
        } else if (data['user_id'] != null) {
          idToSave = data['user_id'];
        } else if (data['id'] != null) {
          idToSave = data['id'];
        }

        if (idToSave != null) {
          loggedInUserId = idToSave.toString();
          await prefs.setString('user_id', loggedInUserId!);
          if (kDebugMode) {
            print('✅ Berhasil menyimpan user_id: $loggedInUserId');
          }
        } else {
          if (kDebugMode) {
            print('⚠️ WARNING: user_id tidak ditemukan dalam response! Response: $data');
          }
        }

        return data;
      } else {
        throw Exception('Gagal login Firebase: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Koneksi bermasalah: $e');
    }
  }

  // Method untuk logout (menghapus session)
  static Future<void> logout() async {
    authToken = null;
    loggedInUserId = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    
    if (kDebugMode) {
      print('✅ User logged out successfully');
    }
  }

  // Method untuk cek apakah user sudah login
  static Future<bool> isLoggedIn() async {
    // Cek dari memory dulu
    if (authToken != null && loggedInUserId != null) {
      return true;
    }
    
    // Jika tidak ada di memory, coba load dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('auth_token');
    final savedUserId = prefs.getString('user_id');
    
    if (savedToken != null && savedUserId != null) {
      authToken = savedToken;
      loggedInUserId = savedUserId;
      return true;
    }
    
    return false;
  }

  // Method untuk load session saat aplikasi dimulai
  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    loggedInUserId = prefs.getString('user_id');
    
    if (kDebugMode) {
      if (authToken != null && loggedInUserId != null) {
        print('✅ Session loaded: user_id=$loggedInUserId');
      } else {
        print('⚠️ No session found');
      }
    }
  }

  // Method untuk lupa password (kirim OTP)
  static Future<void> forgotPassword(String email) async {
    final url = Uri.parse(baseUrl.replaceFirst('/login', '/password/forgot'));
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Gagal mengirim OTP');
    }
  }

  // Method untuk verifikasi OTP
  static Future<void> verifyOtp(String email, String otp) async {
    final url = Uri.parse(baseUrl.replaceFirst('/login', '/password/verify'));
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'OTP tidak valid');
    }
  }

  // Method untuk reset password
  static Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    final url = Uri.parse(baseUrl.replaceFirst('/login', '/password/reset'));
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Gagal reset password');
    }
  }
}