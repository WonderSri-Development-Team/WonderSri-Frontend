import 'package:flutter/material.dart';
import 'package:frontend/widgets/all_destination.dart';

class PopularDestinationsSection extends StatelessWidget {
  const PopularDestinationsSection({super.key});

  static final List<Map<String, dynamic>> destinations = [
    {
      'name': 'Galle Fort',
      'image': 'assets/images/Galle_Fort.jpg',
      'rating': 4.8,
      'description':
          'A UNESCO World Heritage site, Galle Fort is a historic Dutch colonial fortress featuring charming streets, boutique shops, and centuries of rich history along Sri Lanka\'s southern coast.',
    },
    {
      'name': 'Mirissa Beach',
      'image': 'assets/images/mirissa.jpg',
      'rating': 4.7,
      'description':
          'Famous for whale watching and stunning sunsets, Mirissa Beach offers golden sands, palm trees, and excellent surfing conditions in a paradise-like setting.',
    },
    {
      'name': 'Hikkaduwa Beach',
      'image': 'assets/images/hikkaduwa-beach.jpg',
      'rating': 4.6,
      'description':
          'A vibrant coastal town known for its coral sanctuary, surfing spots, and beach parties. Perfect for both relaxation and water sports enthusiasts.',
    },
    {
      'name': 'Bentota Beach',
      'image': 'assets/images/benthota.jpg',
      'rating': 4.5,
      'description':
          'A pristine stretch of golden sand famous for water sports, luxury resorts, and the nearby Bentota River. Ideal for both adventure seekers and those looking for relaxation.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Destinations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllDestinationsScreen(),
                    ),
                  );
                },
                child: const Text('See all'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];
              return DestinationCard(
                name: destination['name'],
                image: destination['image'],
                rating: destination['rating'],
                description: destination['description'],
              );
            },
          ),
        ),
      ],
    );
  }
}

class DestinationCard extends StatelessWidget {
  final String name;
  final String image;
  final double rating;
  final String description;

  const DestinationCard({
    super.key,
    required this.name,
    required this.image,
    required this.rating,
    required this.description,
  });

  void _showDestinationDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  // Image and content
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Image.asset(
                          image,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                Text(' $rating'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              description,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Back button
                  Positioned(
                    top: 8,
                    left: 2,
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDestinationDetails(context),
      child: Container(
        margin: const EdgeInsets.only(right: 30),
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(
                    ' $rating',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
