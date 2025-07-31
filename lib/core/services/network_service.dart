import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';

class NetworkService {
  static const String _baseUrl = "https://reqres.in/api";
  static const Map<String, String> _headers = {
    "Content-Type": "application/json",
    "x-api-key": "reqres-free-v1",
  };

  //Fetch all items from the endpoint
  Future<List<dynamic>> getData(String endpoint) async {
    final Uri url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data'] ?? [];
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  /// POST: Add or submit data to the endpoint
  Future<dynamic> addData(String endpoint, Map<String, dynamic> data) async {
    final Uri url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: _headers,
      body: json.encode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add data: ${response.statusCode}');
    }
  }

  Future<void> updateData({required UserModel data}) async {
    final response = await http.put(
      Uri.parse("https://reqres.in/api/users/${data.id}"),
      headers: {
        "x-api-key": "reqres-free-v1",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to update user");
    }
  }

  /// DELETE by ID
  Future<void> deleteData(
      {required String endpoint, required String id}) async {
    final Uri url = Uri.parse('$_baseUrl/$endpoint/$id');
    final response = await http.delete(url, headers: _headers);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> postData({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    final Uri url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(body),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return responseBody;
    } else {
      // return error body along with status code
      return {
        "error": true,
        "statusCode": response.statusCode,
        "message": responseBody["error"] ?? "Unknown error",
      };
    }
  }
}
// x-api-key: reqres-free-v1
// reqres-free-v1
// https://reqres.in/api/users
