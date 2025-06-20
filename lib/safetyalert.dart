import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// SafetyAlertProvider for state management
class SafetyAlertProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot>? _alertsStream;
  String? _errorMessage;
  bool _isLoading = false;

  Stream<QuerySnapshot>? get alertsStream => _alertsStream;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> loadAlerts() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _alertsStream = _firestore
          .collection('safety_alerts')
          .where('uid', isEqualTo: _auth.currentUser?.uid ?? '')
          .snapshots();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load alerts: ${e.toString()}';
      notifyListeners();
      debugPrint('Error loading alerts: $e');
    }
  }
}

class SafetyAlertPage extends StatefulWidget {
  const SafetyAlertPage({Key? key}) : super(key: key);

  @override
  State<SafetyAlertPage> createState() => _SafetyAlertPageState();
}

class _SafetyAlertPageState extends State<SafetyAlertPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> _alertsStream;
  final SafetyAlertProvider _provider = SafetyAlertProvider();

  @override
  void initState() {
    super.initState();
    _loadAlerts();
    _provider.loadAlerts();
  }

  void _loadAlerts() {
    _alertsStream = _firestore
        .collection('safety_alerts')
        .where('uid', isEqualTo: _auth.currentUser?.uid ?? '')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Safety Alerts",
          style: TextStyle(
            color: Color(0xFF0066CC),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF0066CC)),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout adjustments
          final double cardWidth = constraints.maxWidth > 600
              ? 600
              : constraints.maxWidth * 0.95;
          final EdgeInsets padding = constraints.maxWidth > 600
              ? EdgeInsets.symmetric(
              horizontal: (constraints.maxWidth - 600) / 2)
              : const EdgeInsets.all(16);

          return Column(
            children: [
              // Original implementation
              Expanded(
                child: _buildAlertList(padding, cardWidth),
              ),

              // Additional state-managed implementation
              ChangeNotifierProvider<SafetyAlertProvider>(
                create: (_) => _provider,
                child: Consumer<SafetyAlertProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0066CC),
                        ),
                      );
                    }

                    if (provider.errorMessage != null) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: provider.loadAlerts,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0066CC),
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAlertList(EdgeInsets padding, double cardWidth) {
    return StreamBuilder<QuerySnapshot>(
      stream: _alertsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(
            color: Color(0xFF0066CC),
          ));
        }

        if (snapshot.hasError) {
          debugPrint('Firestore Error: ${snapshot.error}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Could not load alerts'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _loadAlerts,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066CC),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No safety alerts found'));
        }

        return ListView.builder(
          padding: padding,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            return Center(
              child: SizedBox(
                width: cardWidth,
                child: _buildAlertCard(doc),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAlertCard(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Robust date handling
    String dateString = 'Date not available';
    try {
      if (data['date'] is Timestamp) {
        final date = (data['date'] as Timestamp).toDate();
        dateString = '${date.day}/${date.month}/${date.year}';
      } else if (data['date'] != null) {
        dateString = data['date'].toString();
      }
    } catch (e) {
      debugPrint('Date parsing error: $e');
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: data['status'] == 'Active'
                        ? Colors.red.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning,
                    color: data['status'] == 'Active'
                        ? Colors.red
                        : Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    data['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: data['status'] == 'Active'
                        ? Colors.red
                        : Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data['status'] ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data['description'] ?? 'No description available',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Location on left
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Color(0xFF0066CC)),
                    const SizedBox(width: 4),
                    Text(data['location'] ?? 'Unknown location'),
                  ],
                ),
                // Spacer to push calendar to right
                const Spacer(),
                // Calendar on right
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Color(0xFF0066CC)),
                    const SizedBox(width: 4),
                    Text(dateString),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}