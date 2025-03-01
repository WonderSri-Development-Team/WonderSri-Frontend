import 'package:flutter/material.dart';
import 'package:frontend/widgets/all_destination.dart';

class PopularDestinationsSection extends StatelessWidget {
  const PopularDestinationsSection({super.key});

  static final List<Map<String, dynamic>> destinations = [
    {
      'name': 'Galle Fort',
      'image': 'assets/images/GalleFort_1.jpg',
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
      'name': 'Sigiriya',
      'image': 'assets/images/sigiriya.jpg',
      'rating': 4.9,
      'description':
          'Known as the "Lion Rock," this ancient rock fortress features stunning frescoes, water gardens, and panoramic views. A UNESCO World Heritage site dating back to the 5th century, it\'s one of Sri Lanka\'s most iconic landmarks.',
    },
    {
      'name': 'Sri Dalada Maligawa',
      'image': 'assets/images/dalada_maligawa.jpg',
      'rating': 4.8,
      'description':
          'The Temple of the Sacred Tooth Relic in Kandy houses Buddha\'s sacred tooth and represents Sri Lankan Buddhist heritage. Visitors can witness daily rituals, explore beautiful architecture, and experience the spiritual center of Buddhism in Sri Lanka.',
    },
    {
      'name': 'Anuradhapura',
      'image': 'assets/images/anuradhapura.jpg',
      'rating': 4.7,
      'description':
          'Sri Lanka\'s ancient capital and sacred city features well-preserved ruins of an ancient civilization. Explore massive dagobas, ancient pools, and the sacred Sri Maha Bodhi tree, said to be the oldest historically documented tree in the world.',
    },
    {
      'name': 'Jaffna',
      'image': 'assets/images/jaffna.jpg',
      'rating': 4.6,
      'description':
          'The cultural capital of Sri Lanka\'s Tamil population offers unique cuisine, colonial architecture, and pristine beaches. Visit Jaffna Fort, Nallur Kandaswamy Temple, and experience the rich Tamil culture and history.',
    },
    {
      'name': 'Dambulla',
      'image': 'assets/images/dambulla.jpg',
      'rating': 4.7,
      'description':
          'Home to the magnificent Golden Temple and Cave Temple complex, a UNESCO World Heritage site featuring 153 Buddha statues and stunning cave paintings dating back to the 1st century BC. An extraordinary showcase of ancient Sri Lankan art and Buddhist devotion.',
    },
    {
      'name': 'Horton Plains',
      'image': 'assets/images/horton_plains.jpg',
      'rating': 4.8,
      'description':
          'A stunning high-altitude plateau featuring unique cloud forests, grasslands, and the famous World\'s End cliff with its 880m drop. Home to endemic wildlife and the Baker\'s Falls, this national park offers spectacular hiking opportunities and breathtaking vistas.',
    },
    {
      'name': 'Minneriya',
      'image': 'assets/images/minneriya.jpg',
      'rating': 4.9,
      'description':
          'Famous for "The Gathering," one of Asia\'s greatest wildlife spectacles where hundreds of elephants congregate around the ancient Minneriya Tank during the dry season. The national park also offers excellent bird watching and diverse wildlife viewing opportunities.',
    },
    {
      'name': 'Nilaveli',
      'image': 'assets/images/nilaveli.jpg',
      'rating': 4.7,
      'description':
          'A pristine white-sand beach with crystal-clear turquoise waters on Sri Lanka\'s east coast. Known for its tranquil atmosphere, excellent snorkeling at Pigeon Island, and opportunities for whale watching. One of the country\'s most beautiful and unspoiled beaches.',
    },
    {
      'name': 'Hikkaduwa Beach',
      'image': 'assets/images/hikkaduwa-beach.jpg',
      'rating': 4.6,
      'description':
          'A vibrant coastal town known for its coral sanctuary, surfing spots, and beach parties. Perfect for both relaxation and water sports enthusiasts.',
    },
    {
      'name': 'Ella',
      'image': 'assets/images/ella.jpg',
      'rating': 4.8,
      'description':
          'A picturesque mountain village known for its breathtaking views, hiking trails, and the famous Nine Arch Bridge. Surrounded by tea plantations, Ella offers cool climate and spectacular landscapes perfect for nature lovers.',
    },
    {
      'name': 'Polonnaruwa',
      'image': 'assets/images/polonnaruwa.jpg',
      'rating': 4.7,
      'description':
          'The second ancient capital of Sri Lanka features well-preserved ruins of royal palaces, impressive Buddha statues and the stunning Gal Vihara. This UNESCO World Heritage site showcases the island\'s remarkable ancient engineering and artistic achievements.',
    },
    {
      'name': 'Bentota Beach',
      'image': 'assets/images/benthota.jpg',
      'rating': 4.5,
      'description':
          'A pristine stretch of golden sand famous for water sports, luxury resorts, and the nearby Bentota River. Ideal for both adventure seekers and those looking for relaxation.',
    },
    {
      'name': 'Adam\'s Peak',
      'image': 'assets/images/adams_peak.jpg',
      'rating': 4.8,
      'description':
          'A sacred mountain pilgrimage site with a footprint-shaped mark revered by multiple religions. The challenging climb, often done at night to witness the spectacular sunrise, offers breathtaking views and spiritual significance.',
    },
    {
      'name': 'Udawalawe National Park',
      'image': 'assets/images/udawalawe.jpg',
      'rating': 4.7,
      'description':
          'Famous for its large elephant herds, this national park offers one of the best wildlife viewing experiences in Sri Lanka. The expansive grasslands and reservoir provide excellent opportunities to observe elephants, water buffalo, deer, and numerous bird species.',
    },
    {
      'name': 'Bundala National Park',
      'image': 'assets/images/bundala.jpg',
      'rating': 4.6,
      'description':
          'A coastal wetland sanctuary and UNESCO Biosphere Reserve known for its exceptional birdlife, including flamingos and migratory birds. With lagoons, dunes, and beaches, it offers diverse ecosystems and is home to crocodiles, elephants, and various reptile species.',
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
          contentPadding: EdgeInsets.zero, // Remove default padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Column(
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
                          /*child: Image.asset(
                            image,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),*/
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                      left: 1,
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
