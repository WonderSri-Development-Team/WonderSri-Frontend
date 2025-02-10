
import 'package:flutter/material.dart';
import 'package:frontend/screens/user_profile/EditProfilePage.dart';
import 'package:frontend/screens/user_profile/UserModel.dart';






class UserProfilePage extends StatefulWidget {
  final User user;

  UserProfilePage({required this.user});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user; // Initialize with the logged-in user's data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF2D46B9),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to the edit profile page
              _navigateToEditProfile();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Color(0xFF2D46B9),
                    child: Icon(
                      Icons.person,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Change Photo',
                    style: TextStyle(
                      color: Color(0xFF2D46B9),
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            buildprofileItem('Full Name', _user.fullName),
            buildprofileItem('Username', _user.username),
            buildprofileItem('Email', _user.email),
            buildprofileItem('Phone', _user.phone),
            buildprofileItem('Date of Birth', _user.dateOfBirth),
            buildprofileItem('Gender', _user.gender),
            buildprofileItem('Location', _user.location),
            buildprofileItem('Language', _user.language),
            SizedBox(height: 24.0),
            Center(
              child: TextButton(
                onPressed: () {
                  // Handle delete account
                  showDeleteAccount();
                },
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildprofileItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
          Divider(
            height: 20,
          )
        ],
      ),
    );
  }

  void _navigateToEditProfile() async {
    // Navigate to the edit profile page and wait for the result
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(user: _user),
      ),
    );

//update the user data if the profile was edited
    if (updatedUser != null) {
      // Update the user object
      setState(() {
        _user = updatedUser;
      });
    }
  }

  void showDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle account deletion
                Navigator.pop(context);
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
  }
}