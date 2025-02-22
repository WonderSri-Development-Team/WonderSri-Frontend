
import 'package:flutter/material.dart';

class SecurityTips extends StatelessWidget {
  const SecurityTips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(
              Icons.info_outline,
              color: Colors.blue,
              size: 20,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Security Tips ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),

      ],
    );
  }

  
  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
