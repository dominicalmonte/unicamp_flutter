import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/cardbuildings.dart';
import '../components/burger.dart';
import '../components/searchfield.dart';

class BuildingsPage extends StatelessWidget {
  const BuildingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const Padding(
                padding: EdgeInsets.only(right: 16.0, left: 4.0),
                child: SearchField(),
              ),
            ],
          ),
        ),
      ),
      drawer: BurgerMenu.drawer(context),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Buildings').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No buildings found.'),
            );
          } else {
            final buildings = snapshot.data!.docs;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(top: 8.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Buildings',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    // Pass building data to BuildingCard
                    ...buildings.map((building) {
                      final data = building.data() as Map<String, dynamic>;
                      return BuildingCard(data: data);
                    }).toList(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
