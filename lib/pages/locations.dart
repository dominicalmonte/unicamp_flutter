import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/cardlocations.dart';
import '../components/burger.dart';
import '../components/search_delegate.dart'; // Import the SearchDelegate

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  List<QueryDocumentSnapshot> allLocations = [];
  List<QueryDocumentSnapshot> filteredLocations = [];
  List<String> previousSearches = []; // To store previous search queries

  @override
  void initState() {
    super.initState();
    _initializePreviousSearches();
    _fetchLocations();
  }

  Future<void> _initializePreviousSearches() async {
    final loadedSearches = await CustomSearchDelegate.loadPreviousSearches();
    setState(() {
      previousSearches = loadedSearches;
    });
  }

  Future<void> _fetchLocations() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Locations')
        .orderBy('Name') // Order by the 'Name' field alphabetically
        .get();

    setState(() {
      allLocations = snapshot.docs;
      filteredLocations = List.from(allLocations); // Initially show all locations in alphabetical order
    });
  }

  void _filterLocations(String query) {
    if (query.trim().isEmpty) {
      // Reset to all locations if the query is blank
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          filteredLocations = List.from(allLocations); // Create a copy to avoid modifying the original list
          filteredLocations = filteredLocations.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final visibility = data['Visibility'] ?? false;
            return visibility == true; // Only include locations with Visibility true
          }).toList();

          // Sort the filtered list alphabetically
          filteredLocations.sort((a, b) {
            final dataA = a.data() as Map<String, dynamic>;
            final dataB = b.data() as Map<String, dynamic>;
            final locationNameA = (dataA['Name'] ?? '').toLowerCase();
            final locationNameB = (dataB['Name'] ?? '').toLowerCase();
            return locationNameA.compareTo(locationNameB); // Sort alphabetically by location name
          });
        });
      });
    } else {
      // Filter locations and sort them alphabetically
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          filteredLocations = allLocations.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final locationName = (data['Name'] ?? '').toLowerCase();
            final buildingLabel = (data['BuildingLabel'] ?? '').toLowerCase();
            final visibility = data['Visibility'] ?? false;

            return (visibility == true) && // Only include locations with Visibility true
                  (locationName.contains(query.toLowerCase()) ||
                    buildingLabel.contains(query.toLowerCase()));
          }).toList();

          // Sort the filtered list alphabetically
          filteredLocations.sort((a, b) {
            final dataA = a.data() as Map<String, dynamic>;
            final dataB = b.data() as Map<String, dynamic>;
            final locationNameA = (dataA['Name'] ?? '').toLowerCase();
            final locationNameB = (dataB['Name'] ?? '').toLowerCase();
            return locationNameA.compareTo(locationNameB); // Sort alphabetically by location name
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 233, 242),
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 12.0),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 236, 233, 242), 
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: MediaQuery.of(context).size.width * 0.08,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
            title: Center(
              child: Image.asset(
                "assets/UniCampLogo.png",
                height: MediaQuery.of(context).size.height * 0.05,
              ),
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
                            _filterLocations(query);
                            if (query.isNotEmpty &&
                                !previousSearches.contains(query)) {
                              previousSearches.add(query);
                            }
                          });
                        },
                      ),
                    );

                    if (query != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _filterLocations(query);
                      });
                    }
                  },
                ),
              ),
            ],
            centerTitle: true,
          ),
        ),
      ),
      drawer: BurgerMenu.drawer(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/Main Page.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(top: 8.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Text(
                    'Locations',
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: filteredLocations.isEmpty
                      ? const Center(child: Text('No locations found.', style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                          itemCount: filteredLocations.length,
                          itemBuilder: (context, index) {
                            final location = filteredLocations[index];
                            final data = location.data() as Map<String, dynamic>;
                            return GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: LocationCard(
                                  data: data, 
                                  documentSnapshot: location, // Pass the entire document snapshot
                                ),
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
