// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_mobile/screen/homepage/hompage_screen.dart';
import 'package:ta_mobile/widget/q_button.dart';
import 'package:ta_mobile/widget/text_field.dart';
import 'package:ta_mobile/services/api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      var formData = {
        'email': email,
        'password': password,
      };

      // Print JSON format of the form data
      print(jsonEncode(formData));

      var token = await _apiService.loginUser(email, password);
      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 10),
                const Text('Login berhasil.'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        String errorMessage = "Login gagal. Silakan coba lagi.";
        // Assuming your API service returns the error in a format with 'message'
        var errorResponse = await _apiService.getLastErrorMessage();
        if (errorResponse != null) {
          errorMessage = "Login failed: $errorResponse";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 10),
                Flexible(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Selamat Datang !',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Silahkan masuk untuk melanjutkan',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                QTextField(
                  controller: _emailController,
                  labelText: 'Masukan Alamat Email',
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    // Tambahkan validasi email jika diperlukan
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                QTextField(
                  controller: _passwordController,
                  labelText: 'Password Minimal 8 Karakter',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 8) {
                      return 'Password harus minimal 8 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                QButton(
                  onPressed: _submit,
                  text: 'Masuk',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
