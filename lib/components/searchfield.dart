// lib/components/searchfield.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged; // Add callback for text change

  const SearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.orange.shade50,
      ),
      child: TextField(
        onChanged: onChanged, // Trigger callback when text changes
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.orange.shade700),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          suffixIcon: Icon(
            FontAwesomeIcons.search,
            size: 16,
            color: Colors.orange.shade700,
          ),
        ),
      ),
    );
  }
}
