import 'package:flutter/material.dart';
import 'package:frontend/screens/user_profile/EditProfilePage.dart';
import 'package:frontend/screens/user_profile/changePassword_screen.dart';


import 'UserModel.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFF2D46B9),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25),
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
                    TextButton(
                      onPressed: () {
                        // Navigate to edit profile page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                                user: User(
                                    fullName: '',
                                    username: '',
                                    email: '',
                                    phone: '',
                                    dateOfBirth: '',
                                    gender: '',
                                    location: '',
                                    language: '')), //  Open EditProfilePage
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
            buildSettingItem('Personal Information', Icons.person),
            
            //buildSettingItem('Password and Security', Icons.lock),
            buildSettingItem(
 
  'Password and Security',
  Icons.lock,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangepasswordScreen()),
    );
  },
),
            
            
            buildSettingItem('Payments method ', Icons.payment),
            buildSettingItem('Notification', Icons.notifications),
            SizedBox(height: 25.0),
            buildSettingTitle('App Preferences'),
            buildSettingItem('Language', Icons.language),
            buildSettingItem('Dark Theme', Icons.color_lens),
            buildSettingItem('Location Services', Icons.location_on),
            buildSettingItem('Currency', Icons.attach_money),
            SizedBox(height: 25.0),
            buildSettingTitle('Support & Help'),
            buildSettingItem('Help Center', Icons.help),
            buildSettingItem('Contact Support', Icons.contact_support),
            buildSettingItem('Privacy Policy', Icons.privacy_tip),
            SizedBox(height: 24.0),
            buildSettingTitle('App Information'),
            buildSettingItem('About Us', Icons.info),
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
Widget buildSettingItem(String title, IconData icon, {VoidCallback? onTap}) {
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
    trailing: Icon(
      Icons.arrow_forward_ios,
      size: 16.0,
      color: Colors.grey,
    ),
    onTap: onTap,
  );
}
