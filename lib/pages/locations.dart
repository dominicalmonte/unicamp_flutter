import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/cardlocations.dart';
import '../components/burger.dart';
import '../components/searchfield.dart';
import '../pages/viewdetails.dart'; // Import the viewdetails.dart page

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  List<QueryDocumentSnapshot> allLocations = [];
  List<QueryDocumentSnapshot> filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    final snapshot = await FirebaseFirestore.instance.collection('Locations').get();
    setState(() {
      allLocations = snapshot.docs;
      filteredLocations = allLocations; // Initially show all locations
    });
  }

  void _filterLocations(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredLocations = allLocations; // Show all if query is empty
      } else {
        filteredLocations = allLocations.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final locationName = (data['Name'] ?? '').toLowerCase(); // Location name
          final buildingLabel = (data['BuildingLabel'] ?? '').toLowerCase(); // Associated building

          return locationName.contains(query.toLowerCase()) ||
                 buildingLabel.contains(query.toLowerCase()); // Check name and building
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              Builder(
                builder: (context) {
                  return const BurgerMenu();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 4.0),
                child: SearchField(onChanged: _filterLocations), // Attach search callback
              ),
            ],
          ),
        ),
      ),
      drawer: BurgerMenu.drawer(context),
      body: Stack(
        children: [
          // Fixed background image layer
          Positioned.fill(
            child: Image.asset(
              "assets/Main Page.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // Optional semi-transparent overlay for better text visibility
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // Main content layer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(top: 8.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Locations',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // List of buildings
                Expanded(
                  child: filteredLocations.isEmpty
                      ? const Center(child: Text('No buildings found.', style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                          itemCount: filteredLocations.length,
                          itemBuilder: (context, index) {
                            final location = filteredLocations[index];
                            final data = location.data() as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewDetailsPage(building: location),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: LocationCard(data: data),
                              ),
                            );
                          },
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
