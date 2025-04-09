import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/screens/user_profile/UserModel.dart';
import 'EditProfilePage.dart' as editProfile;

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? _user;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        print('Access token is null');
        setState(() {
          _isLoading = false;
          _errorMessage = 'No access token found. Please log in again.';
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No access token found. Please log in again.')),
          );
        }
        return;
      }

      print('Settings page Access token: $accessToken');
      final user = await fetchUserProfile(accessToken);

      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching profile: $error');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load profile data: $error';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile data: $error')),
        );
      }
    }
  }

  Future<User> fetchUserProfile(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('https://wondersri-backend-tracking.onrender.com/auth/users/get-profile'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Parsed response data: $responseData');
        return User.fromJson(responseData);

      } else if (response.statusCode == 401) {
        // Token expired or invalid
        print('Unauthorized: Token might be expired');
        throw Exception('Session expired. Please log in again.');
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load profile data (${response.statusCode})');
      }
    } catch (e) {
      print("Network error: $e");
      throw Exception('Network error: $e');
    }
  }

  void _retryFetchProfile() {
    setState(() {
      _errorMessage = null;
    });
    _fetchUserProfile();
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
              if (_user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => editProfile.EditProfilePage(
                      user: _user!,
                    ),
                  ),
                ).then((_) => _fetchUserProfile()); // Refresh after editing
              }
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
      body:  _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error Loading Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _retryFetchProfile,
              child: Text('Retry'),
            ),
          ],
        ),
      )
      : SingleChildScrollView(
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
                      image: _user?.profilePicture != null
                          ? DecorationImage(
                              image: NetworkImage(_user!.profilePicture!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _user?.profilePicture == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey[600],
                          )
                        : null,
                  ),
                  SizedBox(height: 12),
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
                      'Full Name',
                      _user != null
                          ? '${_user!.firstName} ${_user!.lastName}'
                          : 'Loading...',
                      Icons.person_outline),
                  buildProfileItemCard(
                      'Username',
                      _user?.username ?? 'Loading...',
                      Icons.person_outline),
                  buildProfileItemCard(
                      'Email',
                      _user?.email ?? 'Loading...',
                      Icons.email_outlined),
                  buildProfileItemCard(
                      'Phone',
                      _user?.phoneNumber ?? 'Not provided',
                      Icons.phone_outlined),
                  buildProfileItemCard(
                      'Date of Birth',
                      _user?.dob ?? 'Not provided',
                      Icons.calendar_today_outlined),
                  buildProfileItemCard(
                      'Location',
                      "Sri Lanka",
                      Icons.location_on_outlined),
                  buildProfileItemCard(
                      'Language',
                      "English",
                      Icons.language_outlined,
                      showDivider: false),
                ],
              ),
            ),

            SizedBox(height: 24),

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
