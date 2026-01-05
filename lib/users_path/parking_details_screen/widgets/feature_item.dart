import 'package:flutter/material.dart';

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureItem({super.key, required this.icon, required this.text, });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Color(0XFF2F66F5)),
          const SizedBox(width: 10),
          Text(text,
              style: const TextStyle(color: Colors.black87, fontSize: 15)),
        ],
      ),
    );
  }
}
