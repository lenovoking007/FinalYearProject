import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;


// Define app colors
const Color primaryColor = Color(0xFF0066CC);
const Color secondaryColor = Colors.white;
const Color textColor = Colors.black87;
const Color lightBlue = Color(0xFF88F2E8);

class TripStatusPage extends StatefulWidget {
  const TripStatusPage({Key? key}) : super(key: key);

  @override
  _TripStatusPageState createState() => _TripStatusPageState();
}

class _TripStatusPageState extends State<TripStatusPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _trips = [];
  Map<String, bool> _hasUserReviewed = {};
  bool _isIndexError = false;
  String? _indexCreateUrl;
  Map<String, String> _userNames = {};

  @override
  void initState() {
    super.initState();
    _fetchAllTrips();
    _checkUserReviews();
    _fetchUserNames();
  }

  Future<void> _fetchUserNames() async {
    try {
      final usersSnapshot = await _firestore.collection('users').get();
      final Map<String, String> names = {};
      for (var doc in usersSnapshot.docs) {
        final data = doc.data();
        names[doc.id] = data['name'] as String;
      }
      setState(() {
        _userNames = names;
      });
    } catch (e) {
      print('Error fetching user names: $e');
    }
  }

  Future<void> _fetchAllTrips() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isIndexError = false;
      _indexCreateUrl = null;
    });

    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final QuerySnapshot querySnapshot = await _firestore
          .collection('tripPlans')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _isLoading = false;
          _trips = [];
        });
        return;
      }

      final List<Map<String, dynamic>> trips = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        trips.add({
          ...data,
          'id': doc.id,
        });
      }

      setState(() {
        _isLoading = false;
        _trips = trips;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        if (e.toString().contains('firebase') && e.toString().contains('index')) {
          _isIndexError = true;
          final urlRegExp = RegExp(r'https:\/\/console\.firebase\.google\.com[^\s]+');
          final match = urlRegExp.firstMatch(e.toString());
          if (match != null) {
            _indexCreateUrl = match.group(0);
          }
          _errorMessage = 'This query requires a Firestore index. Please create it to continue.';
        } else {
          _errorMessage = 'Failed to load trips: ${e.toString()}';
        }
      });
    }
  }

  Future<void> _fetchTripsWithoutSorting() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final QuerySnapshot querySnapshot = await _firestore
          .collection('tripPlans')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _isLoading = false;
          _trips = [];
        });
        return;
      }

      final List<Map<String, dynamic>> trips = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        trips.add({
          ...data,
          'id': doc.id,
        });
      }

      trips.sort((a, b) {
        final Timestamp aTime = a['createdAt'] as Timestamp? ?? Timestamp.now();
        final Timestamp bTime = b['createdAt'] as Timestamp? ?? Timestamp.now();
        return bTime.compareTo(aTime);
      });

      setState(() {
        _isLoading = false;
        _trips = trips;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load trips: ${e.toString()}';
      });
    }
  }

  Future<void> _checkUserReviews() async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final QuerySnapshot reviewsSnapshot = await _firestore
          .collection('reviews')
          .where('uid', isEqualTo: userId)
          .get();

      final Map<String, bool> reviewedTrips = {};
      for (var doc in reviewsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['tripId'] != null) {
          reviewedTrips[data['tripId'] as String] = true;
        }
      }

      setState(() {
        _hasUserReviewed = reviewedTrips;
      });
    } catch (e) {
      print('Error checking reviews: $e');
    }
  }

  Future<void> _deleteTrip(String tripId) async {
    try {
      await _firestore.collection('tripPlans').doc(tripId).delete();

      setState(() {
        _trips.removeWhere((trip) => trip['id'] == tripId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Trip deleted successfully'),
          backgroundColor: primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting trip: ${e.toString()}'),
          backgroundColor: primaryColor,
        ),
      );
    }
  }

  Future<void> _updateTripStatus(String tripId, String newStatus) async {
    try {
      await _firestore
          .collection('tripPlans')
          .doc(tripId)
          .update({'status': newStatus});

      setState(() {
        final tripIndex = _trips.indexWhere((trip) => trip['id'] == tripId);
        if (tripIndex != -1) {
          _trips[tripIndex]['status'] = newStatus;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Trip marked as $newStatus!'),
          backgroundColor: primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: primaryColor,
        ),
      );
    }
  }

  Future<void> _launchFirebaseConsole() async {
    if (_indexCreateUrl != null) {
      final Uri url = Uri.parse(_indexCreateUrl!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open Firebase Console'),
            backgroundColor: primaryColor,
          ),
        );
      }
    }
  }

  void _showReviewDialog(BuildContext context, String tripId) {
    int selectedRating = 0;
    final reviewController = TextEditingController();
    final currentUser = _auth.currentUser;
    final userName = _userNames[currentUser?.uid ?? ''] ?? currentUser?.displayName ?? 'Anonymous User';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Add Review',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: reviewController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Your Review',
                          labelStyle: const TextStyle(color: textColor),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedRating = index + 1;
                                });
                              },
                              icon: Icon(
                                Icons.star,
                                size: 36,
                                color: index < selectedRating ? primaryColor : Colors.grey[300],
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel', style: TextStyle(color: primaryColor)),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () async {
                              if (selectedRating == 0 || reviewController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Please provide a rating and review.'),
                                    backgroundColor: primaryColor,
                                  ),
                                );
                                return;
                              }
                              try {
                                final user = _auth.currentUser;

                                await _firestore.collection('reviews').add({
                                  'uid': user?.uid,
                                  'tripId': tripId,
                                  'name': userName,
                                  'rating': selectedRating,
                                  'review': reviewController.text,
                                  'timestamp': Timestamp.now(),
                                });

                                setState(() {
                                  _hasUserReviewed[tripId] = true;
                                });

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Review submitted successfully!'),
                                    backgroundColor: primaryColor,
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to submit review: $e'),
                                    backgroundColor: primaryColor,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              minimumSize: const Size(100, 40),
                            ),
                            child: const Text('Send', style: TextStyle(color: secondaryColor)),
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

  void _navigateToTripProgressDetails(Map<String, dynamic> tripData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripProgressDetailsPage(tripData: tripData),
      ),
    ).then((_) => _fetchAllTrips());
  }

  void _showEditTripDialog(BuildContext context, Map<String, dynamic> tripData) {
    TextEditingController tripNameController = TextEditingController(text: tripData['tripName'] as String);
    TextEditingController peopleCountController = TextEditingController(text: tripData['numberOfPeople'] as String);
    TextEditingController budgetController = TextEditingController(text: tripData['budget'] as String);
    String? selectedTripType = tripData['tripType'] as String?;
    DateTime startDate = (tripData['startDate'] as Timestamp).toDate();
    DateTime endDate = (tripData['endDate'] as Timestamp).toDate();

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
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit, color: primaryColor, size: 28),
                            const SizedBox(width: 12),
                            Text(
                              "Edit Your Trip",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: tripNameController,
                        maxLength: 20,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: lightBlue.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          labelText: "Trip Name",
                          labelStyle: const TextStyle(color: textColor),
                          suffixIcon: Icon(Icons.title, color: primaryColor.withOpacity(0.7)),
                          counterText: '',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: lightBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: primaryColor.withOpacity(0.5)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: selectedTripType,
                          decoration: const InputDecoration(border: InputBorder.none),
                          hint: const Text('Select Trip Type', style: TextStyle(color: textColor)),
                          items: ['Adventure', 'Relaxation', 'Cultural', 'Wildlife', 'Business']
                              .map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type, style: const TextStyle(color: textColor)),
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
                      TextFormField(
                        controller: peopleCountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: lightBlue.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          labelText: "Number of People",
                          labelStyle: const TextStyle(color: textColor),
                          suffixIcon: Icon(Icons.people, color: primaryColor.withOpacity(0.7)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter number of people';
                          }
                          final num = int.tryParse(value);
                          if (num == null || num <= 0 || num > 200) {
                            return 'Enter number between 1-200';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: budgetController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: lightBlue.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          labelText: "Budget (PKR)",
                          labelStyle: const TextStyle(color: textColor),
                          suffixIcon: Icon(Icons.account_balance_wallet, color: primaryColor.withOpacity(0.7)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter budget';
                          }
                          final num = int.tryParse(value);
                          if (num == null || num <= 0 || num > 100000000) {
                            return 'Enter amount up to 100 million PKR';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          "Trip Duration",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
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
                          color: lightBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: primaryColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: primaryColor),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "Trip duration: ${endDate.difference(startDate).inDays + 1} days",
                                style: TextStyle(color: primaryColor),
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
                            style: TextButton.styleFrom(foregroundColor: primaryColor),
                            child: const Text("CANCEL"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () async {
                              // Validate inputs
                              final peopleValid = int.tryParse(peopleCountController.text) != null &&
                                  int.parse(peopleCountController.text) > 0 &&
                                  int.parse(peopleCountController.text) <= 200;

                              final budgetValid = int.tryParse(budgetController.text) != null &&
                                  int.parse(budgetController.text) > 0 &&
                                  int.parse(budgetController.text) <= 100000000;

                              if (tripNameController.text.isEmpty ||
                                  selectedTripType == null ||
                                  !peopleValid ||
                                  !budgetValid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Please fill all fields with valid values'),
                                    backgroundColor: primaryColor,
                                  ),
                                );
                                return;
                              }

                              try {
                                final Map<String, dynamic> updatedTrip = {
                                  'tripName': tripNameController.text,
                                  'tripType': selectedTripType,
                                  'numberOfPeople': peopleCountController.text,
                                  'budget': budgetController.text,
                                  'startDate': Timestamp.fromDate(startDate),
                                  'endDate': Timestamp.fromDate(endDate),
                                };

                                await _firestore
                                    .collection('tripPlans')
                                    .doc(tripData['id'])
                                    .update(updatedTrip);

                                setState(() {
                                  final index = _trips.indexWhere((t) => t['id'] == tripData['id']);
                                  if (index != -1) {
                                    _trips[index] = {
                                      ..._trips[index],
                                      ...updatedTrip,
                                    };
                                  }
                                });

                                Navigator.pop(context);
                                _fetchAllTrips();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Trip updated successfully!'),
                                    backgroundColor: primaryColor,
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error updating trip: ${e.toString()}'),
                                    backgroundColor: primaryColor,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text(
                              "SAVE CHANGES",
                              style: TextStyle(color: secondaryColor),
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
                colorScheme: ColorScheme.light(
                  primary: primaryColor,
                  onPrimary: secondaryColor,
                  surface: secondaryColor,
                  onSurface: textColor,
                ),
                dialogBackgroundColor: secondaryColor,
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
          color: lightBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: textColor),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  "${date.day}/${date.month}/${date.year}",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: textColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips', style: TextStyle(color: secondaryColor)),
        backgroundColor: primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primaryColor)))
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: primaryColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            if (_isIndexError && _indexCreateUrl != null) ...[
              Text(
                'This is a one-time setup for your app:',
                style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _launchFirebaseConsole,
                icon: Icon(Icons.open_in_new, color: secondaryColor),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                label: const Text('Create Firestore Index', style: TextStyle(color: secondaryColor)),
              ),
              const SizedBox(height: 8),
              Text(
                'After creating the index, wait a few minutes for it to build.',
                style: TextStyle(fontStyle: FontStyle.italic, color: primaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _fetchTripsWithoutSorting,
                child: Text('Load Unsorted Trips', style: TextStyle(color: primaryColor)),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchAllTrips,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              child: const Text('Retry', style: TextStyle(color: secondaryColor)),
            )
          ],
        ),
      )
          : _buildTripsContent(),
    );
  }

  Widget _buildTripsContent() {
    if (_trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No trips planned yet!',
              style: TextStyle(fontSize: 18, color: primaryColor),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Plan a Trip',
                style: TextStyle(color: secondaryColor),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: _trips.length,
        itemBuilder: (context, index) {
          final trip = _trips[index];
          final tripId = trip['id'] as String;
          final status = trip['status'] as String? ?? 'planned';
          final tripName = trip['tripName'] as String? ?? 'My Trip';
          final persons = trip['numberOfPeople'] as String? ?? '1';
          final budget = trip['budget'] as String? ?? '0';
          final startDate = (trip['startDate'] as Timestamp).toDate();
          final endDate = (trip['endDate'] as Timestamp).toDate();
          final formattedStartDate = DateFormat('MMM d, yyyy').format(startDate);
          final formattedEndDate = DateFormat('MMM d, yyyy').format(endDate);
          final hasReviewed = _hasUserReviewed[tripId] ?? false;

          final bool isCompleted = status == 'completed';
          final bool isInProgress = status == 'in_progress' ||
              (status == 'planned' &&
                  DateTime.now().isAfter(startDate) &&
                  DateTime.now().isBefore(endDate));

          // Define status colors
          final Color statusColor = isCompleted
              ? Colors.green
              : isInProgress
              ? Colors.orange
              : primaryColor;
          final Color statusBgColor = isCompleted
              ? Colors.green.withOpacity(0.1)
              : isInProgress
              ? Colors.orange.withOpacity(0.1)
              : primaryColor.withOpacity(0.1);

          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => _navigateToTripProgressDetails(trip),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            tripName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: primaryColor),
                          onSelected: (value) async {
                            if (value == 'edit') {
                              _showEditTripDialog(context, trip);
                            } else if (value == 'delete') {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Trip', style: TextStyle(color: primaryColor)),
                                  content: const Text('Are you sure you want to delete this trip?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text('Cancel', style: TextStyle(color: primaryColor)),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await _deleteTrip(tripId);
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: primaryColor),
                                  SizedBox(width: 8),
                                  Text('Edit Trip')
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: primaryColor),
                                  SizedBox(width: 8),
                                  Text('Delete Trip')
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.people, size: 20, color: primaryColor),
                        const SizedBox(width: 4),
                        Text('$persons Persons'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.attach_money, size: 20, color: primaryColor),
                        const SizedBox(width: 4),
                        Text('Budget: $budget PKR'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 18, color: primaryColor),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '$formattedStartDate to $formattedEndDate',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: statusColor,
                            ),
                          ),
                          child: Text(
                            isCompleted
                                ? 'Completed'
                                : isInProgress
                                ? 'In Progress'
                                : 'Planned',
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!isCompleted && !isInProgress)
                          ElevatedButton(
                            onPressed: () async {
                              await _updateTripStatus(tripId, 'in_progress');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Start Trip', style: TextStyle(color: secondaryColor)),
                          ),
                        if (isInProgress)
                          ElevatedButton(
                            onPressed: () async {
                              await _updateTripStatus(tripId, 'completed');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('End Trip', style: TextStyle(color: secondaryColor)),
                          ),
                        if (isCompleted && !hasReviewed)
                          ElevatedButton(
                            onPressed: () => _showReviewDialog(context, tripId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Add Review', style: TextStyle(color: secondaryColor)),
                          ),
                        if (isCompleted && hasReviewed)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.purple),
                            ),
                            child: Text(
                              'Reviewed',
                              style: TextStyle(
                                color: Colors.purple,
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
          );
        },
      ),
    );
  }
}

