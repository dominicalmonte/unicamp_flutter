import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/cardbuildings.dart';
import '../components/burger.dart';
import '../pages/viewdetails.dart'; // Import the viewdetails.dart page
import '../components/search_delegate.dart'; // Import the SearchDelegate

class BuildingsPage extends StatefulWidget {
  const BuildingsPage({super.key});

  @override
  State<BuildingsPage> createState() => _BuildingsPageState();
}

class _BuildingsPageState extends State<BuildingsPage> {
  List<QueryDocumentSnapshot> allBuildings = [];
  List<QueryDocumentSnapshot> filteredBuildings = [];
  List<String> previousSearches = []; // To store previous search queries

  @override
  void initState() {
    super.initState();
    _fetchBuildings();
  }

  Future<void> _fetchBuildings() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Buildings')
        .orderBy('Name') // Ensure buildings are fetched alphabetically
        .get();

    setState(() {
      allBuildings = snapshot.docs;
      filteredBuildings = List.from(allBuildings); // Initially show all buildings in alphabetical order
    });
  }

  void _filterBuildings(String query) {
    if (query.trim().isEmpty) {
      // Reset to all buildings if the query is blank
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          filteredBuildings = List.from(allBuildings); // Create a copy to avoid modifying the original list
          filteredBuildings.sort((a, b) {
            final dataA = a.data() as Map<String, dynamic>;
            final dataB = b.data() as Map<String, dynamic>;
            final buildingNameA = (dataA['Name'] ?? '').toLowerCase();
            final buildingNameB = (dataB['Name'] ?? '').toLowerCase();
            return buildingNameA.compareTo(buildingNameB); // Sort alphabetically by building name
          });
        });
      });
    } else {
      // Filter buildings and sort them alphabetically
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          filteredBuildings = allBuildings.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final buildingName = (data['Name'] ?? '').toLowerCase();
            final locationLabel = (data['LocationLabel'] ?? '').toLowerCase(); // Assuming 'LocationLabel' is the field for locations

            return buildingName.contains(query.toLowerCase()) ||
                locationLabel.contains(query.toLowerCase()); // Check both name and location
          }).toList();

          // Sort the filtered list alphabetically
          filteredBuildings.sort((a, b) {
            final dataA = a.data() as Map<String, dynamic>;
            final dataB = b.data() as Map<String, dynamic>;
            final buildingNameA = (dataA['Name'] ?? '').toLowerCase();
            final buildingNameB = (dataB['Name'] ?? '').toLowerCase();
            return buildingNameA.compareTo(buildingNameB); // Sort alphabetically by building name
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // Keep dynamic height if needed
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left:12.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: MediaQuery.of(context).size.width * 0.08, // Dynamic size based on screen width
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    size: MediaQuery.of(context).size.width * 0.08,
                    color: const Color(0xFF3D00A5), 
                  ),
                  onPressed: () async {
                    final query = await showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(
                        previousSearches: previousSearches,
                        onSearchSubmitted: (query) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _filterBuildings(query);
                            if (query.isNotEmpty && !previousSearches.contains(query)) {
                              previousSearches.add(query);
                            }
                          });
                        },
                      ),
                    );

                    if (query != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _filterBuildings(query);
                      });
                    }
                  },
                ),
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
                      fontSize: 26.0,
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
