import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Map<String, dynamic>? _tripData;
  String? _tripId;

  @override
  void initState() {
    super.initState();
    _fetchLatestTrip();
  }

  Future<void> _fetchLatestTrip() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Use a simple query first to avoid index requirements
      final QuerySnapshot querySnapshot = await _firestore
          .collection('tripPlans')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _isLoading = false;
          _tripData = null;
        });
        return;
      }

      // Sort manually in memory (to avoid requiring a composite index)
      final docs = querySnapshot.docs;
      docs.sort((a, b) {
        final aDate = (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp;
        final bDate = (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp;
        return bDate.compareTo(aDate); // Sort by newest first
      });

      // Get the most recent trip
      final latestTrip = docs.first;

      setState(() {
        _isLoading = false;
        _tripData = latestTrip.data() as Map<String, dynamic>;
        _tripId = latestTrip.id;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load trip: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Progress', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0066CC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $_errorMessage',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchLatestTrip,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066CC),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      )
          : _buildTripContent(),
    );
  }

  Widget _buildTripContent() {
    if (_tripData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No trip planned yet!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066CC),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Plan a Trip',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    final status = _tripData!['status'];
    final startDate = (_tripData!['startDate'] as Timestamp).toDate();
    final endDate = (_tripData!['endDate'] as Timestamp).toDate();
    final totalDays = endDate.difference(startDate).inDays + 1;
    final elapsedDays = DateTime.now().difference(startDate).inDays + 1;
    final currentStage = elapsedDays.clamp(1, totalDays);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Progress',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0066CC)),
          ),
          const SizedBox(height: 20),
          _buildProgressBar(totalDays, currentStage),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: totalDays,
              itemBuilder: (context, index) {
                final dayNumber = index + 1;
                final isCurrentDay = dayNumber == currentStage;
                return Card(
                  elevation: isCurrentDay ? 4 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isCurrentDay ? Color(0xFF0066CC) : Colors.grey.shade200,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                      isCurrentDay ? Color(0xFF0066CC) : Colors.grey.shade300,
                      child: Text(
                        '$dayNumber',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      'Day $dayNumber',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCurrentDay ? Color(0xFF0066CC) : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      'Activities planned for Day $dayNumber',
                      style: TextStyle(
                        color: isCurrentDay ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    trailing: isCurrentDay
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          if (status == 'planned' || status == 'in_progress')
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await _firestore
                        .collection('tripPlans')
                        .doc(_tripId)
                        .update({'status': 'completed'});

                    setState(() {
                      _tripData!['status'] = 'completed';
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Trip marked as completed!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0066CC),
                  minimumSize: Size(200, 50),
                ),
                child: const Text(
                  'End Trip',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          if (status == 'completed')
            Center(
              child: ElevatedButton(
                onPressed: () => _showReviewDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0066CC),
                  minimumSize: Size(200, 50),
                ),
                child: const Text(
                  'Add Review',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int totalSteps, int currentStage) {
    return Row(
      children: List.generate(totalSteps, (index) {
        bool isActive = index < currentStage;
        bool isCurrent = index == currentStage - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isActive ? Color(0xFF0066CC) : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (index < totalSteps - 1)
                Expanded(
                  child: Container(
                    height: 4,
                    color: index < currentStage - 1 ? Color(0xFF0066CC) : Colors.grey[300],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  void _showReviewDialog(BuildContext context) {
    int selectedRating = 0;
    final reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Review',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0066CC),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: reviewController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Your Review',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
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
                                color: index < selectedRating ? Colors.amber : Colors.grey[300],
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
                            child: Text('Cancel', style: TextStyle(color: Color(0xFF0066CC))),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () async {
                              if (selectedRating == 0 || reviewController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please provide a rating and review.')),
                                );
                                return;
                              }
                              try {
                                // Get user information
                                final user = _auth.currentUser;

                                await _firestore.collection('reviews').add({
                                  'uid': user?.uid,
                                  'name': user?.displayName ?? 'Anonymous User',
                                  'rating': selectedRating,
                                  'review': reviewController.text,
                                  'timestamp': Timestamp.now(),
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Review submitted successfully!')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to submit review: $e')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0066CC),
                              minimumSize: Size(100, 40),
                            ),
                            child: const Text('Send', style: TextStyle(color: Colors.white)),
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
}