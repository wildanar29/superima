// lib/core/network/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {


  ApiService();

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> get(String path) async {
    final response = await http.get(
      Uri.parse('$path'),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }
}
