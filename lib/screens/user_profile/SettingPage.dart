import 'package:flutter/material.dart';
import 'package:frontend/screens/helpCenter.dart';
import 'package:frontend/screens/user_profile/EditProfilePage.dart' as editProfile;
import 'package:frontend/screens/user_profile/UserModel.dart';
import 'package:frontend/screens/user_profile/UserProfile.dart';
import 'package:frontend/screens/user_profile/changePassword_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  // Load saved notification setting
  Future<void> _loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  // Save notification setting
  Future<void> _saveNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFF2D46B9),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Color(0xFF2D46B9),
                  child: Icon(
                    Icons.person,
                    size: 30.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D46B9),
                      ),
                    ),
                    Text(
                      'johndoe@example.com',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        final currentUser = User(
                          fullName: 'John Doe',
                          username: 'johndoe',
                          email: 'johndoe@example.com',
                          phone: '+1234567890',
                          dateOfBirth: '01/01/1990',
                          gender: 'Male',
                          location: 'Sri Lanka',
                          language: 'English',
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => editProfile.EditProfilePage(
                              user: currentUser,
                              // userModel: null, // If you have a model, pass it here
                            ),
                          ),
                        );
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
              ],
            ),
            SizedBox(height: 25.0),
            buildSettingTitle('Account Settings'),
            buildSettingItem(
              'Personal Information',
              Icons.person,
              onTap: () {
                final currentUser = User(
                  fullName: 'John Doe',
                  username: 'johndoe',
                  email: 'johndoe@example.com',
                  phone: '+1234567890',
                  dateOfBirth: '01/01/1990',
                  gender: 'Male',
                  location: 'Sri Lanka',
                  language: 'English',
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(user: currentUser),
                  ),
                );
              },
            ),
            buildSettingItem(
              'Password and Security',
              Icons.lock,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangepasswordScreen()),
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
                _saveNotificationPreference(value);
              },
            ),
            SizedBox(height: 25.0),
            buildSettingTitle('Support & Help'),
            buildSettingItem(
              'Help Center',
              Icons.help,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpCenter()),
                );
              },
            ),
            buildSettingItem(
              'Contact Support',
              Icons.contact_support,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpCenter()),
                );
              },
            ),
            buildSettingItem(
              'Privacy Policy',
              Icons.privacy_tip,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpCenter()),
                );
              },
            ),
            SizedBox(height: 24.0),
            buildSettingTitle('App Information'),
            buildSettingItem('About Us', Icons.info,
                url: 'https://wondersri-marketing.vercel.app'),
            buildSettingItem('Rate App', Icons.star),
            buildSettingItem('Share App', Icons.share),
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
}

// Create setting title
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

// Create setting item
Widget buildSettingItem(String title, IconData icon,
    {VoidCallback? onTap,
      bool? switchValue,
      Function(bool)? onSwitchChanged,
      String? url}) {
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
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url),
            mode: LaunchMode.externalApplication);
      }
    }
        : onTap)
        : null,
  );
}