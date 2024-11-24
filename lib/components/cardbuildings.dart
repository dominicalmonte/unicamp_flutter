import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const BuildingCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Get the PhotoURL array (check for multiple images)
    final photoURLs = data['PhotoURL'] is List ? List<String>.from(data['PhotoURL']) : [];

    // Get location data (assuming Location is a GeoPoint)
    final locationGeoPoint = data['Location'] as GeoPoint?;
    final location = locationGeoPoint != null
        ? '${locationGeoPoint.latitude}, ${locationGeoPoint.longitude}'
        : 'Unknown Location';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4.0,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel for PhotoURLs
              if (photoURLs.length > 1) // More than one image, use CarouselSlider
                CarouselSlider(
                  options: CarouselOptions(
                    height: 170.0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                  ),
                  items: photoURLs.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            url,
                            height: 200.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              else if (photoURLs.length == 1) // Only one image, display it directly
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    photoURLs.first,
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              else // No images available, fallback
                const SizedBox.shrink(),
              const SizedBox(height: 16.0),
              // Name
              Text(
                data['Name'] ?? 'Unknown Name',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              // Location
              Text(
                location, // Displaying the location string
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
              // Description
              Text(
                data['Description'] ?? 'No Description Provided',
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
