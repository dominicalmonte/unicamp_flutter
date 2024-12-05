// lib/polygons_data.dart
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NamedPolygon extends Polygon {
  final String name;

  NamedPolygon({
    required this.name,
    required List<LatLng> points,
    Color color = const Color(0xFF000000),
    Color borderColor = const Color(0xFF000000),
    double borderStrokeWidth = 1.0,
    bool isFilled = true,
    bool isDotted = false,
    TextStyle? labelStyle,
  }) : super(
          points: points,
          color: color,
          borderColor: borderColor,
          borderStrokeWidth: borderStrokeWidth,
          isFilled: isFilled,
          labelStyle: labelStyle ?? const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
}

Future<List<DocumentSnapshot>> getBuildingLocations(String buildingName) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  print("Searching for locations in building: '$buildingName'");
  
  try {
    // Query Locations collection for documents where Building matches the input
    QuerySnapshot snapshot = await _firestore
        .collection('Locations')
        .where('Building', isEqualTo: buildingName)
        .get();
    
    print("Total locations found for $buildingName: ${snapshot.docs.length}");
    
    // Print out details of each location
    for (var doc in snapshot.docs) {
      print("Location Details:");
      print("Name: ${doc['Name']}");
      // Add more fields you want to print for debugging
    }
    
    // If no locations found, throw an exception
    if (snapshot.docs.isEmpty) {
      throw Exception("No locations found for building: $buildingName");
    }
    
    return snapshot.docs;
  } catch (e) {
    print("Error in getBuildingLocations: $e");
    throw Exception("Error searching for locations in building: $buildingName - $e");
  }
}

