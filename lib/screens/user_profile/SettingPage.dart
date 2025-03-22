import 'package:flutter/material.dart';
import 'package:frontend/screens/helpCenter.dart';
import 'package:frontend/screens/user_profile/EditProfilePage.dart'
as editProfile;
import 'package:frontend/screens/user_profile/UserModel.dart';
import 'package:frontend/screens/user_profile/UserProfile.dart';

import 'package:frontend/screens/user_profile/changePassword_screen.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = false;

  get userModel => null;

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
                      'User email ',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                    // In SettingsPage.dart
                    TextButton(
                      onPressed: () {
                        // Create a User object with current user data
                        final currentUser = User(
                          fullName: 'John Doe', // Replace with actual data
                          username: 'johndoe', // Replace with actual data
                          email:
                          'johndoe@example.com', // Replace with actual data
                          phone: '+1234567890', // Replace with actual data
                          dateOfBirth: '01/01/1990', // Replace with actual data
                          gender: 'Male', // Replace with actual data
                          location: 'Sri Lanka ', // Replace with actual data
                          language: 'English', // Replace with actual data
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => editProfile.EditProfilePage(
                              user: currentUser,
                              userModel: userModel,
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
                // Create a User object with current user data
                final currentUser = User(
                  fullName: 'John Doe', // Replace with actual user data
                  username: 'johndoe',
                  email: 'johndoe@example.com',
                  phone: '+1234567890',
                  dateOfBirth: '01/01/1990',
                  gender: 'Male',
                  location: 'New York',
                  language: 'English',
                );

                // Navigate to the UserProfilePage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(user: currentUser),
                  ),
                );
              },
            ),

            //buildSettingItem('Password and Security', Icons.lock),
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

            buildSettingItem('Payments method ', Icons.payment),
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
            SizedBox(height: 25.0),
            buildSettingTitle('Support & Help'),

            buildSettingItem(
              'Help Center',
              Icons.help,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HelpCenter()), // Navigate to HelpCenter
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
                      builder: (context) =>
                          HelpCenter()), // Navigate to HelpCenter
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
                      builder: (context) =>
                          HelpCenter()), // Navigate to HelpCenter
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

//create setting tittle
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

//create setting item
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