import 'package:flutter/material.dart';
import 'package:frontend/screens/user_profile/UserModel.dart';
/*
class User {
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String gender; // Added gender field
  final String location;
  final String language;

  User({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender, // Added gender field
    required this.location,
    required this.language,
  });
}*/

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
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
  String _selectedGender = 'Male'; // Default gender selection
  DateTime _selectedDate = DateTime.now(); // Default date

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _locationController = TextEditingController();
    _languageController = TextEditingController();
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText, // Add hint text here
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = '${_selectedDate.toLocal()}'
            .split(' ')[0]; // format the date as yyyy-mm-dd
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
                gender: _selectedGender,
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
              backgroundImage: AssetImage(
                  'assets/profile_picture.png'), // Replace with user's photo
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
            const SizedBox(height: 16),
            const Divider(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Contact Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _buildTextField('Email', _emailController,
                hintText: 'Enter your email'),
            _buildTextField('Phone Number', _phoneController,
                hintText: 'Enter your phone number'),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dateOfBirthController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Additional Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _buildTextField('Location', _locationController,
                hintText: 'Enter your location'),
            _buildTextField('Language', _languageController,
                hintText: 'Enter your language'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: 'Gender',
                hintText: 'Select your Gender',
                border: OutlineInputBorder(),
              ),
              items: ['Male', 'Female', 'Other', 'Prefer not to say']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Privacy Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
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
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                // Add delete functionality here
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
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Perform delete action here
                            Navigator.of(context).pop();
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
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              label: Text(
                'Delete Account',
                style: TextStyle(color: Colors.red),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 12.0),
                backgroundColor:
                    Colors.red.withOpacity(0.1), // Light red background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
