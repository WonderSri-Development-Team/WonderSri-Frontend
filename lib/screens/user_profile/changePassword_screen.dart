import 'package:flutter/material.dart';

class ChangepasswordScreen extends StatefulWidget {
  //const PasswordChangeScreen({Key? key}) : super(key: key);

  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<ChangepasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Password requirements checklist
  bool hashCharacters = false;
  bool hasUppercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;

  void _updatePasswordStrength(String password) {
    setState(() {
      hashCharacters = password.length >= 8;
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasNumber = password.contains(RegExp(r'[0-9]'));
      hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Password has been updated successfully!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // You can add navigation here to return to previous screen
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Password and Security'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(28.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Password Field
              Text('Current Password',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextFormField(
                controller: _currentPasswordController,
                obscureText: !_isCurrentPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Enter current password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isCurrentPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  // Add your current password validation logic here
                  return null;
                },
              ),
              SizedBox(height: 20),

              // New Password Field
              Text('New Password',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextFormField(
                controller: _newPasswordController,
                obscureText: !_isNewPasswordVisible,
                onChanged: _updatePasswordStrength,
                decoration: InputDecoration(
                  hintText: 'Enter new password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (!hashCharacters ||
                      !hasUppercase ||
                      !hasNumber ||
                      !hasSpecialChar) {
                    return 'Password does not meet requirements';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Confirm Password Field
              Text('Confirm New Password',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Confirm new password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Password Requirements Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password Requirements',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    RequirementRow(
                      isValid: hashCharacters,
                      text: 'At least 8 characters',
                    ),
                    RequirementRow(
                      isValid: hasUppercase,
                      text: 'Include uppercase letter',
                    ),
                    RequirementRow(
                      isValid: hasNumber,
                      text: 'Include number',
                    ),
                    RequirementRow(
                      isValid: hasSpecialChar,
                      text: 'Include special character',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Security Tips Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.security, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Security Tips',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    SecurityTipRow('Never share your password with anyone'),
                    SecurityTipRow('Use a unique password for each account'),
                    SecurityTipRow('Avoid using personal information'),
                    SecurityTipRow('Change your password regularly'),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Update Password Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Add your password update logic here
                      _showSuccessDialog();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Update Password',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'For additional security, you may be asked to verify your identity',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RequirementRow extends StatelessWidget {
  final bool isValid;
  final String text;

  RequirementRow({required this.isValid, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.check_circle_outline,
            color: isValid ? Colors.green : Colors.grey,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}

class SecurityTipRow extends StatelessWidget {
  final String text;

  SecurityTipRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: Colors.blue, fontSize: 16)),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
