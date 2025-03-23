import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../sign_in.dart';
import 'UserModel.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _isPrivateAccount = false;
  bool _isActivityStatusEnabled = false;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dateOfBirthController;
  File? _profileImage;


  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phoneNumber ?? '');
    _dateOfBirthController = TextEditingController(text: widget.user.dob ?? '');
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }


  Future<void> _updateProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        throw Exception('No access token found');
      }

      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('https://wondersri-backend-tracking.onrender.com/auth/users/update-profile'),
      );

      request.headers['Authorization'] = 'Bearer $accessToken';

      request.fields['first_name'] = _firstNameController.text;
      request.fields['last_name'] = _lastNameController.text;
      request.fields['username'] = _usernameController.text;
      request.fields['email'] = _emailController.text;
      if (_phoneController.text.isNotEmpty) {
        request.fields['phone_number'] = _phoneController.text;
      }
      if (_dateOfBirthController.text.isNotEmpty) {
        request.fields['dob'] = _dateOfBirthController.text;
      }

      if (_profileImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_picture',
            _profileImage!.path,
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final Map<String, dynamic> data = json.decode(responseData);

        // Update the user's profile data
        final updatedUser = User(
          id: widget.user.id,
          firstName: data['profile']['first_name'],
          lastName: data['profile']['last_name'],
          username: data['profile']['username'],
          email: data['profile']['email'],
          phoneNumber: data['profile']['phone_number'],
          dob: data['profile']['dob'],
          profilePicture: data['profile']['profile_picture'],
          user: data['profile']['user'],
        );

        // Return the updated user data
        Navigator.pop(context, updatedUser);
      } else {
        final responseData = await response.stream.bytesToString();
        print('Error Response: $responseData');
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }

  }


  Future<void> _deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final Uri url = Uri.parse('https://wondersri-backend-tracking.onrender.com/auth/delete-account');
    final Map<String, String> headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
    };

    try {
      final response = await http.delete(url, headers: headers);
      if (!mounted) return;

      if (response.statusCode == 204) {
      // Account deleted successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted successfully')),
      );
      // Optionally, navigate to the login screen or home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      } else if (response.statusCode == 401) {
      // Unauthorized
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unauthorized. Please log in again.')),
        );
      } else {
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account. Please try again.')),
          );
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    }
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
                        Navigator.of(context).pop(); // Close the dialog
                        _deleteAccount();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default date (today)
      firstDate: DateTime(1900), // Earliest selectable date
      lastDate: DateTime.now(), // Latest selectable date (today)
    );

    if (picked != null) {
      // Format the selected date as a string (e.g., "yyyy-MM-dd")
      final formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

      // Update the date of birth controller
      setState(() {
        _dateOfBirthController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF2D46B9),
        actions: [
          TextButton(
            onPressed: _updateProfile, // Call _updateProfile on save
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
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300], // Background color for the placeholder
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!) as ImageProvider
                  : widget.user.profilePicture != null
                  ? NetworkImage(widget.user.profilePicture!)
                  : null, // No default image
              child: _profileImage == null && widget.user.profilePicture == null
                  ? Icon(
                Icons.person, // Placeholder icon
                size: 40,
                color: Colors.grey[600],
              )
                  : null,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _pickImage,
              child: const Text(
                'Change Photo',
                style: TextStyle(color: Color(0xFF2D46B9)),
              ),
            ),
            _buildTextField('First Name', _firstNameController,
                hintText: 'Enter your name'),
            _buildTextField('Last Name', _lastNameController,
                hintText: 'Enter your name'),
            _buildTextField('Username', _usernameController,
                hintText: 'Enter your username'),
            _buildSectionTitle('Contact Information'),
            _buildTextField('Email', _emailController,
                hintText: 'Enter your email'),
            _buildTextField('Phone Number', _phoneController,
                hintText: 'Enter your phone number'),
            // _buildTextField('Date Of Birth', _dateOfBirthController,
            //     hintText: 'Enter your date of birth'),
            TextFormField(
              controller: _dateOfBirthController,
              readOnly: true, // Make the field read-only
              decoration: InputDecoration(
                labelText: 'Date of Birth (Optional)',
                hintText: 'Select your date of birth',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(width: 1.5),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context), // Open the date picker
                ),
              ),
            ),
            // _buildSectionTitle('Additional Information'),
            // _buildTextField('Location', "Sri Lanka" as TextEditingController,
            //     hintText: 'Enter your location'),
            // _buildTextField('Language', 'English' as TextEditingController,
            //     hintText: 'Enter your language'),
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
