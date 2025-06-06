import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmate/tripprogresspage.dart';

class Hunzapage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/hunza/hunzao1.jpg',
    'assets/images/hunza/hunzao2.jpg',
    'assets/images/hunza/hunzao3.jpg',
    'assets/images/hunza/hunzao4.jpg',
  ];
  final List<String> clothesImages = [
    'assets/images/hunza/hunzacl1.jpg',
    'assets/images/Lahore/cl2.jpg',
    'assets/images/Lahore/cl3.jpg',
    'assets/images/Lahore/cl4.jpg',
  ];
  final List<String> foodImages = [
    'assets/images/Lahore/food1.jpg',
    'assets/images/Lahore/food2.jpeg',
    'assets/images/Lahore/food3.jpg',
    'assets/images/Lahore/food4.jpg',
  ];
  final List<String> festivalImages = [
    'assets/images/hunza/hunzaf1.jpg',
    'assets/images/hunza/hunzaf2.jpg',
    'assets/images/hunza/hunzaf3.jpg',
    'assets/images/hunza/hunzaf4.jpg',

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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flight_takeoff, color: Color(0xFF0066CC), size: 28),
                          const SizedBox(width: 12),
                          Text(
                            "Plan Your Trip",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0066CC).withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildEditableTextField("Trip Name", tripNameController, Icons.title),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF88F2E8).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF0066CC).withOpacity(0.5)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: selectedTripType,
                          decoration: const InputDecoration(border: InputBorder.none),
                          hint: const Text('Select Trip Type', style: TextStyle(color: Colors.grey)),
                          items: ['Adventure', 'Relaxation', 'Cultural', 'Wildlife', 'Business']
                              .map((String type) {
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
                          color: const Color(0xFF0066CC).withOpacity(0.9),
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
                            style: TextButton.styleFrom(foregroundColor: const Color(0xFF0066CC)),
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
                                  'destination': 'Lahore',
                                  'status': 'planned',
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
                              backgroundColor: const Color(0xFF0066CC),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  primary: Color(0xFF0066CC),
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
          color: const Color(0xFF88F2E8).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0066CC).withOpacity(0.5)),
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
                const Icon(Icons.calendar_today, size: 16, color: Color(0xFF0066CC)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                  color: const Color(0xFF0066CC).withOpacity(0.9),
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
                    _buildSuccessDetailRow("Destination:", "Lahore"),
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
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066CC),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "DONE",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
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
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
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
        fillColor: const Color(0xFF88F2E8).withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF0066CC).withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0066CC)),
        ),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        suffixIcon: Icon(icon, color: const Color(0xFF0066CC).withOpacity(0.7)),
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
          backgroundColor: const Color(0xFF0066CC),
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
                      hintText: 'Search in Hunza...',
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
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TripStatusPage()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8), // Smaller corner radius
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 3,
                            offset: Offset(0, 1.5),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.timeline,
                        color: Color(0xFF0066CC),
                        size: 20, // Smaller icon
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              color: const Color(0xFF0066CC),
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
                  _buildShoppingTab(),
                  _buildFoodTab(),
                  _buildFestivalTab(),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Discover Hunza",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0066CC).withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'About hunza',
            description:
            'Hyderabad, the historical city by the Godavari River, is a blend of rich culture, heritage, and modern growth.'

            ,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Attractions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0066CC).withOpacity(0.9),
                  ),
                ),
              ],
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
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: const Color(0xFF0066CC),
                elevation: 2,
                shadowColor: const Color(0xFF0066CC).withOpacity(0.3),
              ),
              onPressed: () => showTripPlanDialog(context),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  Widget _buildShoppingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(clothesImages),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Discover Clothes",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0066CC).withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'Traditional Attire',
            description:
            'Hunza offers a unique shopping experience, where you can find traditional handicrafts, locally made goods, and natural products. From intricate handwoven shawls to apricot-based products, the valley provides a variety of items reflecting its rich culture and natural beauty.'

          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Top Shopping Spots',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0066CC).withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildShoppingGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  Widget _buildFoodTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(foodImages),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Discover Food",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0066CC).withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
              title: 'HunzaCuisine',
              description:
              'Hunza is a food lover\'s haven, known for its fresh and organic produce, traditional Hunza dishes, and locally grown fruits, including apricots, which are a staple in the region.'


          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Famous Food Locations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0066CC).withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildFoodGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  Widget _buildFestivalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(festivalImages),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Discover Festivals",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0066CC).withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
              title: 'Cultural Festivals',
              description:
              'Hunza hosts a variety of vibrant cultural festivals, local handicraft exhibitions, music performances,'
                  ' and traditional celebrations that showcase the rich heritage and traditions of the region.'
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Popular Festival Locations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0066CC).withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildFestivalGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  Widget _buildReviewFeedbackTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('reviews').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final reviews = snapshot.data?.docs ?? [];
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
                    color: const Color(0xFF0066CC).withOpacity(0.9),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...reviews.map((reviewDoc) {
                final reviewData = reviewDoc.data() as Map<String, dynamic>;
                return _buildReviewCard(
                  name: reviewData['name'] ?? 'Anonymous',
                  rating: reviewData['rating'] ?? 0,
                  review: reviewData['review'] ?? 'No review text available',
                  imageUrl: 'assets/images/Lahore/u1.png',
                  date: reviewData['timestamp'] != null
                      ? '${DateTime.now().difference(reviewData['timestamp'].toDate()).inDays} days ago'
                      : 'Unknown date',
                );
              }).toList(),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
  Widget _buildInfoCard({
    required String title,
    required String description,
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
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0066CC).withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildAttractionsGrid() {
    final List<Map<String, dynamic>> attractions = [
      {
        'name': 'Altit Fort',
        'address': 'Altit, Hunza Valley',
        'image': 'assets/images/hunza/hunzao1.jpg',
      },
      {
        'name': 'Baltit Fort',
        'address': 'Karimabad, Hunza Valley',
        'image': 'assets/images/hunza/hunzao2.jpg',
      },
      {
        'name': 'Passu Cones',
        'address': 'Passu, Hunza Valley',
        'image': 'assets/images/hunza/hunzao3.jpg',
      },
      {
        'name': 'Eagle’s Nest',
        'address': 'Hunza Valley',
        'image': 'assets/images/hunza/hunzao4.jpg',
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
                child: Image.asset(
                  attractions[index]['image'],
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attractions[index]['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      attractions[index]['address'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
  Widget _buildShoppingGrid() {
    final List<Map<String, dynamic>> shoppingSpots = [
      {
        'name': 'Karimabad Market',
        'details': 'Traditional market offering handicrafts, souvenirs, and local products.',
        'image': 'assets/images/hunza/hunzacl1.jpg',
      },
      {
        'name': 'Aliabad Bazaar',
        'details': 'Known for fresh fruits, local goods, and handicrafts.',
        'image': 'assets/images/hunza/hunzacl2.jpg',
      },
      {
        'name': 'Hunza Viewpoint Souvenir Shop',
        'details': 'Famous for handmade shawls, jewelry, and local artifacts.',
        'image': 'assets/images/hunza/hunzacl3.jpg',
      },
      {
        'name': 'Baltit Fort Souvenir Shop',
        'details': 'Specializes in traditional Hunza crafts, art, and souvenirs.',
        'image': 'assets/images/hunza/hunzacl4.jpg',
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
      itemCount: shoppingSpots.length,
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
                child: Image.asset(
                  shoppingSpots[index]['image'],
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shoppingSpots[index]['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      shoppingSpots[index]['details'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
  Widget _buildFoodGrid() {
    final List<Map<String, dynamic>> foodLocations = [
      {
        'name': 'Karimabad Restaurant',
        'details': 'Famous for Hunza-style dishes and traditional local food.',
        'image': 'assets/images/hunza/hunzafood1.jpg',
      },
      {
        'name': 'Hunza Viewpoint Restaurant',
        'details': 'Known for local delicacies and panoramic views of the valley.',
        'image': 'assets/images/hunza/hunzafood2.jpg',
      },
      {
        'name': 'Baltit Fort Cafe',
        'details': 'Specializes in local snacks and beverages with views of the historic fort.',
        'image': 'assets/images/hunza/hunzafood3.jpg',
      },
      {
        'name': 'Aliabad Food Corner',
        'details': 'Offers traditional Hunza dishes like Chapshuro and local breads.',
        'image': 'assets/images/hunza/hunzafood4.jpg',
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
      itemCount: foodLocations.length,
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
                child: Image.asset(
                  foodLocations[index]['image'],
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodLocations[index]['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      foodLocations[index]['details'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
  Widget _buildFestivalGrid() {
    final List<Map<String, dynamic>> festivalLocations = [
      {
        'name': 'Hunza Festival',
        'details': 'Celebration of Hunza culture with music, dance, and traditional arts.',
        'image': 'assets/images/hunza/hunzaf1.jpg',
      },
      {
        'name': 'Shandur Polo Festival',
        'details': 'Famous polo tournament held at the Shandur Pass with local festivities.',
        'image': 'assets/images/hunza/hunzaf2.jpg',
      },
      {
        'name': 'Gilgit-Baltistan Literary Festival',
        'details': 'Event highlighting local literature, poetry, and traditional arts.',
        'image': 'assets/images/hunza/hunzaf3.jpg',
      },
      {
        'name': 'Hunza Mela',
        'details': 'Annual fair with handicrafts, local foods, and cultural performances.',
        'image': 'assets/images/hunza/hunzaf4.jpg',
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
      itemCount: festivalLocations.length,
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
                child: Image.asset(
                  festivalLocations[index]['image'],
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      festivalLocations[index]['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      festivalLocations[index]['details'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
              style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
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