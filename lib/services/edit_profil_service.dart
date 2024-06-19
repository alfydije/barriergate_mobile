// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserService {
  final Dio _dio = Dio();

  Future<User> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString("user_data");
    if (userDataString == null) {
      throw Exception('User data not found in SharedPreferences');
    }
    Map<String, dynamic> userData = jsonDecode(userDataString);
    var user = User.fromJson(userData);
    return user;
  }

  Future<bool> updateUserProfile({
    required XFile? imageFile,
    required String name,
    required String username,
    required String nipNim,
    required String email,
    required String phoneNumber,
    required String address,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString("user_data");
    if (userDataString == null) {
      print("No user data found in shared preferences.");
      return false;
    }

    Map<String, dynamic> userData = jsonDecode(userDataString);
    var user = User.fromJson(userData);
    String? token = prefs.getString('token');
    if (token == null) {
      print("No token found in shared preferences.");
      return false;
    }

    log(user.id.toString());

    final String apiUrl =
        'https://bariergate.my.id/api/edit-profile/${user.id}';

    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'nip_nim': nipNim,
        'phone_number': phoneNumber,
        'address': address,
        '_method': 'put',
        if (imageFile != null)
          'image': await MultipartFile.fromFile(imageFile.path,
              filename: imageFile.name),
      });

      log(formData.fields.toString());

      final response = await _dio.post(
        apiUrl,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) {
            return status! < 500; // Accepts all status codes below 500
          },
        ),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      if (response.statusCode == 200) {
        var responseData = response.data;
        return responseData['status'] == 'success';
      } else {
        print('Failed to update profile: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }
}
