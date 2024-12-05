// viewdetails.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/cardlocations.dart';
import '../components/burger.dart';

class ViewDetailsPage extends StatelessWidget {
  final DocumentSnapshot building;

  const ViewDetailsPage({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    final buildingData = building.data() as Map<String, dynamic>; // Get building data as a Map
    final buildingName = buildingData['Name'] ?? 'Unknown Name'; // Extract building name

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 233, 242),
      resizeToAvoidBottomInset: false, // Prevent resizing when the keyboard appears
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
              // Background image
              Positioned.fill(
                child: Image.asset(
                  "assets/Main Page.jpg",
                  fit: BoxFit.cover,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                ),
              ),
              // Optional overlay for readability
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Locations') // Fetch data from 'Locations' collection
                    .where('Building', isEqualTo: buildingName) // Compare with the building name
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
                    final locations = snapshot.data!.docs;

                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(top: 8.0, bottom: 10.0),
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
                                final data = location.data() as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: LocationCard(data: data),
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
