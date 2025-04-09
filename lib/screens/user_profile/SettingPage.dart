
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/screens/helpCenter.dart';
import 'package:frontend/screens/user_profile/EditProfilePage.dart' as editProfile;
import 'package:frontend/screens/user_profile/UserModel.dart';
import 'package:frontend/screens/user_profile/UserProfile.dart';
import 'package:frontend/screens/user_profile/changePassword_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = false;
  User? _user;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // Fetch user data when the page loads
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
      appBar: AppBar(
        title: Text('Profile Settings'),
        backgroundColor: Color(0xFF2D46B9),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorView()
          : SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfileSection(),
            SizedBox(height: 25.0),
            _buildAccountSettingsSection(),
            SizedBox(height: 25.0),
            _buildSupportAndHelpSection(),
            SizedBox(height: 24.0),
            _buildAppInformationSection(),
            SizedBox(height: 24.0),
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          SizedBox(height: 16),
          Text(
            'Error Loading Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              _errorMessage ?? 'An unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _retryFetchProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2D46B9),
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          child: Icon(
            Icons.person,
            size: 30.0,
            color: Colors.white,
          ),
          // backgroundColor: Color(0xFF2D46B9),
          // backgroundImage: _user?.profilePicture != null && _user!.profilePicture!.isNotEmpty
          //     ? NetworkImage(_user!.profilePicture!)
          //     : null,
          // child: (_user?.profilePicture == null || _user!.profilePicture!.isEmpty)
          //     ? Icon(
          //   Icons.person,
          //   size: 30.0,
          //   color: Colors.white,
          // )
          //     : null,
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // _user?.firstName ?? 'User',
                '${_user?.firstName ?? ''} ${_user?.lastName ?? 'User'}',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D46B9),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _user?.email ?? 'email@example.com',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
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
                  'Edit Profile',
                  style: TextStyle(
                    color: Color(0xFF2D46B9),
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSettingTitle('Account Settings'),
        buildSettingItem(
          'Personal Information',
          Icons.person,
          onTap: () {
            if (_user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(),
                ),
              );
            }
          },
        ),
        buildSettingItem(
          'Password and Security',
          Icons.lock,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangepasswordScreen(),
              ),
            );
          },
        ),
        buildSettingItem('Payments method', Icons.payment),
        buildSettingItem(
          'Notification',
          Icons.notifications,
          switchValue: isNotificationsEnabled,
          onSwitchChanged: (value) {
            setState(() {
              isNotificationsEnabled = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSupportAndHelpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSettingTitle('Support & Help'),
        buildSettingItem(
          'Help Center',
          Icons.help,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HelpCenter(),
              ),
            );
          },
        ),
        buildSettingItem(
          'Contact Support',
          Icons.contact_support,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HelpCenter(),
              ),
            );
          },
        ),
        buildSettingItem(
          'Privacy Policy',
          Icons.privacy_tip,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HelpCenter(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSettingTitle('App Information'),
        InkWell(
          onTap: () async {
            const url = 'https://wondersri-marketing.vercel.app/#team'; // Replace with your URL
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Could not launch the website.'),
                ),
              );
            }
          },
          child: buildSettingItem(
            'About Us',
            Icons.info,
          ),
        ),
        buildSettingItem('Rate App', Icons.star),
        buildSettingItem('Share App', Icons.share),
      ],
    );
  }
}

// Helper methods
Widget buildSettingTitle(String title) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 0, 3, 17),
      ),
    ),
  );
}

Widget buildSettingItem(String title, IconData icon,
    {VoidCallback? onTap, bool? switchValue, Function(bool)? onSwitchChanged, String? url}) {
  return ListTile(
    leading: Icon(
      icon,
      color: Color(0xFF2D46B9),
    ),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    ),
    trailing: switchValue != null
        ? Switch(
      value: switchValue,
      onChanged: onSwitchChanged,
      activeColor: Color(0xFF2D46B9),
    )
        : Icon(
      Icons.arrow_forward_ios,
      size: 16.0,
      color: Colors.grey,
    ),
    onTap: switchValue == null
        ? (url != null
        ? () async {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
        : onTap)
        : null,
  );
}