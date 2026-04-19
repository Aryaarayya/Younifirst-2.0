import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // import kIsWeb

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
    final url = Uri.parse('$baseUrl');
    
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
        // Simpan token (sesuaikan dengan format response backend Laravel Anda)
        // Biasanya Laravel mengembalikan token di data['token'] atau data['access_token']
        if (data['token'] != null) {
          authToken = data['token'];
        } else if (data['access_token'] != null) {
          authToken = data['access_token'];
        } else if (data['data'] != null && data['data']['token'] != null) {
          authToken = data['data']['token'];
        }

        // Coba tangkap user_id jika dikembalikan oleh backend
        if (data['user'] != null && data['user']['id'] != null) {
          loggedInUserId = data['user']['id'].toString();
        } else if (data['data'] != null && data['data']['user'] != null && data['data']['user']['id'] != null) {
          loggedInUserId = data['data']['user']['id'].toString();
        } else if (data['id'] != null) {
          loggedInUserId = data['id'].toString();
        }

        return data;
      } else {
        throw Exception('Gagal login Firebase: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Koneksi bermasalah: $e');
    }
  }
}
