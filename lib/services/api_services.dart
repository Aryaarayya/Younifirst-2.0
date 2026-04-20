import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:younifirst_app/models/Event_model.dart';
import 'package:younifirst_app/models/lost_found_model.dart';
import 'package:younifirst_app/models/comment_model.dart';
import 'package:younifirst_app/services/auth_service.dart';

class ApiService {
  // Base URLs
  static const String eventsBaseUrl = 'https://unelusive-lylah-goodheartedly.ngrok-free.dev/api/events';
  static const String lostFoundBaseUrl = 'https://unelusive-lylah-goodheartedly.ngrok-free.dev/api/lostfound';

  // ==================== EVENT APIs ====================
  
  static Future<List<EventModel>> getEvents() async {
    final url = Uri.parse(eventsBaseUrl);
    try {
      Map<String, String> headers = {
        'ngrok-skip-browser-warning': '69420',
        'Accept': 'application/json',
      };

      if (AuthService.authToken != null) {
        headers['Authorization'] = 'Bearer ${AuthService.authToken}';
      }

      final response = await http.get(url, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
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

  static Future<bool> createEvent(Map<String, String> data, Uint8List? imageBytes) async {
    final url = Uri.parse('$eventsBaseUrl/add');
    try {
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'ngrok-skip-browser-warning': '69420',
        'Accept': 'application/json',
      });
      
      if (AuthService.authToken != null) {
        request.headers['Authorization'] = 'Bearer ${AuthService.authToken}';
      }

      request.fields.addAll(data);

      if (imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'poster',
          imageBytes,
          filename: 'event_poster.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Gagal membuat event: $e');
    }
  }

  static Future<bool> deleteEvent(String id) async {
    final url = Uri.parse('$eventsBaseUrl/$id');
    try {
      Map<String, String> headers = {
        'ngrok-skip-browser-warning': '69420',
        'Accept': 'application/json',
      };
      if (AuthService.authToken != null) {
        headers['Authorization'] = 'Bearer ${AuthService.authToken}';
      }

      final response = await http.delete(url, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Gagal menghapus event: $e');
    }
  }

  // ==================== LOST & FOUND APIs ====================

  static Future<List<LostFoundModel>> getLostAndFound() async {
    final url = Uri.parse(lostFoundBaseUrl);
    try {
      Map<String, String> headers = {
        'ngrok-skip-browser-warning': '69420',
        'Accept': 'application/json',
      };
      if (AuthService.authToken != null) {
        headers['Authorization'] = 'Bearer ${AuthService.authToken}';
      }

      final response = await http.get(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
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

  static Future<bool> deleteLostAndFound(dynamic id) async {
    final url = Uri.parse('$lostFoundBaseUrl/$id');
    try {
      Map<String, String> headers = {
        'ngrok-skip-browser-warning': '69420',
        'Accept': 'application/json',
      };
      if (AuthService.authToken != null) {
        headers['Authorization'] = 'Bearer ${AuthService.authToken}';
      }

      final response = await http.delete(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Gagal menghapus: $e');
    }
  }

  static Future<bool> addLostAndFound({
    required String type,
    required String itemName,
    required String location,
    required String description,
    File? imageFile,
    Uint8List? imageBytes,
  }) async {
    final url = Uri.parse('$lostFoundBaseUrl/add');
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
      
      request.fields['user_id'] = AuthService.loggedInUserId ?? ''; 
      request.fields['status_id'] = '1';

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      } else if (imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'lost_found_image.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final response = await request.send();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final respStr = await response.stream.bytesToString();
        throw Exception('Status ${response.statusCode}: ${respStr}');
      }
    } catch (e) {
      throw Exception('Gagal mengirim data: $e');
    }
  }

  static Future<List<CommentModel>> getComments(int lostFoundId) async {
    final url = Uri.parse('$lostFoundBaseUrl/$lostFoundId/comments');
    try {
      Map<String, String> headers = {
        'ngrok-skip-browser-warning': '69420',
        'Accept': 'application/json',
      };
      if (AuthService.authToken != null) {
        headers['Authorization'] = 'Bearer ${AuthService.authToken}';
      }

      final response = await http.get(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
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

  static Future<bool> addComment(int lostFoundId, String commentMessage) async {
    final url = Uri.parse('$lostFoundBaseUrl/$lostFoundId/comments');
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Gagal mengirim komentar: $e');
    }
  }
}
