import 'package:flutter/material.dart';
import '../components/burger.dart'; 
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'polygons_data.dart'; // Import your polygons data
import '../pages/viewdetails.dart'; // Import the viewdetails.dart page
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Add this method to handle polygon tapping
  // In HomePage class
void handlePolygonTap(BuildContext context, String buildingName) async {
  try {
    // First, fetch the building document from Firestore
    QuerySnapshot buildingQuery = await FirebaseFirestore.instance
        .collection('Buildings')
        .where('Name', isEqualTo: buildingName)
        .limit(1)
        .get();

    if (buildingQuery.docs.isNotEmpty) {
      // Navigate to ViewDetailsPage with the first matching building document
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewDetailsPage(
            building: buildingQuery.docs.first
          ),
        ),
      );
    } else {
      // Handle case where no building is found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No building found: $buildingName')),
      );
    }
  } catch (e) {
    // Handle any potential errors
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

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
      body: map(context),
    );
  }

  Widget map(BuildContext context) { // Add BuildContext parameter
    return FlutterMap(
      options: MapOptions(
        onTap: (tapPosition, latlng) {
          // Loop through polygons to check if the tapped location is inside one
          for (final polygon in fetchPolygons()) {
            if (_isPointInPolygon(latlng, polygon.points)) {
              if (polygon is NamedPolygon) {
                // Use the method within the class
                handlePolygonTap(context, polygon.name);
              }
              break; // Stop once a polygon is tapped
            }
          }
        },
        initialCenter: LatLng(7.0720248, 125.6132828), 
        initialZoom: 18, 
      ),
      children: [
        openStreetMapTileLayer,
        PolygonLayer(polygons: fetchPolygons()
        ), 
        const MarkerLayer(
          markers: [
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(7.071847, 125.613745), // Martin Hall
              child: Icon(
                Icons.location_on,
                color: Color(0xFFd00000), 
                size: 40.0,
              ),
            ),
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(7.0724562, 125.6132407), // Bellarmine Hall
              child: Icon(
                Icons.location_on,
                color: Color(0xFF8fe388), 
                size: 40.0,
              ),
            ),
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(7.0717332, 125.6134590), // Jubilee Hall
              child: Icon(
                Icons.location_on,
                color: Color(0xFFcbff8c), 
                size: 40.0,
              ),
            ),
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(7.0713186, 125.6133842), // Community Center of the First Companions
              child: Icon(
                Icons.location_on,
                color: Color(0xffffba08), 
                size: 40.0,
              ),
            ),
            /*
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(7.0715399, 125.6131965), // Chapel of Our Lady of the Assumption
              child: Icon(
                Icons.location_on,
                color: Color(0xFF2ECC71), 
                size: 40.0,
              ),
            ),
             */
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(7.0721727, 125.6126399), // Finster Hall
              child: Icon(
                Icons.location_on,
                color: Color(0xFFff9b85), 
                size: 40.0,
              ),
            ),
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(7.0723061, 125.6129356), // Canisius Hall
              child: Icon(
                Icons.location_on,
                color: Color(0xFF5d2e8c), 
                size: 40.0,
              ),
            ),
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(7.0725048, 125.6126061), // Thibault Hall
              child: Icon(
                Icons.location_on,
                color: Color(0xFFfad643), 
                size: 40.0,
              ),
            ),
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(7.0727320, 125.6130785), // Wieman Hall
              child: Icon(
                Icons.location_on,
                color: Color(0xFF3185fc), 
                size: 40.0,
              ),
            ),
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(7.0729413, 125.6129910), // Dotterweich Hall
              child: Icon(
                Icons.location_on,
                color: Color(0xFF1b998b), 
                size: 40.0,
              ),
            ),
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(7.0729739, 125.6125725), // Del Rosario Hall
              child: Icon(
                Icons.location_on,
                color: Color(0xFFe85d04), 
                size: 40.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'dev.fleaflet.flutter.map.example',
  );
}

bool _isPointInPolygon(LatLng point, List<LatLng> polygonPoints) {
  int intersections = 0;
  int n = polygonPoints.length;

  for (int i = 0; i < n; i++) {
    LatLng p1 = polygonPoints[i];
    LatLng p2 = polygonPoints[(i + 1) % n]; // Next point, wrapping around
    if (point.latitude > p1.latitude && point.latitude <= p2.latitude || point.latitude > p2.latitude && point.latitude <= p1.latitude) {
      double slope = (p2.longitude - p1.longitude) / (p2.latitude - p1.latitude);
      double intersectX = p1.longitude + slope * (point.latitude - p1.latitude);
      if (intersectX > point.longitude) {
        intersections++;
      }
    }
  }

  return (intersections % 2 != 0); // If odd, point is inside the polygon
}
