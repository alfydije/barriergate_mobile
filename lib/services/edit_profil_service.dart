// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;

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

  Future<bool> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString("user_data");
    if (userDataString == null) {
      print("No user data found in shared preferences.");
      return false;
    }

    Map<String, dynamic> userData = jsonDecode(userDataString);
    var user = User.fromJson(
        userData); // Pastikan model User sudah di-import dan didefinisikan dengan benar
    String? token = prefs.getString('token');
    if (token == null) {
      print("No token found in shared preferences.");
      return false;
    }

    final String apiUrl =
        'https://bariergate.my.id/api/user-profile/${user.id}';

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        final data = jsonResponse['data'];

        // Update user data in SharedPreferences
        userData['name'] = data['name'];
        userData['user_profile']['name'] = data['name'];
        userData['user_profile']['nip_nim'] = data['nip_nim'];
        userData['user_profile']['phone_number'] = data['phone_number'];
        userData['user_profile']['address'] = data['address'];
        userData['user_profile']['image'] = data['image'];

        // Encode updated user data to JSON string
        String updatedUserDataJson = jsonEncode(userData);

        // Save updated user data to SharedPreferences
        await prefs.setString('user_data', updatedUserDataJson);

        return true;
      } else {
        throw Exception(
            'Failed to load user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
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
      Map<String, dynamic> formDataMap = {
        'name': name,
        'nip_nim': nipNim,
        'phone_number': phoneNumber,
        'address': address,
        '_method': 'put',
      };

      if (imageFile != null) {
        String fileName = imageFile.path.split('/').last;
        formDataMap['image'] =
            await MultipartFile.fromFile(imageFile.path, filename: fileName);
      }

      FormData formData = FormData.fromMap(formDataMap);

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
