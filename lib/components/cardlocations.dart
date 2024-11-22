import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LocationCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const LocationCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Get the PhotoURL array (check for multiple images)
    final photoURLs = data['PhotoURL'] is List ? List<String>.from(data['PhotoURL']) : [];

    // Get email string
    final email = data['Email'] ?? 'Unknown Email';

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
              if (photoURLs.isNotEmpty)
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
              else
                const SizedBox.shrink(), // Fallback if no photos

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
              // Email (instead of Location)
              Text(
                email, // Displaying the email string
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
