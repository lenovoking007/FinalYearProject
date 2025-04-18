import 'package:flutter/material.dart';

class TripStatusPage extends StatefulWidget {
  const TripStatusPage({Key? key}) : super(key: key);

  @override
  _TripStatusPageState createState() => _TripStatusPageState();
}

class _TripStatusPageState extends State<TripStatusPage> {
  int selectedRating = 0;
  final int currentStage = 4; // Current progress (1-5)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Progress', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0066CC),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip Progress',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0066CC)),
            ),
            SizedBox(height: 20),
            // Improved progress bar
            _buildProgressBar(),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildTripCard('Day 1', 'Visit to Lahore Fort and Badshahi Mosque, explore historic sites.'),
                  _buildTripCard('Day 2', 'Discover Lahore Museum and enjoy the local food street.'),
                  _buildTripCard('Day 3', 'Spend the day at Shalimar Gardens and Minar-e-Pakistan.'),
                  _buildTripCard('Day 4', 'Relax at Jilani Park and shop at Liberty Market.'),
                  _buildTripCard('Day 5', 'Conclude with a visit to Wagah Border and Anarkali Bazaar.'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0066CC),
                  minimumSize: Size(200, 50),
                ),
                onPressed: () => _showReviewDialog(context),
                child: Text(
                  'Add Review',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final totalSteps = 5;

    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: List.generate(totalSteps, (index) {
              // Calculate if this step is active
              bool isActive = index <currentStage;
              bool isCurrent = index == currentStage - 1;

              // Connect with lines between circles
              return Expanded(
                child: Row(
                  children: [
                    // The circle indicator
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // The connecting line (don't add after the last item)
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
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(String day, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0066CC)),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 400),
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
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Your Review',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
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
                                color: index <selectedRating ? Colors.amber : Colors.grey[300],
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel', style: TextStyle(color: Color(0xFF0066CC))),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Review submitted successfully!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0066CC),
                              minimumSize: Size(100, 40),
                            ),
                            child: Text('Send', style: TextStyle(color: Colors.white)),
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