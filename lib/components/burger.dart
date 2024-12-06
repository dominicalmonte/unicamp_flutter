import 'package:flutter/material.dart';
import 'package:flutter_unicamp/pages/login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../pages/buildings.dart';
import '../pages/locations.dart';

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        FontAwesomeIcons.bars,
      ),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }

  static Drawer drawer(BuildContext context) {
    String currentRouteName = ModalRoute.of(context)?.settings.name ?? '';

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/Main Page.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.7),
                        BlendMode.srcOver,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/UniCampAlt.png",
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Welcome to UniCamp, the official map app of the Ateneo de Davao University.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    children: [
                      _buildDrawerItem(
                        context,
                        icon: Icons.home,
                        label: 'Home',
                        isSelected: currentRouteName == '/home',
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/home'),
                      ),
                      const SizedBox(height: 10),
                      _buildDrawerItem(
                        context,
                        icon: Icons.apartment,
                        label: 'Buildings',
                        isSelected: currentRouteName == '/buildings' ||
                            context.widget is BuildingsPage,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BuildingsPage()),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildDrawerItem(
                        context,
                        icon: Icons.map,
                        label: 'Locations',
                        isSelected: currentRouteName == '/locations' ||
                            context.widget is LocationsPage,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LocationsPage()),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildDrawerItem(
                        context,
                        icon: Icons.logout,
                        label: 'Logout',
                        isSelected: false,
                        onTap: () async {
                          await authProvider.logout();
                          Navigator.pop(context); // Close the drawer
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const LoginScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return child; // No transition
                              },
                              settings: const RouteSettings(name: '/login'),
                            ),
                            (route) => false, // Remove all previous routes
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.account_circle,
                  color: const Color(0xFF3D00A5),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    currentUser != null
                        ? (currentUser.isAnonymous
                            ? 'Logged in as Guest'
                            : currentUser.email ?? 'Unknown User')
                        : 'Not Logged In',
                    style: TextStyle(
                      color: const Color(0xFF3D00A5),
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Container(
      color: isSelected ? Colors.grey[200] : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF3D00A5),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: const Color(0xFF3D00A5),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        hoverColor: Colors.grey[300],
        onTap: onTap,
      ),
    );
  }
}
