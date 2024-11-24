// lib/pages/homepage.dart
import 'package:flutter/material.dart';
import '../components/burger.dart'; 
import '../components/searchfield.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), 
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0), 
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
                
              ),
            ],
          ),
        ),
      ),
      drawer: BurgerMenu.drawer(context), 
      body: map(),
    );
  }

  Widget map(){
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(7.0720248,125.6132828),
        initialZoom: 18,
      ),
      children: [
        openStreetMapTileLayer,
      ],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter.map.example',
);
  