List<Polygon> fetchPolygons() {
  return [
    NamedPolygon(
      name: "Martin Hall",
      points: [
        const LatLng(7.0721116, 125.613434),
        const LatLng(7.0723139, 125.6137237),
        const LatLng(7.0716113, 125.6142902),
        const LatLng(7.0713265, 125.6139093),
        const LatLng(7.0718001, 125.6135172),
        const LatLng(7.0718747, 125.6136137),
      ],
      color: const Color(0xFFd00000).withOpacity(0.3),
      borderColor: const Color(0xFFd00000),
      borderStrokeWidth: 1.0,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    
    NamedPolygon(
      name: "Community Center of the First Companions",
      points: [
        
        const LatLng(7.0709633, 125.613488),
        const LatLng(7.0713191, 125.6131783),
        const LatLng(7.0713892, 125.6132257), // added bottom left node
        const LatLng(7.0715087, 125.6131277), // added top left node
        const LatLng(7.0716316, 125.6132798), // added top right node
        const LatLng(7.0715121, 125.6133779), // added bottom right node
        const LatLng(7.0715179, 125.6134103),
        const LatLng(7.0711621, 125.6137199),
      ],
      color: const Color(0xffffba08).withOpacity(0.3),
      borderColor: const Color(0xffffba08),
      // label: 'Community Center of the First Companions',
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      borderStrokeWidth: 1.0,
      
    ),
    NamedPolygon(
      name: "Jubilee Hall",
      points: [
        const LatLng(7.0720092, 125.6134449),
        const LatLng(7.0718828, 125.6132925),
        const LatLng(7.0718467, 125.6133112),
        const LatLng(7.0718077, 125.6133245),
        const LatLng(7.0717579, 125.6133188),
        const LatLng(7.0714794, 125.6135533),
        const LatLng(7.0715641, 125.6136496),
        const LatLng(7.071796, 125.6134448),
        const LatLng(7.0718817, 125.6135474),
      ],
      color: const Color(0xFFcbff8c).withOpacity(0.3),
      borderColor: const Color(0xFFcbff8c),
      // label: 'Jubilee Hall',
      labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      borderStrokeWidth: 1.0,
      
    ),
    NamedPolygon(
      name: "Bellarmine Hall",
      points: [
        const LatLng(7.0724586, 125.6131057),
        const LatLng(7.0723335, 125.6131044),
        const LatLng(7.0723282, 125.6133176),
        const LatLng(7.0724546, 125.6133217),
      ],
      color: const Color(0xFF8fe388).withOpacity(0.3),
      borderColor: const Color(0xFF8fe388),
      // label: 'Bellarmine Hall',
      labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      borderStrokeWidth: 1.0,
      
    ),
    NamedPolygon(
      name: "Dotterweich Hall",
      points: [
        const LatLng(7.072884312882649, 125.61280703041838),
        const LatLng(7.0727536, 125.6131545),
        const LatLng(7.0728987, 125.6132089),
        const LatLng(7.073021195846438,125.61285745591512), 
      ],
      color: const Color(0xFF1b998b).withOpacity(0.3),
      borderColor: const Color(0xFF1b998b),
      // label: 'Dotterweich Hall',
      labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      borderStrokeWidth: 1.0,
      
    ),
    NamedPolygon(
      name: "Wieman Hall",
      points: [
        const LatLng(7.0726077, 125.6125993),
        const LatLng(7.0726877, 125.6125976),
        const LatLng(7.0726736, 125.6130193),
        const LatLng(7.0727234, 125.6130199),
        const LatLng(7.0727218, 125.6133415),
        const LatLng(7.0725624, 125.6133366),
        const LatLng(7.0725694, 125.6130197),
        const LatLng(7.0725779, 125.6126448),
        const LatLng(7.0725758, 125.6125643),
        const LatLng(7.0726075, 125.6125638),
      ],
      color: const Color(0xFF3185fc).withOpacity(0.3),
      borderColor: const Color(0xFF3185fc),
      // label: 'Wieman Hall',
      labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      borderStrokeWidth: 1.0,
      
    ),
    NamedPolygon(
      name: "Canisius Hall",
      points: [
        const LatLng(7.072177, 125.6126703),
        const LatLng(7.0722839, 125.6126694),
        const LatLng(7.0722873, 125.612805),
        const LatLng(7.0722874, 125.6131439),
        const LatLng(7.0723109, 125.6131439),
        const LatLng(7.0723109, 125.6132004),
        const LatLng(7.0722561, 125.6131998),
        const LatLng(7.0721764, 125.6131978),
        const LatLng(7.0721761, 125.6131439),
        const LatLng(7.0721398, 125.6131435),
        const LatLng(7.0721396, 125.6130959),
        const LatLng(7.0721744, 125.6130952),
        const LatLng(7.072177, 125.612885),
      ],
      color:  const Color(0xFF5d2e8c).withOpacity(0.3),
      borderColor:  const Color(0xFF5d2e8c),
      // label: 'Canasius Hall',
      labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      borderStrokeWidth: 1.0,
      
    ),
    NamedPolygon(
      name: "Thibault Hall",
      points: [
        const LatLng(7.0726605, 125.612555),
        const LatLng(7.0726605, 125.612597),
        const LatLng(7.0726089, 125.612598),
        const LatLng(7.0726082, 125.6125629),
        const LatLng(7.0725752, 125.6125633),
        const LatLng(7.0725747, 125.6126461),
        const LatLng(7.07232, 125.6126483),
        const LatLng(7.0723189, 125.6125555),
        const LatLng(7.0725589, 125.6125561),
      ],
      color: const Color(0xFFfad643).withOpacity(0.3),
      borderColor: const Color(0xFFfad643),
      // label: 'Thibault Hall',
      labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      borderStrokeWidth: 1.0,
      
    ),
    NamedPolygon(
      name: "Del Rosario Hall",
      points: [
        const LatLng(7.0728011, 125.6124499),
        const LatLng(7.0729112, 125.6124857),
        const LatLng(7.0730261, 125.6126022),
        const LatLng(7.0730066, 125.6126232),
        const LatLng(7.0730766, 125.6126933), // added top right node
        const LatLng(7.073021195846438,125.61285745591512), // added bottom right node
        const LatLng(7.072884312882649, 125.61280703041838), // added bottom left node
        const LatLng(7.0729168, 125.6126612),
        const LatLng(7.0729105, 125.6126546),
        const LatLng(7.0726879, 125.6126497),
        const LatLng(7.0726917, 125.6125772), 
        const LatLng(7.0727487, 125.612556),
      ],
      color: const Color(0xFFe85d04).withOpacity(0.3),
      borderColor: const Color(0xFFe85d04),
      // label: 'Del Rosario Hall',
      labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      borderStrokeWidth: 1.0,
      
    ),
    /* NamedPolygon(
      name: "Chapel of Our Lady of the Assumption",
      points: [
        const LatLng(7.0716316, 125.6132798),
        const LatLng(7.0715087, 125.6131277), 
        const LatLng(7.0713892, 125.6132257),
        const LatLng(7.0715121, 125.6133779),
        const LatLng(7.0716316, 125.6132798),
      ],
      color: const Color(0xFF2ECC71).withOpacity(0.3),
      borderColor: const Color(0xFF2ECC71),
      // label: 'Chapel of Our Lady of the Assumption',
      labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      borderStrokeWidth: 1.0,
    ), */
    NamedPolygon(
      name: "Finster Hall",
      points: [
        const LatLng(7.072177, 125.6126703),
        const LatLng(7.072116, 125.6126357),
        const LatLng(7.0721689, 125.6127012),
        const LatLng(7.0719564, 125.6128755),
        const LatLng(7.0719402, 125.612901),
        const LatLng(7.0719156, 125.6129255),
        const LatLng(7.0718924, 125.6129401),
        const LatLng(7.0718618, 125.6129487),
        const LatLng(7.0717327, 125.6130583),
        const LatLng(7.0717709, 125.613104),
        const LatLng(7.0716763, 125.6131843),
        const LatLng(7.0716038, 125.6130976),
        const LatLng(7.0716083, 125.612916),
        const LatLng(7.0716905, 125.6128573),
        const LatLng(7.0716867, 125.6128525),
        // const LatLng(7.0717709, 125.6127784),
        const LatLng(7.0717412, 125.6128161),
        const LatLng(7.0717351, 125.6128084),
        const LatLng(7.0718436, 125.6127201),
        const LatLng(7.0718492, 125.612727),
        const LatLng(7.0718958, 125.6126889),
        const LatLng(7.0718890, 125.6126810),
        const LatLng(7.0720388, 125.6125594),
        const LatLng(7.0720484, 125.6125712),
        const LatLng(7.072102, 125.6125271),
        const LatLng(7.0720705, 125.6124773),
        const LatLng(7.0722335, 125.6123177),
        const LatLng(7.0722638, 125.6123573),
        const LatLng(7.0722876, 125.6123403),
        const LatLng(7.072281, 125.6122824),
        const LatLng(7.0723204, 125.6122463),
        const LatLng(7.072357, 125.6122497),
        const LatLng(7.0723684, 125.6122185),
        const LatLng(7.0724546, 125.6122304),
        const LatLng(7.0724583, 125.6122306),
        const LatLng(7.0724649, 125.6122166),
        const LatLng(7.0725345, 125.6122462),
        const LatLng(7.0725594, 125.6122382),
        const LatLng(7.0726247, 125.6122861),
        const LatLng(7.0726243, 125.6123222),
        const LatLng(7.0727272, 125.612351),
        const LatLng(7.0727078, 125.6124164),
        const LatLng(7.0727968, 125.6124452),
        const LatLng(7.0727406, 125.6125549),
        const LatLng(7.0726884, 125.6125757),
        // const LatLng(7.0726622, 125.6125965),
        const LatLng(7.0726623, 125.6125536),
        const LatLng(7.072314, 125.612553),
        const LatLng(7.0723146, 125.6126692),
        const LatLng(7.0722839, 125.6126694),
      ],
      color: const Color(0xFFff9b85).withOpacity(0.3),
      borderColor: const Color(0xFFff9b85),
      // label: 'Finster',
      labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      borderStrokeWidth: 1.0,
      
    ),
  ];
}
  