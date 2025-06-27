import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmate/tripprogresspage.dart';
import 'package:travelmate/city_planner.dart';

class MultanPage extends StatefulWidget {
  const MultanPage({super.key});

  @override
  State<MultanPage> createState() => _MultanPageState();
}

class _MultanPageState extends State<MultanPage> {
  final List<String> overviewImages = [
    'assets/images/multan/multano1.jpg',
    'assets/images/multan/multano2.jpg',
    'assets/images/multan/multano3.jpg',
  ];
  final List<String> clothesImages = [
    'assets/images/Lahore/cl1.jpg',
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
    'assets/images/multan/multanfes3.jpg',
    'assets/images/multan/multano1.jpg',
    'assets/images/multan/multano3.jpg'
  ];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveTripPlanToFirebase(Map<String, dynamic> tripPlan) async {
    try {
      await _firestore.collection('tripPlans').add(tripPlan);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save trip plan: ${e.toString()}';
      });
      throw Exception('Failed to save trip plan: $e');
    }
  }

  void showTripPlanDialog(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController tripNameController = TextEditingController();
    TextEditingController peopleCountController = TextEditingController();
    TextEditingController budgetController = TextEditingController();
    String? selectedTripType;
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 3));

    String? validateTripName(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a trip name';
      }
      if (value.length > 20) {
        return 'Trip name must be 20 characters or less';
      }
      return null;
    }

    String? validatePeopleCount(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter number of people';
      }
      final num = int.tryParse(value);
      if (num == null) {
        return 'Please enter a valid number';
      }
      if (num < 1) {
        return 'Must be at least 1 person';
      }
      if (num > 99) {
        return 'Cannot exceed 99 people';
      }
      return null;
    }

    String? validateBudget(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a budget';
      }
      final num = int.tryParse(value.replaceAll(',', ''));
      if (num == null) {
        return 'Please enter a valid number';
      }
      if (num < 5000) {
        return 'Minimum trip budget is 5000 PKR.';
      }
      if (num > 9999999) {
        return 'Budget cannot exceed 99,99,999';
      }
      return null;
    }

    String? validateTripDuration(DateTime start, DateTime end) {
      final duration = end.difference(start).inDays;
      if (duration < 1) {
        return 'End date must be after start date';
      }
      if (duration > 16) {
        return 'Trip cannot exceed 15 days';
      }
      return null;
    }

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
                  child: Form(
                    key: _formKey,
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
                        Text(
                          "Trip Name",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0066CC).withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildEditableTextField(
                          label: "Enter trip name",
                          controller: tripNameController,
                          icon: Icons.title,
                          validator: validateTripName,
                          maxLength: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "${tripNameController.text.length}/20",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Trip Type",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0066CC).withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
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
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            hint: const Text('Select trip type', style: TextStyle(color: Colors.grey)),
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
                            validator: (value) => value == null ? 'Please select a trip type' : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Number of People",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0066CC).withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildEditableTextField(
                          label: "Enter number of people (1-99)",
                          controller: peopleCountController,
                          icon: Icons.people,
                          validator: validatePeopleCount,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Budget (PKR)",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0066CC).withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildEditableTextField(
                          label: "Enter budget amount",
                          controller: budgetController,
                          icon: Icons.account_balance_wallet,
                          validator: validateBudget,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Trip Duration*",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0066CC).withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
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
                        if (validateTripDuration(startDate, endDate) != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              validateTripDuration(startDate, endDate)!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
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
                                foregroundColor: const Color(0xFF0066CC),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: const Text(
                                "CANCEL",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                final durationError = validateTripDuration(startDate, endDate);
                                if (durationError != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(durationError),
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
                                    'numberOfPeople': int.parse(peopleCountController.text),
                                    'budget': int.parse(budgetController.text.replaceAll(',', '')),
                                    'startDate': Timestamp.fromDate(startDate),
                                    'endDate': Timestamp.fromDate(endDate),
                                    'destination': 'Multan',
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEditableTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
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
        counterText: '',
        errorStyle: const TextStyle(fontSize: 12),
      ),
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
                    _buildSuccessDetailRow("Destination:", "Multan"),
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

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0066CC),
          title: const Text('Multan', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

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
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search in Multan...',
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
                      borderRadius: BorderRadius.circular(8),
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
                              offset: const Offset(0, 1.5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.timeline,
                          color: const Color(0xFF0066CC),
                          size: 20,
                        ),
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
        body:Column(
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
    final List<Map<String, dynamic>> attractions = [
      {
        "name": "Multan Fort",
        "address": "Multan",
        "image": 'assets/images/multan/multano1.jpg',
      },
      {
        "name": "Shrine of Bahauddin Zakariya",
        "address": "Multan",
        "image": 'assets/images/multan/multano2.jpg',
      },
      {
        "name": "Multan Clock Tower",
        "address": "Multan",
        "image": 'assets/images/multan/multano3.jpg',
      },
      {
        "name": "Sadr Bazar",
        "address": "Multan",
        "image": 'assets/images/multan/multan04.jpg',
      }
    ];
    final filteredAttractions = _searchQuery.isEmpty
        ? attractions
        : attractions.where((attraction) =>
    attraction['name'].toLowerCase().contains(_searchQuery) ||
        attraction['address'].toLowerCase().contains(_searchQuery)).toList();

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
                  "Discover Multan",
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
            title: 'About Multan',
            description:
            'Multan, known as the "City of Saints," is one of the oldest cities in South Asia with a rich cultural '
                'and spiritual heritage. Famous for its Sufi shrines, blue pottery, and handicrafts, Multan offers '
                'a unique blend of history, spirituality, and traditional crafts.',
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
          if (filteredAttractions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'No attractions found matching your search',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            _buildAttractionsGrid(filteredAttractions),
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
    final List<Map<String, dynamic>> shoppingSpots = [
      {
        "name": "Multan Bazaar",
        "details": "A bustling market offering traditional crafts, textiles, and pottery.",
        "image": "assets/images/multan/multancl1.jpg"
      },
      {
        "name": "Hussain Agahi Bazaar",
        "details": "Famous for its local handicrafts, embroidered fabrics, and spices.",
        "image":"assets/images/multan/multancl2.jpg"
      },
      {
        "name": "Chenab Market",
        "details": "A popular shopping destination for home goods, clothes, and accessories.",
        "image": "assets/images/multan/multancl3.jpg"
      },
      {
        "name": "Shah Rukn-e-Alam Market",
        "details": "Known for its traditional Multani crafts, handwoven shawls, and local art.",
        "image": "assets/images/multan/multancl4.jpg"
      }

    ];

    final filteredShoppingSpots = _searchQuery.isEmpty
        ? shoppingSpots
        : shoppingSpots.where((spot) =>
    spot['name'].toLowerCase().contains(_searchQuery) ||
        spot['details'].toLowerCase().contains(_searchQuery)).toList();

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
            'Multan is famous for its traditional clothing including Multani shawls, '
                'embroidered fabrics, and colorful dresses. The city is particularly known '
                'for its Khussa (traditional footwear) and handwoven textiles with intricate designs.',
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
          if (filteredShoppingSpots.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'No shopping spots found matching your search',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            _buildShoppingGrid(filteredShoppingSpots),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFoodTab() {
    final List<Map<String, dynamic>> foodLocations = [
      {
        "name": "Monal Restaurant",
        "details": "Famous for its breathtaking views and diverse menu.",
        "image": "assets/images/multan/multanfood1.jpg"
      },
      {
        "name": "Savour Foods",
        "details": "Popular for their signature pulao and kababs.",
        "image": "assets/images/multan/multanfood2.jpg"
      },
      {
        "name": "Street 1 Cafe",
        "details": "Trendy spot for continental and fusion dishes.",
        "image":  "assets/images/multan/multanfood3.jpg"
      },
      {
        "name": "Chaaye Khana",
        "details": "Ideal place for breakfast and desi tea lovers.",
        "image":  "assets/images/multan/multanfood4.jpg"
      }
    ];

    final filteredFoodLocations = _searchQuery.isEmpty
        ? foodLocations
        : foodLocations.where((location) =>
    location['name'].toLowerCase().contains(_searchQuery) ||
        location['details'].toLowerCase().contains(_searchQuery)).toList();

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
            title: 'Multani Cuisine',
            description:
            'Multan offers a rich culinary tradition with specialties like Sohan Halwa (a famous sweet), '
                'Multani Pulao, Saag, and Makai ki Roti. The city is also known for its delicious street food '
                'including tikkas, kebabs, and traditional lassi.',
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
          if (filteredFoodLocations.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'No food locations found matching your search',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            _buildFoodGrid(filteredFoodLocations),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFestivalTab() {
    final List<Map<String, dynamic>> festivalLocations = [
      {
        "name": "Multan Fort",
        "details": "A historical fort offering panoramic views of the city and a glimpse into the region's rich heritage.",
        "image":  "assets/images/multan/multano1.jpg"
      },
      {
        "name": "Shrine of Bahauddin Zakariya",
        "details": "A sacred site for spiritual visits and local cultural events, reflecting the region's religious history.",
        "image": "assets/images/multan/multano2.jpg"
      },
      {
        "name": "Multan Museum",
        "details": "Showcases the city's ancient artifacts and rich cultural history.",
        "image": "assets/images/multan/multan04.jpg"
      },
      {
        "name": "Clock Tower",
        "details": "An iconic landmark offering insight into Multan's colonial past and cultural significance.",
        "image": "assets/images/multan/multanfes3.jpg"
      }

    ];

    final filteredFestivalLocations = _searchQuery.isEmpty
        ? festivalLocations
        : festivalLocations.where((location) =>
    location['name'].toLowerCase().contains(_searchQuery) ||
        location['details'].toLowerCase().contains(_searchQuery)).toList();

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
              "Multan is renowned for its spiritual and cultural festivals. The Urs celebrations "
                  "at various shrines attract thousands of devotees. The city also hosts cultural "
                  "festivals showcasing traditional crafts, music, and dance of the region."
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
          if (filteredFestivalLocations.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'No festival locations found matching your search',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            _buildFestivalGrid(filteredFestivalLocations),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildReviewFeedbackTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('reviews')
          .where('destination', isEqualTo: 'Multan')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
              ));
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 50),
                const SizedBox(height: 16),
                Text(
                  'Failed to load reviews',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xFF0066CC).withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066CC),
                  ),
                  child: const Text('Retry', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }

        final List<QueryDocumentSnapshot> reviewDocs = snapshot.data?.docs ?? [];
        final List<Map<String, dynamic>> firestoreReviews = reviewDocs.map((doc) {
          final data = doc.data() as Map<String, dynamic>? ?? {};
          return {
            'name': data['name'] as String? ?? 'Anonymous',
            'rating': (data['rating'] as int?) ?? 0,
            'review': data['review'] as String? ?? '',
            'imageUrl': 'assets/images/Multan/u${(doc.hashCode % 3) + 1}.png',
            'date': data['timestamp'] != null
                ? _formatReviewDate(data['timestamp'].toDate())
                : 'Recently',
          };
        }).toList();

        final List<Map<String, dynamic>> localReviews = [
          {
            'name': 'History Buff',
            'rating': 5,
            'review': 'Multan is a treasure trove of history and spirituality. The shrines and fort are magnificent!',
            'imageUrl': 'assets/images/Multan/u1.png',
            'date': '3 months ago'
          },
          {
            'name': 'Culture Explorer',
            'rating': 4,
            'review': 'The blue pottery and handicrafts are amazing. The city has such rich cultural heritage!',
            'imageUrl': 'assets/images/Multan/u2.png',
            'date': '2 months ago'
          }
        ];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Local Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0066CC).withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),
              ...localReviews.map((review) => _buildReviewCard(
                name: review['name'],
                rating: review['rating'],
                review: review['review'],
                imageUrl: review['imageUrl'],
                date: review['date'],
              )).toList(),

              const SizedBox(height: 24),
              Text(
                'User Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0066CC).withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),

              if (firestoreReviews.isEmpty)
                _buildNoReviewsPlaceholder()
              else
                ...firestoreReviews.map((review) => _buildReviewCard(
                  name: review['name'],
                  rating: review['rating'],
                  review: review['review'],
                  imageUrl: review['imageUrl'],
                  date: review['date'],
                )).toList(),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  String _formatReviewDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildNoReviewsPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(Icons.reviews, size: 50, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'No user reviews yet',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share your experience!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
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

  Widget _buildAttractionsGrid(List<Map<String, dynamic>> attractions) {
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      attractions[index]['image'],
                      height: constraints.maxWidth * 0.6,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
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
                          Expanded(
                            child: Text(
                              attractions[index]['address'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildShoppingGrid(List<Map<String, dynamic>> shoppingSpots) {
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      shoppingSpots[index]['image'],
                      height: constraints.maxWidth * 0.6,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shoppingSpots[index]['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: Text(
                              shoppingSpots[index]['details'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFoodGrid(List<Map<String, dynamic>> foodLocations) {
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      foodLocations[index]['image'],
                      height: constraints.maxWidth * 0.6,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foodLocations[index]['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: Text(
                              foodLocations[index]['details'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFestivalGrid(List<Map<String, dynamic>> festivalLocations) {
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      festivalLocations[index]['image'],
                      height: constraints.maxWidth * 0.6,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            festivalLocations[index]['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: Text(
                              festivalLocations[index]['details'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
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
                          },
                          )],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
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