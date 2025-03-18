import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  String? expandedSection;

  // Function to launch email
  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@example.com',
      queryParameters: {
        'subject': 'Support Request',
        'body': 'Hello, I need help with...',
      },
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        // Show error dialog if email can't be launched
        if (context.mounted) {
          _showErrorDialog('Could not launch email client');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog('Error launching email: $e');
      }
    }
  }

  // Function to show chat dialog
  void _showChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Live Chat Support'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter your message',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Here you would typically implement the actual chat functionality
                    Navigator.of(context).pop();
                    _showSuccessSnackBar('Message sent to support team');
                  },
                  child: const Text('Start Chat'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to show success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help Center',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How can we help?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildSupportCards(),
              //const SizedBox(height: 32),
              /* const Text(
                'Popular Topics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),*/
              const SizedBox(height: 16),
              //_buildTopicsGrid(),
              const SizedBox(height: 32),
              _buildPrivacySection(),
              const SizedBox(height: 32),
              _buildNeedHelp(),
              const SizedBox(height: 32),
              _buildSocialMediaSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCards() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _showChatDialog, // Updated to show chat dialog
            child: _buildSupportCard(
              icon: Icons.chat_bubble_outline,
              title: 'Contact Support',
              subtitle: '24/7 Live Chat',
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: _launchEmail, // Updated to launch email
            child: _buildSupportCard(
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: 'Response in 24h',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 0,
      color: Colors.blue.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Widget _buildTopicsGrid() {
    final topics = [
      {'icon': Icons.security, 'title': 'Account & Security'},
      {'icon': Icons.payment, 'title': 'Payments & Billing'},
      {'icon': Icons.build, 'title': 'Technical Issues'},
      {'icon': Icons.privacy_tip, 'title': 'Privacy & Data'},
      {'icon': Icons.description, 'title': 'Terms of Service'},
      {'icon': Icons.apps, 'title': 'App Features'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading:
                Icon(topics[index]['icon'] as IconData, color: Colors.blue),
            title: Text(
              topics[index]['title'] as String,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        );
      },
    );
  }*/

  Widget _buildPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildPrivacyItem('Data Collection'),
        _buildPrivacyItem('How We Use Your Data'),
        _buildPrivacyItem('Your Rights'),
        _buildPrivacyItem('Data Security'),
      ],
    );
  }

  Widget _buildPrivacyItem(String title) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            _getPrivacyPolicyDescription(title),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  String _getPrivacyPolicyDescription(String title) {
    switch (title) {
      case 'Data Collection':
        return "We collect information that you provide directly to us, information we obtain automatically when you use our services, and information from other sources.";
      case 'How We Use Your Data':
        return "We use the information we collect to provide, maintain, and improve our services, to communicate with you, and to develop new services.";
      case 'Your Rights':
        return "You have the right to access, update, or delete your information and to opt out of certain uses of your data.";
      case 'Data Security':
        return "We use appropriate technical and organizational measures to protect the personal information that we collect and process about you.";
      default:
        return "";
    }
  }

  Widget _buildNeedHelp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Still need help?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildHelpItem(
            Icons.access_time, '24/7 Available', 'We\'re here to help anytime'),
        _buildHelpItem(Icons.email, 'Email Support', 'wonderSri@gmail.com'),
        _buildHelpItem(Icons.phone, 'Phone Support', '(+94)) 123-4567'),
      ],
    );
  }

  Widget _buildHelpItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return Column(
      children: [
        Text(
          'Follow us on social media',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(FontAwesomeIcons.instagram,
                'https://www.instagram.com/wonde_rsri?igsh=MWxsNTV2c2dkd3V2Zw=='),
            const SizedBox(width: 24),
            _buildSocialIcon(FontAwesomeIcons.youtube, 'https://youtube.com'),
            const SizedBox(width: 24),
            _buildSocialIcon(FontAwesomeIcons.linkedin,
                'https://www.linkedin.com/company/wonder-sri/'),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return InkWell(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        }
      },
      child: Icon(icon, color: Colors.blue),
    );
  }
}
