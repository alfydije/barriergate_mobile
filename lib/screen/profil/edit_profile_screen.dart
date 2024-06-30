// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ta_mobile/models/user_model.dart';
import '../../services/edit_profil_service.dart';
import '../../widget/button.dart';
import '../../widget/q_appbar.dart';

class EditProfil extends StatefulWidget {
  final User user;

  const EditProfil({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _nipnimController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late String? _image;

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  final UserService _userService = UserService(); // Initialize the service

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.user.userProfile!.name);
    _usernameController = TextEditingController(text: widget.user.username);
    _nipnimController =
        TextEditingController(text: widget.user.userProfile!.nipNim!);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneNumberController =
        TextEditingController(text: widget.user.userProfile!.phoneNumber);
    _addressController =
        TextEditingController(text: widget.user.userProfile!.address);
    _image = widget.user.userProfile!.image!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _nipnimController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? selectedImage = await _picker.pickImage(source: source);
      if (selectedImage != null) {
        setState(() {
          _imageFile = selectedImage;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _updateUserProfile() async {
    setState(() {
      widget.user.userProfile!.name = _nameController.text;
      widget.user.username = _usernameController.text;
      widget.user.userProfile!.nipNim = _nipnimController.text;
      widget.user.email = _emailController.text;
      widget.user.userProfile!.phoneNumber = _phoneNumberController.text;
      widget.user.userProfile!.address = _addressController.text;
    });

    bool success = await _userService.updateUserProfile(
      imageFile: _imageFile,
      name: _nameController.text,
      username: _usernameController.text,
      nipNim: _nipnimController.text,
      email: _emailController.text,
      phoneNumber: _phoneNumberController.text,
      address: _addressController.text,
    );

    if (success) {
      await _userService.getUser();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User profile updated successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const QAppBar(title: 'Edit Profil'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            if (_imageFile != null) ...[
              Image.file(
                File(_imageFile!.path),
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
            ] else if (_image != null) ...[
              Image.network(
                'https://bariergate.my.id/storage/$_image',
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
            ] else
              Text('No image selected'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera),
                  label: Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.photo),
                  label: Text('Gallery'),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildTextField('Name', _nameController),
            SizedBox(height: 12),
            _buildTextField('Username', _usernameController),
            SizedBox(height: 12),
            _buildTextField('Nip/Nim', _nipnimController),
            SizedBox(height: 12),
            _buildTextField('Email', _emailController),
            SizedBox(height: 12),
            _buildTextField('Phone Number', _phoneNumberController),
            SizedBox(height: 12),
            _buildTextField('Address', _addressController),
            SizedBox(height: 20),
            Button(
              onPressed: _updateUserProfile,
              text: 'Simpan Perubahan',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
