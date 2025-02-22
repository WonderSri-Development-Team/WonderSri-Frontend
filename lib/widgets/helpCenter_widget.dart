import 'package:flutter/material.dart';

class PrivacyPolicyDetail extends StatelessWidget {
  final String title;
  final String description;

  const PrivacyPolicyDetail({
    super.key,
    required this.title,
    required this.description,
  });

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
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title == "Data Collection")
                _buildDescription(
                  "We collect information that you provide directly to us, information we obtain automatically when you use our services, and information from other sources.",
                ),
              if (title == "How We Use Your Data")
                _buildDescription(
                  "We use the information we collect to provide, maintain, and improve our services, to communicate with you, and to develop new services.",
                ),
              if (title == "Your Rights")
                _buildDescription(
                  "You have the right to access, update, or delete your information and to opt out of certain uses of your data.",
                ),
              if (title == "Data Security")
                _buildDescription(
                  "We use appropriate technical and organizational measures to protect the personal information that we collect and process about you.",
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }
}