class TripProgressDetailsPage extends StatefulWidget {
  final Map<String, dynamic> tripData;

  const TripProgressDetailsPage({Key? key, required this.tripData}) : super(key: key);

  @override
  _TripProgressDetailsPageState createState() => _TripProgressDetailsPageState();
}

class _TripProgressDetailsPageState extends State<TripProgressDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final startDate = (widget.tripData['startDate'] as Timestamp).toDate();
    final endDate = (widget.tripData['endDate'] as Timestamp).toDate();
    final totalDays = endDate.difference(startDate).inDays + 1;
    final elapsedDays = DateTime.now().difference(startDate).inDays + 1;
    final currentStage = elapsedDays.clamp(1, totalDays);
    final tripName = widget.tripData['tripName'] as String? ?? 'My Trip';

    return Scaffold(
      appBar: AppBar(
        title: Text('$tripName Progress', style: const TextStyle(color: secondaryColor)),
        backgroundColor: primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Trip Progress',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildProgressIndicator(totalDays, currentStage),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: totalDays,
                itemBuilder: (context, index) {
                  final dayNumber = index + 1;
                  final isCurrentDay = dayNumber == currentStage;
                  final dayDate = startDate.add(Duration(days: index));
                  final formattedDate = DateFormat('EEEE, MMM d').format(dayDate);

                  return Card(
                    elevation: isCurrentDay ? 4 : 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isCurrentDay ? primaryColor : primaryColor.withOpacity(0.3),
                        width: isCurrentDay ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isCurrentDay ? primaryColor : primaryColor.withOpacity(0.1),
                        child: Text(
                          '$dayNumber',
                          style: TextStyle(
                            color: isCurrentDay ? secondaryColor : primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        'Day $dayNumber ($formattedDate)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCurrentDay ? primaryColor : textColor,
                        ),
                      ),
                      subtitle: Text(
                        dayNumber < currentStage
                            ? 'Completed'
                            : isCurrentDay
                            ? 'Today'
                            : 'Upcoming',
                        style: TextStyle(
                          color: dayNumber < currentStage
                              ? primaryColor
                              : isCurrentDay
                              ? primaryColor
                              : textColor,
                        ),
                      ),
                      trailing: dayNumber < currentStage
                          ? Icon(Icons.check_circle, color: primaryColor)
                          : isCurrentDay
                          ? Icon(Icons.location_on, color: primaryColor)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int totalDays, int currentDay) {
    return Column(
      children: [
        Container(
          height: 40,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomPaint(
            painter: _ProgressPainter(
              totalDays: totalDays,
              currentDay: currentDay,
              color: primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Day 1',
              style: TextStyle(color: primaryColor),
            ),
            Text(
              'Day $totalDays',
              style: TextStyle(color: primaryColor),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor),
            ),
            child: Text(
              'Day $currentDay of $totalDays',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final int totalDays;
  final int currentDay;
  final Color color;

  _ProgressPainter({
    required this.totalDays,
    required this.currentDay,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double progressWidth = size.width;
    final double progressHeight = 8;
    final double radius = progressHeight / 2;

    // Draw background line
    final Paint backgroundPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final RRect backgroundRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, progressWidth, progressHeight),
      Radius.circular(radius),
    );

    canvas.drawRRect(backgroundRRect, backgroundPaint);

    // Draw progress line
    final double progress = currentDay / totalDays;
    final double filledWidth = progressWidth * progress;

    final Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final RRect progressRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, filledWidth, progressHeight),
      Radius.circular(radius),
    );

    canvas.drawRRect(progressRRect, progressPaint);

    // Draw current day indicator
    if (currentDay > 0 && currentDay <= totalDays) {
      final double indicatorPosition = (progressWidth * (currentDay - 1)) / (totalDays - 1);

      final Paint indicatorPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(indicatorPosition, progressHeight / 2),
        progressHeight * 1.2,
        indicatorPaint,
      );

      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '$currentDay',
          style: TextStyle(
            color: secondaryColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          indicatorPosition - textPainter.width / 2,
          progressHeight / 2 - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}