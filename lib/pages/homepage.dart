import 'package:flutter/material.dart';
import '../components/burger.dart'; 
import '../components/searchfield.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'polygons_data.dart'; // Import your polygons data

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // AppBar height
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 12.0),
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the logo
              children: [
                Image.asset(
                  "assets/UniCampLogo.png",
                  height: MediaQuery.of(context).size.height * 0.05, // Dynamic sizing for logo
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: BurgerMenu.drawer(context),
      body: map(),
    );
  }

  Widget map() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(7.0720248, 125.6132828), // Center of the map
        initialZoom: 18, // Zoom level
      ),
      children: [
        openStreetMapTileLayer,
        PolygonLayer(polygons: fetchPolygons()), // Add the polygon layer here
      ],
    );
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'dev.fleaflet.flutter.map.example',
  );
}
