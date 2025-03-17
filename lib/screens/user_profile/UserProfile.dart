import 'package:flutter/material.dart';
import 'package:frontend/screens/user_profile/EditProfilePage.dart' as edit;
import 'package:frontend/screens/user_profile/UserModel.dart' as model;

class UserProfilePage extends StatefulWidget {
  final model.User user;

  const UserProfilePage({super.key, required this.user});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late model.User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user; // Initialize with the logged-in user's data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Personal Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              _navigateToEditProfile();
            },
            child: Text(
              'Edit',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Photo Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      image: _user.profilePhoto != null
                          ? DecorationImage(
                              image: NetworkImage(_user.profilePhoto!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _user.profilePhoto == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey[600],
                          )
                        : null,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Change Photo',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Profile Information
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  buildProfileItemCard(
                      'Full Name', _user.fullName, Icons.person_outline),
                  buildProfileItemCard(
                      'Username', _user.username, Icons.person_outline),
                  buildProfileItemCard(
                      'Email', _user.email, Icons.email_outlined),
                  buildProfileItemCard(
                      'Phone', _user.phone, Icons.phone_outlined),
                  buildProfileItemCard('Date of Birth', _user.dateOfBirth,
                      Icons.calendar_today_outlined),
                  buildProfileItemCard(
                      'Gender', _user.gender, Icons.people_outline),
                  buildProfileItemCard(
                      'Location', _user.location, Icons.location_on_outlined),
                  buildProfileItemCard(
                      'Language', _user.language, Icons.language_outlined,
                      showDivider: false),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Delete Account Button
            // Delete Account Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.delete_outline,
                  color: Color(0xFFE53935),
                  size: 20,
                ),
                label: Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Color(0xFFE53935),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  showDeleteAccount();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFFFFEBEE), // Very light red/pink background
                  foregroundColor: Color(0xFFE53935),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        color: Color(0xFFE53935).withOpacity(0.5), width: 1),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget buildProfileItemCard(String label, String value, IconData icon,
      {bool showDivider = true}) {
    return InkWell(
      onTap: () {
        // Handle tapping on specific profile items
        // You can navigate to dedicated edit pages for each item
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                Icon(icon, size: 22, color: Colors.grey),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              height: 1,
              indent: 56,
              endIndent: 16,
            ),
        ],
      ),
    );
  }

  void _navigateToEditProfile() async {
    // Navigate to the edit profile page and wait for the result
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => edit.EditProfilePage(
          user: _user,
          userModel:
              null, // It's okay to pass null here if your EditProfilePage handles it
        ),
      ),
    );

    // Update the user data if the profile was edited
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
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[700]),
              ),
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
