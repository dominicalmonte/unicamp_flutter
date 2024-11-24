import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/cardbuildings.dart';
import '../components/burger.dart';
import '../components/searchfield.dart';
import '../pages/viewdetails.dart'; // Import the viewdetails.dart page

class BuildingsPage extends StatefulWidget {
  const BuildingsPage({super.key});

  @override
  State<BuildingsPage> createState() => _BuildingsPageState();
}

class _BuildingsPageState extends State<BuildingsPage> {
  List<QueryDocumentSnapshot> allBuildings = [];
  List<QueryDocumentSnapshot> filteredBuildings = [];

  @override
  void initState() {
    super.initState();
    _fetchBuildings();
  }

  Future<void> _fetchBuildings() async {
    final snapshot = await FirebaseFirestore.instance.collection('Buildings').get();
    setState(() {
      allBuildings = snapshot.docs;
      filteredBuildings = allBuildings; // Initially show all buildings
    });
  }

  void _filterBuildings(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredBuildings = allBuildings; // Show all if query is empty
      } else {
        filteredBuildings = allBuildings.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final buildingName = (data['Name'] ?? '').toLowerCase();
          final locationLabel = (data['LocationLabel'] ?? '').toLowerCase(); // Assuming 'LocationLabel' is the field for locations

          return buildingName.contains(query.toLowerCase()) ||
                 locationLabel.contains(query.toLowerCase()); // Check both name and location
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
                child: SearchField(onChanged: _filterBuildings), // Attach search callback
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
                    'Buildings',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // List of buildings
                Expanded(
                  child: filteredBuildings.isEmpty
                      ? const Center(child: Text('No buildings found.', style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                          itemCount: filteredBuildings.length,
                          itemBuilder: (context, index) {
                            final building = filteredBuildings[index];
                            final data = building.data() as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewDetailsPage(building: building),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: BuildingCard(data: data),
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