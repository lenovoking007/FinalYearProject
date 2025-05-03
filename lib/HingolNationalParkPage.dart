import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Hingolnationalparkpage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/Islamabad/islamabad1.jpg',
    'assets/images/Islamabad/islamabad2.jpg',
    'assets/images/Islamabad/islamabad3.jpg',
  ];

  final List<String> clothesImages = [
    'assets/images/Islamabad/cl1.jpg',
    'assets/images/Islamabad/cl2.jpg',
    'assets/images/Islamabad/cl3.jpg',
    'assets/images/Islamabad/cl4.jpg',
  ];

  final List<String> foodImages = [
    'assets/images/Islamabad/food1.jpg',
    'assets/images/Islamabad/food2.jpeg',
    'assets/images/Islamabad/food3.jpg',
    'assets/images/Islamabad/food4.jpg',
  ];

  final List<String> festivalImages = [
    'assets/images/Islamabad/f1.jpg',
    'assets/images/Islamabad/f2.jpg',
    'assets/images/Islamabad/f3.jpg',
    'assets/images/Islamabad/f4.jpg',
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _saveTripPlanToFirebase(Map<String, dynamic> tripPlan) async {
    try {
      await _firestore.collection('tripPlans').add(tripPlan);
    } catch (e) {
      throw Exception('Failed to save trip plan: $e');
    }
  }

  void showTripPlanDialog(BuildContext context) {
    TextEditingController tripNameController = TextEditingController();
    TextEditingController peopleCountController = TextEditingController();
    TextEditingController budgetController = TextEditingController();
    String? selectedTripType;
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 3));

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flight_takeoff, color: Color(0XFF0066CC), size: 28),
                          const SizedBox(width: 12),
                          Text(
                            "Plan Your Trip",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0XFF0066CC).withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildEditableTextField("Trip Name", tripNameController, Icons.title),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0XFF88F2E8).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0XFF0066CC).withOpacity(0.5)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: selectedTripType,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          hint: const Text('Select Trip Type', style: TextStyle(color: Colors.grey)),
                          items: ['Adventure', 'Relaxation', 'Cultural', 'Wildlife', 'Business'].map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type, style: const TextStyle(color: Colors.black87)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTripType = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildEditableTextField("Number of People", peopleCountController, Icons.people),
                      const SizedBox(height: 16),
                      _buildEditableTextField("Budget (PKR)", budgetController, Icons.account_balance_wallet),
                      const SizedBox(height: 16),
                      Text(
                        "Trip Duration",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0XFF0066CC).withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isSmallScreen = constraints.maxWidth < 400;
                          return isSmallScreen
                              ? Column(
                            children: [
                              _buildDateSelector(context, "Start Date", startDate, (picked) {
                                if (picked != null) {
                                  setState(() {
                                    startDate = picked;
                                    if (startDate.isAfter(endDate)) {
                                      endDate = startDate.add(const Duration(days: 1));
                                    }
                                  });
                                }
                              }, startDate),
                              const SizedBox(height: 12),
                              _buildDateSelector(context, "End Date", endDate, (picked) {
                                if (picked != null) {
                                  setState(() {
                                    endDate = picked;
                                  });
                                }
                              }, startDate),
                            ],
                          )
                              : Row(
                            children: [
                              Expanded(
                                child: _buildDateSelector(context, "Start Date", startDate, (picked) {
                                  if (picked != null) {
                                    setState(() {
                                      startDate = picked;
                                      if (startDate.isAfter(endDate)) {
                                        endDate = startDate.add(const Duration(days: 1));
                                      }
                                    });
                                  }
                                }, startDate),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildDateSelector(context, "End Date", endDate, (picked) {
                                  if (picked != null) {
                                    setState(() {
                                      endDate = picked;
                                    });
                                  }
                                }, startDate),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.amber.shade700),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "Trip duration: ${endDate.difference(startDate).inDays + 1} days",
                                style: TextStyle(color: Colors.amber.shade800),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0XFF0066CC),
                            ),
                            child: const Text("CANCEL"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () async {
                              if (tripNameController.text.isEmpty || selectedTripType == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill all required fields'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              try {
                                final User? user = _auth.currentUser;
                                if (user == null) throw Exception('User not authenticated');

                                final Map<String, dynamic> tripPlan = {
                                  'userId': user.uid,
                                  'tripName': tripNameController.text,
                                  'tripType': selectedTripType,
                                  'numberOfPeople': peopleCountController.text,
                                  'budget': budgetController.text,
                                  'startDate': Timestamp.fromDate(startDate),
                                  'endDate': Timestamp.fromDate(endDate),
                                  'destination': 'Islamabad',
                                  'createdAt': Timestamp.now(),
                                };

                                await _saveTripPlanToFirebase(tripPlan);
                                Navigator.pop(context);
                                _showSuccessDialog(
                                  context,
                                  tripNameController.text,
                                  selectedTripType ?? 'Not specified',
                                  endDate.difference(startDate).inDays + 1,
                                );
                              } catch (e) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error saving trip: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0XFF0066CC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text(
                              "SAVE TRIP",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDateSelector(
      BuildContext context,
      String label,
      DateTime date,
      Function(DateTime?) onDateSelected,
      DateTime minDate,
      ) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: label == "Start Date" ? DateTime.now() : minDate,
          lastDate: DateTime(DateTime.now().year + 1),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0XFF0066CC),
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child!,
            );
          },
        );
        onDateSelected(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0XFF88F2E8).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0XFF0066CC).withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Color(0XFF0066CC)),
                const SizedBox(width: 8),
                Text(
                  "${date.day}/${date.month}/${date.year}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String tripName, String tripType, int duration) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE8F5E9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Trip Saved!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0XFF0066CC).withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildSuccessDetailRow("Trip Name:", tripName),
                    const Divider(height: 16, thickness: 0.5),
                    _buildSuccessDetailRow("Destination:", "Islamabad"),
                    const Divider(height: 16, thickness: 0.5),
                    _buildSuccessDetailRow("Trip Type:", tripType),
                    const Divider(height: 16, thickness: 0.5),
                    _buildSuccessDetailRow("Duration:", "$duration days"),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "You can view your trip in the 'My Trips' section",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF0066CC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "DONE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableTextField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0XFF88F2E8).withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0XFF0066CC).withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0XFF0066CC)),
        ),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        suffixIcon: Icon(icon, color: const Color(0XFF0066CC).withOpacity(0.7)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0XFF0066CC),
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search in Gawadar...',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.search, color: Colors.white, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(top: 12),
                      isDense: true,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/images/pro.jpg'),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              color: const Color(0XFF0066CC),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                tabs: const [
                  Tab(icon: Icon(Icons.home), text: 'Overview'),
                  Tab(icon: Icon(Icons.shopping_bag), text: 'Clothes'),
                  Tab(icon: Icon(Icons.restaurant), text: 'Food'),
                  Tab(icon: Icon(Icons.celebration), text: 'Festival'),
                  Tab(icon: Icon(Icons.reviews), text: 'Reviews'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildOverviewTab(context),
                  _buildTabContent(
                    tabName: 'Clothes',
                    images: clothesImages,
                    sectionTitle: 'Traditional Crafts',
                    sectionDescription: 'Gwadar is known for its rich coastal culture, with local crafts including handwoven textiles and unique jewelry made from shells and beads. Explore the markets for authentic handicrafts.',
                    activityTitle: 'Top Shopping Spots',
                    activityDescription: '• Gwadar Bazaar: Traditional handicrafts\n'
                        '• Coastal Market: Shell jewelry & handmade accessories\n'
                        '• Pasni Market: Fresh seafood & local products',
                  ),
                  _buildTabContent(
                    tabName: 'Food',
                    images: foodImages,
                    sectionTitle: 'Gwadar Cuisine',
                    sectionDescription: 'Experience the coastal flavors of Gwadar, with fresh seafood and dishes influenced by the region’s diverse cultures.',
                    activityTitle: 'Must-Try Specialties',
                    activityDescription: '• Grilled Fish at the Beach\n'
                        '• Balochi Sajji (Whole Roasted Lamb)\n'
                        '• Makran Prawns\n'
                        '• Traditional Balochi Barbecue',
                  ),
                  _buildTabContent(
                    tabName: 'Festival',
                    images: festivalImages,
                    sectionTitle: 'Cultural Celebrations',
                    sectionDescription: 'Gwadar hosts vibrant cultural festivals reflecting its rich maritime heritage and coastal traditions.',
                    activityTitle: 'Key Festivals',
                    activityDescription: '• Gwadar Beach Festival\n'
                        '• Balochi Cultural Day\n'
                        '• Annual Makran Fishing Festival\n'
                        '• Coastal Heritage Celebrations',
                  ),

                  _buildReviewFeedbackTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(overviewImages),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Discover Gawadar",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF0066CC).withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Gawadar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0XFF0066CC).withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Gwadar, Pakistan's coastal hub, is known for its stunning beaches, "
                        "well-planned infrastructure, and strategic port. Nestled along the Arabian Sea, "
                        "it offers a perfect blend of natural beauty and urban development."
                    ,
                    style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Top Attractions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF0066CC).withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildAttractionsGrid(),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.flight, color: Colors.white, size: 20),
              label: const Text(
                'Plan Your Trip Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color(0XFF0066CC),
                elevation: 2,
                shadowColor: const Color(0XFF0066CC).withOpacity(0.3),
              ),
              onPressed: () => showTripPlanDialog(context),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAttractionsGrid() {
    final List<Map<String, dynamic>> attractions = [
      {
        'name': 'Gwadar Port',
        'image': 'assets/images/Gwadar/gwadar1.jpg',
        'rating': 4.8,
        'reviews': 1234,
      },
      {
        'name': 'Sunset View Park',
        'image': 'assets/images/Gwadar/gwadar2.jpg',
        'rating': 4.7,
        'reviews': 1023,
      },
      {
        'name': 'Gwadar Fort',
        'image': 'assets/images/Gwadar/gwadar3.jpg',
        'rating': 4.6,
        'reviews': 876,
      },
      {
        'name': 'Astola Island',
        'image': 'assets/images/Gwadar/gwadar4.jpg',
        'rating': 4.9,
        'reviews': 1456,
      },

    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: attractions.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    Image.asset(
                      attractions[index]['image'],
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              attractions[index]['rating'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attractions[index]['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber.shade700, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          attractions[index]['rating'].toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${attractions[index]['reviews']})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 20,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFF0066CC).withOpacity(0.1),
                          foregroundColor: const Color(0XFF0066CC),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'View',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabContent({
    required String tabName,
    required List<String> images,
    required String sectionTitle,
    required String sectionDescription,
    required String activityTitle,
    required String activityDescription,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(images),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              sectionTitle,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF0066CC).withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              sectionDescription,
              style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              activityTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF0066CC).withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                activityDescription,
                style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildReviewFeedbackTab() {
    int selectedRating = 0;
    final reviewController = TextEditingController();

    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'User Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0XFF0066CC).withOpacity(0.9),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildReviewCard(
                name: 'Ahmed Ali',
                rating: 5,
                review: 'Gwadar Port is a marvel of modern infrastructure! The views from Sunset View Park are breathtaking.',
                imageUrl: 'assets/images/Gwadar/u1.png',
                date: '3 days ago',
              ),
              const SizedBox(height: 16),
              _buildReviewCard(
                name: 'Fatima Qureshi',
                rating: 4,
                review: 'Astola Island is a hidden gem. Ideal for nature lovers and those who enjoy peaceful isolation.',
                imageUrl: 'assets/images/Gwadar/u2.png',
                date: '1 week ago',
              ),
              const SizedBox(height: 16),
              _buildReviewCard(
                name: 'Bilal Shah',
                rating: 5,
                review: 'The Gwadar Fort offers amazing views and a deep dive into the city’s rich history. A must-visit!',
                imageUrl: 'assets/images/Gwadar/u3.png',
                date: '2 weeks ago',
              ),
              const SizedBox(height: 16),
              _buildReviewCard(
                name: 'Sara Khan',
                rating: 4,
                review: 'Sunset View Park is the perfect spot for a relaxing evening. The sea breeze and the sunset are unforgettable.',
                imageUrl: 'assets/images/Gwadar/u4.png',
                date: '3 weeks ago',
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Add Your Review',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0XFF0066CC).withOpacity(0.9),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Rating',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () => setState(() => selectedRating = index + 1),
                            child: Icon(
                              index < selectedRating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 32,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Your Review',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: reviewController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          hintText: 'Share your experience in Islamabad...',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFF0066CC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            elevation: 2,
                          ),
                          onPressed: () {
                            if (selectedRating == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a rating'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            // Submit review logic here
                          },
                          child: const Text(
                            'SUBMIT REVIEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewCard({
    required String name,
    required int rating,
    required String review,
    required String imageUrl,
    required String date,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(imageUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.thumb_up, color: Colors.grey.shade600, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                Text(
                  'Helpful',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.comment, color: Colors.grey.shade600, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                Text(
                  'Comment',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(List<String> images) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 4),
      ),
      items: images.map((imagePath) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          ),
        );
      }).toList(),
    );
  }
}