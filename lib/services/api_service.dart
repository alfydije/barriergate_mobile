// ignore_for_file: avoid_print, unnecessary_string_interpolations

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = 'https://bariergate.my.id/api';
  String? _lastErrorMessage;

  Future<String?> loginUser(String email, String password) async {
    var url = Uri.parse('$_baseUrl/login');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var response = await http.post(
        url,
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['token'] != null) {
          prefs.setString('user_data', jsonEncode(data['user']));
          await saveToken(data[
              'token']); // Simpan token ke SharedPreferences setelah login berhasil
          return data['token'];
        } else {
          _lastErrorMessage = 'Token not found in response';
          print('Token not found in response.');
          return null;
        }
      } else {
        var errorResponse = jsonDecode(response.body);
        _lastErrorMessage =
            errorResponse['message'] ?? 'Unknown error occurred';
        print('${response.body}');
        return null;
      }
    } catch (e) {
      _lastErrorMessage = 'Error: $e';
      print('Error: $e');
      return null;
    }
  }

  Future<String?> getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> saveToken(String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString('token', token);
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> logoutUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs
          .remove('token'); // Hapus token dari SharedPreferences saat logout
      return true; // Logout berhasil
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Method to get the last error message
  Future<String?> getLastErrorMessage() async {
    return _lastErrorMessage;
  }
}
