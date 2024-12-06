import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/cardlocations.dart';
import '../components/burger.dart';
import 'extensive_details.dart'; // Import the new page

class ViewDetailsPage extends StatelessWidget {
  final DocumentSnapshot building;

  const ViewDetailsPage({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    final buildingData = building.data() as Map<String, dynamic>;
    final buildingName = buildingData['Name'] ?? 'Unknown Name';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 233, 242),
      resizeToAvoidBottomInset: false,
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
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
            title: Image.asset(
              "assets/UniCampLogo.png",
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            centerTitle: true,
          ),
        ),
      ),
      drawer: BurgerMenu.drawer(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/Main Page.jpg",
                  fit: BoxFit.cover,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Locations')
                    .where('Building', isEqualTo: buildingName)
                    .where('Visibility', isEqualTo: true) // Add visibility filter
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No locations found for this building.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    // Sort locations manually
                    final locations = snapshot.data!.docs.toList()
                      ..sort((a, b) {
                        final dataA = a.data() as Map<String, dynamic>;
                        final dataB = b.data() as Map<String, dynamic>;

                        // First, compare by Favorite
                        final favoriteA = dataA['Favorite'] == true;
                        final favoriteB = dataB['Favorite'] == true;
                        if (favoriteA != favoriteB) {
                          return favoriteB ? 1 : -1;
                        }

                        // Then, compare by Name
                        final nameA = (dataA['Name'] ?? '').toLowerCase();
                        final nameB = (dataB['Name'] ?? '').toLowerCase();
                        return nameA.compareTo(nameB);
                      });

                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0)
                              .copyWith(top: 8.0, bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$buildingName Locations',
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              // Pass location data to LocationCard
                              ...locations.map((location) {
                                final data =
                                    location.data() as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigate to ExtensiveDetails with the tapped location data
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ExtensiveDetails(
                                            locationData: data,
                                            documentSnapshot: location,
                                          ),
                                        ),
                                      );
                                    },
                                    child: LocationCard(
                                      data: data,
                                      documentSnapshot: location,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
