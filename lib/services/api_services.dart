import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:younifirst_app/models/Event_model.dart';

import 'package:younifirst_app/services/auth_service.dart';

class ApiService {
  // Samakan dengan ngrok url agar bisa testing dari device/emulator
  static const String baseUrl = 'https://unelusive-lylah-goodheartedly.ngrok-free.dev/api/events';

  static Future<List<EventModel>> getEvents() async {
    final url = Uri.parse('$baseUrl');
    try {
      // Menyiapkan headers dasar
      Map<String, String> headers = {
        'ngrok-skip-browser-warning': '69420',
        'Accept': 'application/json',
      };

      // Menyisipkan token akses jika pengguna sudah berhasil login
      if (AuthService.authToken != null) {
        headers['Authorization'] = 'Bearer ${AuthService.authToken}';
      }

      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic decodedData = jsonDecode(response.body);
        List<dynamic> jsonList = [];

        if (decodedData is Map<String, dynamic> && decodedData.containsKey('data')) {
           jsonList = decodedData['data'];
        } else if (decodedData is List) {
           jsonList = decodedData;
        }

        return jsonList.map((data) => EventModel.fromJson(data)).toList();
      } else {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Gagal menghubungi server: $e');
    }
  }
}
