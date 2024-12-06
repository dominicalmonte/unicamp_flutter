import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/burger.dart'; // Import the burger menu
import '../components/cardlocations.dart'; // Reuse the LocationCard widget

class ExtensiveDetails extends StatelessWidget {
  final Map<String, dynamic> locationData;
  final QueryDocumentSnapshot documentSnapshot;

  const ExtensiveDetails({
    required this.locationData,
    required this.documentSnapshot,
  });

  @override
  Widget build(BuildContext context) {
    final officeName = locationData['Name'] ?? 'Unknown Office';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 233, 242),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            leadingWidth: MediaQuery.of(context).size.width * 0.15,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: MediaQuery.of(context).size.width * 0.08,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(), // This will open the drawer
                );
              },
            ),
            title: Image.asset(
              "assets/UniCampLogo.png",  // Keep the logo as before
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            centerTitle: true,
          ),
        ),
      ),
      drawer: BurgerMenu.drawer(context), // Add the BurgerMenu drawer here
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/Main Page.jpg",  // Background image
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),  // Overlay for readability
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0)
                .copyWith(top: 8.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Text(
                    officeName,  // Display the office name here
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: LocationCard(
                      data: locationData,
                      documentSnapshot: documentSnapshot,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
