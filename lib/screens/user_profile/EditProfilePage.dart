import 'package:flutter/material.dart';
import 'package:frontend/screens/user_profile/EditProfilePage.dart';
import 'package:frontend/screens/user_profile/UserModel.dart' as model;

import 'package:flutter/material.dart';

import 'UserModel.dart';

// User model - Move this to a separate models folder in a real app
class User {
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String location;
  final String language;

  User({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.location,
    required this.language,
  });
}

class EditProfilePage extends StatefulWidget {
  final model.User? user;
  final model.UserModel? userModel; // Use model. namespace here too

  EditProfilePage({this.user, this.userModel});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _locationController;
  late TextEditingController _languageController;

  bool _isPrivateAccount = false;
  bool _isActivityStatusEnabled = true;

  @override
  void initState() {
    super.initState();
    // Initialize with user data if available
    _fullNameController =
        TextEditingController(text: widget.user?.fullName ?? '');
    _usernameController =
        TextEditingController(text: widget.user?.username ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _phoneController = TextEditingController(text: widget.user?.phone ?? '');
    _dateOfBirthController =
        TextEditingController(text: widget.user?.dateOfBirth ?? '');
    _locationController =
        TextEditingController(text: widget.user?.location ?? '');
    _languageController =
        TextEditingController(text: widget.user?.language ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    _locationController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isReadOnly = false, required String hintText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextField(
        controller: controller,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(width: 1.5),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Delete Account'),
                  content:
                      Text('Are you sure you want to delete your account?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Handle account deletion
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(Icons.delete, color: Colors.red),
          label: Text(
            'Delete Account',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 16.0),
            backgroundColor: Colors.red.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF2D46B9),
        actions: [
          TextButton(
            onPressed: () {
              // Save and return updated user data
              final updatedUser = User(
                fullName: _fullNameController.text,
                username: _usernameController.text,
                email: _emailController.text,
                phone: _phoneController.text,
                dateOfBirth: _dateOfBirthController.text,
                location: _locationController.text,
                language: _languageController.text,
                gender: '', // Add gender handling if needed
              );
              Navigator.pop(context, updatedUser);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/profile_picture.png'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Add photo change functionality
              },
              child: const Text(
                'Change Photo',
                style: TextStyle(color: Color(0xFF2D46B9)),
              ),
            ),
            _buildTextField('Name', _fullNameController,
                hintText: 'Enter your name'),
            _buildTextField('Username', _usernameController,
                hintText: 'Enter your username'),
            _buildSectionTitle('Contact Information'),
            _buildTextField('Email', _emailController,
                hintText: 'Enter your email'),
            _buildTextField('Phone Number', _phoneController,
                hintText: 'Enter your phone number'),
            _buildTextField('Date Of Birth', _dateOfBirthController,
                hintText: 'Enter your date of birth'),
            _buildSectionTitle('Privacy Settings'),
            SwitchListTile(
              title: const Text('Private Account'),
              subtitle: const Text('Only followers can see your posts'),
              value: _isPrivateAccount,
              onChanged: (value) {
                setState(() {
                  _isPrivateAccount = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Activity Status'),
              subtitle: const Text('Show when you\'re active'),
              value: _isActivityStatusEnabled,
              onChanged: (value) {
                setState(() {
                  _isActivityStatusEnabled = value;
                });
              },
            ),
            const SizedBox(height: 24),
            _buildDeleteAccountButton(),
          ],
        ),
      ),
    );
  }
}
