import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:younifirst_app/models/Teams_model.dart';
import 'package:younifirst_app/services/auth_service.dart';

class TeamApiService {
  static const String baseTeamsUrl = 'https://unelusive-lylah-goodheartedly.ngrok-free.dev/api/teams';

  static Future<List<TeamModel>> getTeams() async {
    final url = Uri.parse(baseTeamsUrl);
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

        return jsonList.map((data) => TeamModel.fromJson(data)).toList();
      } else {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Gagal memuat tim: $e');
    }
  }

  static Future<bool> createTeam(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseTeamsUrl/add');
    try {
      Map<String, String> headers = {
        'ngrok-skip-browser-warning': '69420',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      if (AuthService.authToken != null) {
        headers['Authorization'] = 'Bearer ${AuthService.authToken}';
      }

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        throw Exception('Gagal membuat tim! Status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Gagal membuat tim: $e');
    }
  }
}
