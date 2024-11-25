import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart'; // Import provider for AuthProvider
import '../provider/auth_provider.dart'; // Import your AuthProvider
import '../pages/buildings.dart';
import '../pages/locations.dart';

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        FontAwesomeIcons.bars, // Use FontAwesome bars icon
      ),
      onPressed: () {
        Scaffold.of(context).openDrawer(); // Open the drawer when pressed
      },
    );
  }

  static Drawer drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Header with an image background
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/Main Page.jpg'), // Load the asset
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7), // Apply opacity
                  BlendMode.srcOver,
                ),
              ),
            ),
            child: const Center(
              child: Text(
                'UniCamp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Drawer Items
          _buildDrawerItem(
            context,
            icon: Icons.home,
            label: 'Home',
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.apartment,
            label: 'Buildings',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BuildingsPage()),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.map,
            label: 'Locations',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LocationsPage()),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            label: 'Logout',
            onTap: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacementNamed(context, '/login'); // Redirect to login
            },
          ),
        ],
      ),
    );
  }

  // Reusable drawer item builder with hover effect
  static Widget _buildDrawerItem(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
      hoverColor: Colors.grey[300], // Hover color effect
      onTap: onTap,
    );
  }
}
