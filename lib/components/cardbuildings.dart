import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BuildingList extends StatefulWidget {
  const BuildingList({super.key});

  @override
  _BuildingListState createState() => _BuildingListState();
}

class _BuildingListState extends State<BuildingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buildings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Buildings').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No buildings found.'));
          }

          final buildings = snapshot.data!.docs;

          // Prefetch images
          for (var doc in buildings) {
            final data = doc.data() as Map<String, dynamic>;
            if (data['PhotoURL'] is List) {
              final photoURLs = List<String>.from(data['PhotoURL']);
              for (var url in photoURLs) {
                // Prefetch images with CachedNetworkImage
                precacheImage(CachedNetworkImageProvider(url), context);
              }
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: buildings.length,
            itemBuilder: (context, index) {
              final buildingData =
                  buildings[index].data() as Map<String, dynamic>;
              return BuildingCard(data: buildingData);
            },
          );
        },
      ),
    );
  }
}

class BuildingCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const BuildingCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final photoURLs =
        data['PhotoURL'] is List ? List<String>.from(data['PhotoURL']) : [];
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
              if (photoURLs.length > 1)
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
                        return GestureDetector(
                          onTap: () {
                            _showImageDialog(context, url);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: url,
                              height: 200.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth:
                                      2.0, // Adjust the stroke width for a thinner indicator
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              else if (photoURLs.length == 1)
                GestureDetector(
                  onTap: () {
                    _showImageDialog(context, photoURLs.first);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: photoURLs.first,
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          strokeWidth:
                              2.0, // Adjust the stroke width for a thinner indicator
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              const SizedBox(height: 16.0),
              Text(
                data['Name'] ?? 'Unknown Name',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
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

  // Function to show the full-screen image dialog
  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    strokeWidth:
                        2.0, // Adjust the stroke width for a thinner indicator
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        );
      },
    );
  }
}
