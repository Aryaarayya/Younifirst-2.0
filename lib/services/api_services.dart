import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:younifirst_app/models/Event_model.dart';
import 'package:younifirst_app/models/lost_found_model.dart';
import 'dart:io';import 'package:younifirst_app/services/auth_service.dart';

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

  // --- REST API LOST & FOUND ---

  // 1. Get List Lost and Found
  static Future<List<LostFoundModel>> getLostAndFound() async {
    final url = Uri.parse('https://unelusive-lylah-goodheartedly.ngrok-free.dev/api/lostfound');
    try {
      Map<String, String> headers = {
        'ngrok-skip-browser-warning': '69420',
        'Accept': 'application/json',
      };
      if (AuthService.authToken != null) {
        headers['Authorization'] = 'Bearer ${AuthService.authToken}';
      }

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final dynamic decodedData = jsonDecode(response.body);
        List<dynamic> jsonList = [];
        if (decodedData is Map<String, dynamic> && decodedData.containsKey('data')) {
           jsonList = decodedData['data'];
        } else if (decodedData is List) {
           jsonList = decodedData;
        }
        return jsonList.map((data) => LostFoundModel.fromJson(data)).toList();
      } else {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Gagal menghubungi server: $e');
    }
  }

  // 2. Add Lost and Found (Support Multipart untuk Gambar)
  static Future<bool> addLostAndFound({
    required String type,
    required String itemName,
    required String location,
    required String description,
    File? imageFile,
  }) async {
    final url = Uri.parse('https://unelusive-lylah-goodheartedly.ngrok-free.dev/api/lostfound/add');
    try {
      var request = http.MultipartRequest('POST', url);
      
      request.headers.addAll({
        'Accept': 'application/json',
      });
      if (AuthService.authToken != null) {
        request.headers['Authorization'] = 'Bearer ${AuthService.authToken}';
      }

      request.fields['type'] = type;
      request.fields['item_name'] = itemName;
      request.fields['location'] = location;
      request.fields['description'] = description;
      
      // Gunakan user ID yang disave pada AuthService saat login, berikan fallback kosong jika tidak ada (untuk trigger validasi riil dari DB)
      request.fields['user_id'] = AuthService.loggedInUserId ?? ''; 
      request.fields['status_id'] = '1'; // Asumsi status default 1 (Aktif) kecuali ada di AuthService juga

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      }

      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final respStr = await response.stream.bytesToString();
        throw Exception('Status ${response.statusCode}: ${respStr}');
      }
    } catch (e) {
      throw Exception('Gagal mengirim data: $e');
    }
  }

  // 3. Get Comments for Lost and Found
  static Future<List<CommentModel>> getComments(int lostFoundId) async {
    final url = Uri.parse('https://unelusive-lylah-goodheartedly.ngrok-free.dev/api/lostfound/$lostFoundId/comments');
    try {
      Map<String, String> headers = {
        'ngrok-skip-browser-warning': '69420',
        'Accept': 'application/json',
      };
      if (AuthService.authToken != null) {
        headers['Authorization'] = 'Bearer ${AuthService.authToken}';
      }

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final dynamic decodedData = jsonDecode(response.body);
        List<dynamic> jsonList = [];
        if (decodedData is Map<String, dynamic> && decodedData.containsKey('data')) {
           jsonList = decodedData['data'];
        } else if (decodedData is List) {
           jsonList = decodedData;
        }
        return jsonList.map((data) => CommentModel.fromJson(data)).toList();
      } else {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Gagal mengambil komentar: $e');
    }
  }

  // 4. Add Comment
  static Future<bool> addComment(int lostFoundId, String commentMessage) async {
    final url = Uri.parse('https://unelusive-lylah-goodheartedly.ngrok-free.dev/api/lostfound/$lostFoundId/comments');
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      if (AuthService.authToken != null) {
        headers['Authorization'] = 'Bearer ${AuthService.authToken}';
      }

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'comment': commentMessage,
        })
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Gagal mengirim komentar: $e');
    }
  }
}
