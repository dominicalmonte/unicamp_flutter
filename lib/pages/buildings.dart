import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/cardbuildings.dart';
import '../components/burger.dart';
import 'view_details.dart';
import '../components/search_delegate.dart';

class BuildingsPage extends StatefulWidget {
  const BuildingsPage({super.key});

  @override
  State<BuildingsPage> createState() => _BuildingsPageState();
}

class _BuildingsPageState extends State<BuildingsPage> {
  List<QueryDocumentSnapshot> allBuildings = [];
  List<QueryDocumentSnapshot> filteredBuildings = [];
  List<String> previousSearches = [];

  @override
  void initState() {
    super.initState();
    _initializePreviousSearches();
    _fetchBuildings();
  }

  Future<void> _initializePreviousSearches() async {
    final loadedSearches = await CustomSearchDelegate.loadPreviousSearches();
    setState(() {
      previousSearches = loadedSearches;
    });
  }

  Future<void> _fetchBuildings() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Buildings')
        .orderBy('Name')
        .get();

    setState(() {
      allBuildings = snapshot.docs;
      filteredBuildings = List.from(allBuildings);
    });
  }

  void _filterBuildings(String query) {
    if (query.trim().isEmpty) {
      // Reset to all buildings if the query is blank
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          filteredBuildings = List.from(
              allBuildings); // Create a copy to avoid modifying the original list
          filteredBuildings.sort((a, b) {
            final dataA = a.data() as Map<String, dynamic>;
            final dataB = b.data() as Map<String, dynamic>;
            final buildingNameA = (dataA['Name'] ?? '').toLowerCase();
            final buildingNameB = (dataB['Name'] ?? '').toLowerCase();
            return buildingNameA.compareTo(buildingNameB);
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
            final locationLabel = (data['LocationLabel'] ?? '').toLowerCase();

            return buildingName.contains(query.toLowerCase()) ||
                locationLabel.contains(query.toLowerCase());
          }).toList();

          // Sort the filtered list alphabetically
          filteredBuildings.sort((a, b) {
            final dataA = a.data() as Map<String, dynamic>;
            final dataB = b.data() as Map<String, dynamic>;
            final buildingNameA = (dataA['Name'] ?? '').toLowerCase();
            final buildingNameB = (dataB['Name'] ?? '').toLowerCase();
            return buildingNameA.compareTo(
                buildingNameB); // Sort alphabetically by building name
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 236, 233, 242), 
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
                            _filterBuildings(query);
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
                        _filterBuildings(query);
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0)
                .copyWith(top: 8.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Expanded(
                  child: filteredBuildings.isEmpty
                      ? const Center(
                          child: Text('No buildings found.',
                              style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                          itemCount: filteredBuildings.length,
                          itemBuilder: (context, index) {
                            final building = filteredBuildings[index];
                            final data =
                                building.data() as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewDetailsPage(building: building),
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
