import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final DocumentSnapshot? documentSnapshot;

  const LocationCard({super.key, required this.data, this.documentSnapshot});

  @override
  _LocationCardState createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.data['Favorite'] ?? false;
  }

  Future<void> _toggleFavorite() async {
    try {
      if (widget.documentSnapshot != null) {
        await widget.documentSnapshot!.reference
            .update({'Favorite': !_isFavorite});
      }

      setState(() {
        _isFavorite = !_isFavorite;
      });
    } catch (e) {
      print('Error toggling favorite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite status')),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  // Get the PhotoURL array (check for multiple images)
  final photoURLs = widget.data['PhotoURL'] is List
      ? List<String>.from(widget.data['PhotoURL'])
      : [];

  final email = widget.data['Email'] ?? 'Unknown Email';
  final building = widget.data['Building'] ?? 'No Building';

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
                      return GestureDetector(
                        onTap: () {
                          _showImageDialog(context, url);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            url,
                            height: 200.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              )
            else if (photoURLs.isNotEmpty) // Only one image, display it directly
              GestureDetector(
                onTap: () {
                  _showImageDialog(context, photoURLs.first);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    photoURLs.first,
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              const SizedBox.shrink(),

            const SizedBox(height: 16.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.data['Name'] ?? 'Unknown Name',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color:
                        _isFavorite ? const Color(0xFFFF0054) : Colors.grey,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ],
            ),

            const SizedBox(height: 8.0),

            // Building Information
            Text(
              building,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 4.0),

            // Email Information (Smaller Text)
            Text(
              email,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8.0),

            Text(
              widget.data['Description'] ?? 'No Description Provided',
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
        insetPadding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    },
  );
}

}
