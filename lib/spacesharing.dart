// space_sharing_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async'; // For Timer

// Define the SpaceSharingModel to represent a ride
class SpaceSharingModel {
  final String id;
  final String driverId;
  final String driverName;
  final String? driverProfileImageUrl; // Optional: fetched from Storage
  final String vehicleNumber; // Changed from 'vehicle'
  final String vehicleType; // New: e.g., 'AC Car', 'Bus'
  final String departureCity;
  final String arrivalCity;
  final DateTime departureDateTime;
  final int seatsAvailable;
  final double costPerSeat;
  final DateTime postedAt;
  final List<String> acceptedBy; // List of user UIDs who accepted this ride
  final String status; // e.g., 'available', 'completed', 'cancelled'
  final String contactNumber; // New: Driver's contact number

  SpaceSharingModel({
    required this.id,
    required this.driverId,
    required this.driverName,
    this.driverProfileImageUrl,
    required this.vehicleNumber, // Changed
    required this.vehicleType, // New
    required this.departureCity,
    required this.arrivalCity,
    required this.departureDateTime,
    required this.seatsAvailable,
    required this.costPerSeat,
    required this.postedAt,
    this.acceptedBy = const [],
    required this.status,
    required this.contactNumber, // New
  });

  // Factory constructor to create a SpaceSharingModel from a Firestore document
  factory SpaceSharingModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SpaceSharingModel(
      id: doc.id,
      driverId: data['driverId'] as String,
      driverName: data['driverName'] as String? ?? 'Unknown Driver', // Handle null
      driverProfileImageUrl: data['driverProfileImageUrl'] as String?,
      vehicleNumber: data['vehicleNumber'] as String? ?? 'N/A', // Handle null
      vehicleType: data['vehicleType'] as String? ?? 'N/A', // Handle null
      departureCity: data['departureCity'] as String? ?? 'Unknown City', // Handle null
      arrivalCity: data['arrivalCity'] as String? ?? 'Unknown City', // Handle null
      departureDateTime: (data['departureDateTime'] as Timestamp?)?.toDate() ?? DateTime.now(), // Handle null timestamp
      seatsAvailable: data['seatsAvailable'] as int? ?? 0, // Handle null
      costPerSeat: (data['costPerSeat'] as num?)?.toDouble() ?? 0.0, // Handle null
      postedAt: (data['postedAt'] as Timestamp?)?.toDate() ?? DateTime.now(), // Handle null timestamp
      acceptedBy: List<String>.from(data['acceptedBy'] ?? []),
      status: data['status'] as String? ?? 'available', // Default to 'available'
      contactNumber: data['contactNumber'] as String? ?? 'N/A', // Handle null
    );
  }

  // Convert SpaceSharingModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'driverId': driverId,
      'driverName': driverName,
      'driverProfileImageUrl': driverProfileImageUrl,
      'vehicleNumber': vehicleNumber, // Changed
      'vehicleType': vehicleType, // New
      'departureCity': departureCity,
      'arrivalCity': arrivalCity,
      'departureDateTime': Timestamp.fromDate(departureDateTime),
      'seatsAvailable': seatsAvailable,
      'costPerSeat': costPerSeat,
      'postedAt': Timestamp.fromDate(postedAt),
      'acceptedBy': acceptedBy,
      'status': status,
      'contactNumber': contactNumber, // New
    };
  }
}

// Main Space Sharing Page with Tabs
class SpaceSharingPage extends StatefulWidget {
  const SpaceSharingPage({super.key});

  @override
  _SpaceSharingPageState createState() => _SpaceSharingPageState();
}

class _SpaceSharingPageState extends State<SpaceSharingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? _currentUser; // Make nullable to handle initial null state

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Two tabs: Available and My Accepted
    _currentUser = _auth.currentUser; // Get current user at init

    // Listen for auth state changes to ensure user is logged in
    _auth.authStateChanges().listen((user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Function to get user profile image URL from Firebase Storage
  Future<String?> _getProfileImageUrl(String userId) async {
    try {
      final url = await _storage.ref('profile_images/$userId').getDownloadURL();
      return url;
    } catch (e) {
      print("Error fetching profile image for $userId: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0066CC),
        elevation: 0,
        title: const Text(
          "Space Sharing (Rides)",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Icon to add new space sharing ride
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSpacePage(
                    currentUser: _currentUser!,
                    getProfileImageUrl: _getProfileImageUrl,
                  ),
                ),
              );
            },
          ),
          // Icon to view ride history
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RideHistoryPage(
                    currentUser: _currentUser!,
                    getProfileImageUrl: _getProfileImageUrl,
                  ),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Available Space Sharing'),
            Tab(text: 'My Accepted Rides'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AvailableSpaceSharingTab(
            currentUser: _currentUser!,
            getProfileImageUrl: _getProfileImageUrl,
          ),
          MyAcceptedRidesTab(
            currentUser: _currentUser!,
            getProfileImageUrl: _getProfileImageUrl,
          ),
        ],
      ),
    );
  }
}

// Page to add a new Space Sharing ride
class AddSpacePage extends StatefulWidget {
  final User currentUser;
  final Future<String?> Function(String userId) getProfileImageUrl;

  const AddSpacePage({
    super.key,
    required this.currentUser,
    required this.getProfileImageUrl,
  });

  @override
  _AddSpacePageState createState() => _AddSpacePageState();
}

class _AddSpacePageState extends State<AddSpacePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController(); // Changed
  final TextEditingController _departureCityController = TextEditingController();
  final TextEditingController _arrivalCityController = TextEditingController();
  final TextEditingController _departureDateTimeController = TextEditingController();
  final TextEditingController _seatsAvailableController = TextEditingController();
  final TextEditingController _costPerSeatController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController(); // New

  String? _selectedVehicleType; // New state for vehicle type
  DateTime? _selectedDateTime;
  double _calculatedCostPerSeat = 0.0;
  int _maxSeats = 0;

  final List<String> _cities = const [
    'Faisalabad', 'Gwadar', 'Hunza', 'Hyderabad', 'Islamabad', 'Karachi',
    'Lahore', 'Multan', 'Murree', 'Naran', 'Peshawar', 'Quetta', 'Rawalpindi',
    'Sawat', 'Sialkot', 'Skardu'
  ];

  final Map<String, int> _vehicleTypeMaxSeats = {
    'AC Car': 4,
    'Non-AC Car': 4,
    'Mini Car': 4,
    'Bus': 30,
    'Coaster': 18,
    'AVP Car': 10, // Corrected from MVP Car
  };


  @override
  void initState() {
    super.initState();
    _loadUserName();
    _seatsAvailableController.addListener(_updateTotalCost);
    _costPerSeatController.addListener(_updateTotalCost);
  }

  Future<void> _loadUserName() async {
    try {
      final doc = await _firestore.collection('users').doc(widget.currentUser.uid).get();
      if (doc.exists && doc.data() != null) {
        _driverNameController.text = doc.data()!['name'] ?? '';
      }
    } catch (e) {
      print("Error loading user name: $e");
    }
  }

  void _updateTotalCost() {
    final int? seats = int.tryParse(_seatsAvailableController.text);
    final double? cost = double.tryParse(_costPerSeatController.text);
    if (seats != null && cost != null) {
      setState(() {
        _calculatedCostPerSeat = cost; // Keep track of the entered cost per seat
      });
    } else {
      setState(() {
        _calculatedCostPerSeat = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _driverNameController.dispose();
    _vehicleNumberController.dispose();
    _departureCityController.dispose();
    _arrivalCityController.dispose();
    _departureDateTimeController.dispose();
    _seatsAvailableController.dispose();
    _costPerSeatController.dispose();
    _contactNumberController.dispose(); // New
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2028),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0066CC),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0066CC),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF0066CC),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0066CC),
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _departureDateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!);
        });
      }
    }
  }

  Future<void> _saveSpaceSharing() async {
    if (_driverNameController.text.isEmpty ||
        _vehicleNumberController.text.isEmpty ||
        _selectedVehicleType == null ||
        _departureCityController.text.isEmpty ||
        _arrivalCityController.text.isEmpty ||
        _departureDateTimeController.text.isEmpty ||
        _seatsAvailableController.text.isEmpty ||
        _costPerSeatController.text.isEmpty ||
        _contactNumberController.text.isEmpty || // New validation
        _selectedDateTime == null) {
      _showSnackBar(context, 'Please fill all fields and select a date/time.');
      return;
    }

    try {
      final int? seats = int.tryParse(_seatsAvailableController.text);
      final double? cost = double.tryParse(_costPerSeatController.text);

      if (seats == null || cost == null || seats <= 0 || cost < 0) {
        _showSnackBar(context, 'Please enter valid positive numbers for seats and cost.');
        return;
      }

      if (seats > _maxSeats) {
        _showSnackBar(context, 'Number of seats exceeds maximum for selected vehicle type ($_maxSeats).');
        return;
      }

      // Validate contact number
      if (!RegExp(r'^\d{11}$').hasMatch(_contactNumberController.text)) {
        _showSnackBar(context, 'Please enter a valid 11-digit contact number.');
        return;
      }

      // Validate vehicle number (basic regex for Pakistani plates)
      if (!RegExp(r'^[A-Z]{2,3}-?\d{2,4}$|^[A-Z]{2,3} \d{2,4}$').hasMatch(_vehicleNumberController.text.toUpperCase())) {
        _showSnackBar(context, 'Please enter a valid vehicle number (e.g., ABC-1234 or ABC 1234).');
        return;
      }


      final driverProfileImageUrl = await widget.getProfileImageUrl(widget.currentUser.uid);

      final newRide = SpaceSharingModel(
        id: '',
        driverId: widget.currentUser.uid,
        driverName: _driverNameController.text,
        driverProfileImageUrl: driverProfileImageUrl,
        vehicleNumber: _vehicleNumberController.text,
        vehicleType: _selectedVehicleType!,
        departureCity: _departureCityController.text,
        arrivalCity: _arrivalCityController.text,
        departureDateTime: _selectedDateTime!,
        seatsAvailable: seats,
        costPerSeat: cost,
        postedAt: DateTime.now(),
        status: 'available',
        acceptedBy: [],
        contactNumber: _contactNumberController.text, // New
      );

      await _firestore.collection('SpaceSharings').add(newRide.toMap());

      _showSuccessDialog(context, 'Your space sharing ride has been added.').then((_) {
        Navigator.pop(context); // Pop the AddSpacePage to return to the previous tab
      });
    } catch (e) {
      print("Error saving space sharing: $e");
      _showSnackBar(context, 'Failed to add ride: $e');
    }
  }

  void _clearForm() {
    _driverNameController.clear();
    _vehicleNumberController.clear();
    _departureCityController.clear();
    _arrivalCityController.clear();
    _departureDateTimeController.clear();
    _seatsAvailableController.clear();
    _costPerSeatController.clear();
    _contactNumberController.clear(); // New
    setState(() {
      _selectedDateTime = null;
      _selectedVehicleType = null;
      _calculatedCostPerSeat = 0.0;
      _maxSeats = 0;
    });
  }

  Widget _buildEditableTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLength,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF0066CC).withOpacity(0.1), // Blue tint
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF0066CC).withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0066CC)), // Solid blue on focus
        ),
        labelText: label,
        labelStyle: TextStyle(color: const Color(0xFF0066CC).withOpacity(0.7)), // Blue label
        suffixIcon: Icon(icon, color: const Color(0xFF0066CC).withOpacity(0.7)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        counterText: '',
        errorStyle: const TextStyle(fontSize: 12, color: Colors.red), // Keep red for error text
      ),
      style: const TextStyle(color: Colors.black87), // Text input color
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0066CC).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0066CC).withOpacity(0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: value,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          labelText: label,
          labelStyle: TextStyle(color: const Color(0xFF0066CC).withOpacity(0.7)),
          suffixIcon: Icon(Icons.arrow_drop_down, color: const Color(0xFF0066CC).withOpacity(0.7)),
        ),
        hint: Text('Select $label', style: TextStyle(color: const Color(0xFF0066CC).withOpacity(0.7))),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(color: Colors.black87)),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0066CC),
        title: const Text("Add Space (Ride)", style: TextStyle(color: Colors.white)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildEditableTextField(
                    label: "Driver Name",
                    controller: _driverNameController,
                    icon: Icons.person,
                    readOnly: true, // Auto-filled
                  ),
                  const SizedBox(height: 16),
                  _buildEditableTextField(
                    label: "Vehicle Number", // Changed label
                    controller: _vehicleNumberController,
                    icon: Icons.directions_car,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter vehicle number';
                      if (!RegExp(r'^[A-Z]{2,3}-?\d{2,4}$|^[A-Z]{2,3} \d{2,4}$').hasMatch(value.toUpperCase())) {
                        return 'Invalid format (e.g., ABC-1234 or ABC 1234)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Vehicle Type Dropdown
                  _buildDropdownField(
                    label: 'Vehicle Type',
                    value: _selectedVehicleType,
                    items: _vehicleTypeMaxSeats.keys.toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVehicleType = value;
                        _maxSeats = _vehicleTypeMaxSeats[value] ?? 0;
                        // Removed auto-setting of _costPerSeatController.text
                      });
                    },
                    validator: (value) => value == null ? 'Please select a vehicle type' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: 'Departure City',
                    value: _departureCityController.text.isEmpty ? null : _departureCityController.text,
                    items: _cities,
                    onChanged: (value) {
                      setState(() {
                        _departureCityController.text = value!;
                      });
                    },
                    validator: (value) => value == null ? 'Please select departure city' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: 'Arrival City',
                    value: _arrivalCityController.text.isEmpty ? null : _arrivalCityController.text,
                    items: _cities,
                    onChanged: (value) {
                      setState(() {
                        _arrivalCityController.text = value!;
                      });
                    },
                    validator: (value) => value == null ? 'Please select arrival city' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildEditableTextField(
                    label: "Departure Date & Time",
                    controller: _departureDateTimeController,
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap: () => _selectDateTime(context),
                  ),
                  const SizedBox(height: 16),
                  _buildEditableTextField(
                    label: "Number of Seats Available (Max: $_maxSeats)",
                    controller: _seatsAvailableController,
                    icon: Icons.event_seat,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter seats';
                      final seats = int.tryParse(value);
                      if (seats == null || seats <= 0) return 'Enter a valid number';
                      if (_selectedVehicleType != null && seats > _maxSeats) {
                        return 'Max seats for $_selectedVehicleType is $_maxSeats';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildEditableTextField(
                    label: "Cost per Seat (PKR)",
                    controller: _costPerSeatController,
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    // Now editable by the user
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter cost';
                      final cost = double.tryParse(value);
                      if (cost == null || cost < 0) return 'Enter a valid cost';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildEditableTextField(
                    label: "Contact Number",
                    controller: _contactNumberController,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter contact number';
                      if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                        return 'Enter a valid 11-digit number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Total Cost Display
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0066CC).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF0066CC).withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Cost for all seats:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0066CC).withOpacity(0.9),
                          ),
                        ),
                        Text(
                          "PKR ${(_calculatedCostPerSeat * (int.tryParse(_seatsAvailableController.text) ?? 0)).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _clearForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066CC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Clear", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveSpaceSharing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066CC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Save", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Tab for Available Space Sharing rides
class AvailableSpaceSharingTab extends StatefulWidget {
  final User currentUser;
  final Future<String?> Function(String userId) getProfileImageUrl;

  const AvailableSpaceSharingTab({
    super.key,
    required this.currentUser,
    required this.getProfileImageUrl,
  });

  @override
  _AvailableSpaceSharingTabState createState() => _AvailableSpaceSharingTabState();
}

class _AvailableSpaceSharingTabState extends State<AvailableSpaceSharingTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounce; // Debounce timer for search input to prevent excessive Firestore calls

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // Cancel any active debounce timer
    super.dispose();
  }

  // Function to accept a space sharing ride
  Future<void> _acceptRide(SpaceSharingModel ride) async {
    // Show payment pop-up
    String? selectedPaymentMethod;
    final TextEditingController accountNumberController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Confirm Payment', style: TextStyle(color: Color(0xFF0066CC))),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Total Fare: PKR ${ride.costPerSeat.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedPaymentMethod,
                    decoration: InputDecoration(
                      labelText: 'Payment Method',
                      labelStyle: TextStyle(color: const Color(0xFF0066CC).withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: const Color(0xFF0066CC).withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF0066CC)),
                      ),
                    ),
                    items: ['EasyPaisa', 'JazzCash', 'Bank Transfer'].map((String method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Text(method, style: const TextStyle(color: Colors.black87)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a payment method' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: accountNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Account Number',
                      labelStyle: TextStyle(color: const Color(0xFF0066CC).withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: const Color(0xFF0066CC).withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF0066CC)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter account number';
                      if (selectedPaymentMethod == 'EasyPaisa' || selectedPaymentMethod == 'JazzCash') {
                        if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                          return 'Enter a valid 11-digit mobile number';
                        }
                      } else if (selectedPaymentMethod == 'Bank Transfer') {
                        if (value.length < 10) return 'Bank account number too short'; // Basic length check
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Color(0xFF0066CC))),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context); // Dismiss payment dialog
                    try {
                      await _firestore
                          .collection('users')
                          .doc(widget.currentUser.uid)
                          .collection('acceptedSpaceSharings')
                          .doc(ride.id)
                          .set({
                        'spaceSharingId': ride.id,
                        'acceptedAt': FieldValue.serverTimestamp(),
                        'driverId': ride.driverId,
                        'status': 'accepted',
                        'paymentMethod': selectedPaymentMethod,
                        'paymentAccountNumber': accountNumberController.text,
                        'farePaid': ride.costPerSeat,
                      });

                      await _firestore.collection('SpaceSharings').doc(ride.id).update({
                        'acceptedBy': FieldValue.arrayUnion([widget.currentUser.uid]),
                      });

                      _showSuccessDialog(context, 'Payment successful! Ride accepted.');
                    } catch (e) {
                      print("Error accepting ride: $e");
                      _showSnackBar(context, 'Failed to accept ride: $e');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066CC),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Pay Now'),
              ),
            ],
          );
        },
      ),
    );
  }

  // Function to hide/decline a space sharing ride (for the current user's view only)
  Future<void> _hideRide(SpaceSharingModel ride) async {
    try {
      await _firestore
          .collection('users')
          .doc(widget.currentUser.uid)
          .collection('hiddenSpaceSharings')
          .doc(ride.id)
          .set({
        'spaceSharingId': ride.id,
        'hiddenAt': FieldValue.serverTimestamp(),
      });
      _showSnackBar(context, 'Ride hidden.');
    } catch (e) {
      print("Error hiding ride: $e");
      _showSnackBar(context, 'Failed to hide ride: $e');
    }
  }

  // Function to delete a space sharing ride (only for the driver who posted it)
  Future<void> _deleteRide(String rideId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Ride', style: TextStyle(color: Color(0xFF0066CC))),
        content: const Text('Are you sure you want to delete this ride? This action cannot be undone and will remove it for all users.', style: TextStyle(color: Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF0066CC))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066CC),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context); // Dismiss dialog
              try {
                await _firestore.collection('SpaceSharings').doc(rideId).delete();
                _showSnackBar(context, 'Ride deleted successfully!');
              } catch (e) {
                print("Error deleting ride: $e");
                _showSnackBar(context, 'Failed to delete ride: $e');
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar for filtering rides by city
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search by City (e.g., Lahore)",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                icon: const Icon(Icons.search, color: Color(0xFF0066CC)),
              ),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                });
              },
            ),
          ),
        ),
        // Available Rides Section (StreamBuilder for real-time updates)
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('SpaceSharings')
                .where('status', isEqualTo: 'available')
                .orderBy('postedAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.event_seat, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No available rides yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Be the first to share a ride!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return FutureBuilder<List<List<String>>>(
                future: Future.wait([
                  _firestore
                      .collection('users')
                      .doc(widget.currentUser.uid)
                      .collection('acceptedSpaceSharings')
                      .get()
                      .then((s) => s.docs.map((d) => d.id).toList()),
                  _firestore
                      .collection('users')
                      .doc(widget.currentUser.uid)
                      .collection('hiddenSpaceSharings')
                      .get()
                      .then((s) => s.docs.map((d) => d.id).toList()),
                ]),
                builder: (context, filterSnapshot) {
                  if (filterSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
                      ),
                    );
                  }
                  if (filterSnapshot.hasError) {
                    return Center(child: Text('Error loading user filters: ${filterSnapshot.error}', style: const TextStyle(color: Colors.red)));
                  }

                  final acceptedRideIds = filterSnapshot.data![0];
                  final hiddenRideIds = filterSnapshot.data![1];

                  final rides = snapshot.data!.docs
                      .map((doc) => SpaceSharingModel.fromDocument(doc))
                      .where((ride) {
                    final matchesSearch = _searchQuery.isEmpty ||
                        ride.departureCity.toLowerCase().contains(_searchQuery) ||
                        ride.arrivalCity.toLowerCase().contains(_searchQuery);

                    // A user's own ride should now be visible in this tab
                    final isMyRide = ride.driverId == widget.currentUser.uid;
                    final isNotAcceptedByMe = !acceptedRideIds.contains(ride.id);
                    final isNotHiddenByMe = !hiddenRideIds.contains(ride.id);

                    // Show own rides, and other rides that are not accepted or hidden by me
                    return matchesSearch && (isMyRide || (isNotAcceptedByMe && isNotHiddenByMe));
                  }).toList();

                  if (rides.isEmpty && _searchQuery.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.search_off, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No rides found for your search criteria.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Try a different city or check back later.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  } else if (rides.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.event_seat, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No available rides to display.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Share a ride or check back later for new listings!',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: rides.length,
                    itemBuilder: (context, index) {
                      final ride = rides[index];
                      final isMyRide = ride.driverId == widget.currentUser.uid;

                      return RideCard(
                        ride: ride,
                        isMyRide: isMyRide,
                        onAccept: () => _acceptRide(ride),
                        onHide: () => _hideRide(ride),
                        onDelete: () => _deleteRide(ride.id),
                        getProfileImageUrl: widget.getProfileImageUrl,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Tab for My Accepted Rides
class MyAcceptedRidesTab extends StatefulWidget {
  final User currentUser;
  final Future<String?> Function(String userId) getProfileImageUrl;

  const MyAcceptedRidesTab({
    super.key,
    required this.currentUser,
    required this.getProfileImageUrl,
  });

  @override
  _MyAcceptedRidesTabState createState() => _MyAcceptedRidesTabState();
}

class _MyAcceptedRidesTabState extends State<MyAcceptedRidesTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to cancel an accepted ride
  Future<void> _cancelAcceptedRide(String acceptedRideDocId, SpaceSharingModel ride) async {
    String? selectedPaymentMethod;
    final TextEditingController accountNumberController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Confirm Cancellation & Refund', style: TextStyle(color: Color(0xFF0066CC))),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Original Fare: PKR ${ride.costPerSeat.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedPaymentMethod,
                    decoration: InputDecoration(
                      labelText: 'Refund Account Type',
                      labelStyle: TextStyle(color: const Color(0xFF0066CC).withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: const Color(0xFF0066CC).withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF0066CC)),
                      ),
                    ),
                    items: ['EasyPaisa', 'JazzCash', 'Bank Transfer'].map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type, style: const TextStyle(color: Colors.black87)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                    validator: (value) => value == null ? 'Please select an account type' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: accountNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Account Number',
                      labelStyle: TextStyle(color: const Color(0xFF0066CC).withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: const Color(0xFF0066CC).withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF0066CC)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter account number';
                      if (selectedPaymentMethod == 'EasyPaisa' || selectedPaymentMethod == 'JazzCash') {
                        if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                          return 'Enter a valid 11-digit mobile number';
                        }
                      } else if (selectedPaymentMethod == 'Bank Transfer') {
                        if (value.length < 10) return 'Bank account number too short'; // Basic length check
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Color(0xFF0066CC))),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context); // Dismiss refund dialog

                    double refundAmount = 0.0;
                    String refundMessage = '';
                    final now = DateTime.now();
                    final timeUntilDeparture = ride.departureDateTime.difference(now);

                    if (timeUntilDeparture.inHours > 34) { // More than 34 hours (1 day + 10 hours)
                      refundAmount = ride.costPerSeat; // Full refund if cancelled more than 34 hours before
                      refundMessage = '100% refund (PKR ${refundAmount.toStringAsFixed(2)}) due to cancellation more than 34 hours before departure.';
                    } else if (timeUntilDeparture.inHours > 24) { // Between 24 and 34 hours
                      refundAmount = ride.costPerSeat * 0.70;
                      refundMessage = '70% refund (PKR ${refundAmount.toStringAsFixed(2)}) due to cancellation between 24 and 34 hours before departure.';
                    } else if (timeUntilDeparture.inHours > 1) { // Between 1 and 24 hours
                      refundAmount = ride.costPerSeat * 0.30;
                      refundMessage = '30% refund (PKR ${refundAmount.toStringAsFixed(2)}) due to cancellation more than 1 hour before departure.';
                    } else { // Within 1 hour or after departure
                      refundAmount = 0.0;
                      refundMessage = 'No refund due to cancellation less than 1 hour before departure.';
                    }


                    try {
                      // Update the accepted ride document with cancellation details
                      await _firestore
                          .collection('users')
                          .doc(widget.currentUser.uid)
                          .collection('acceptedSpaceSharings')
                          .doc(acceptedRideDocId)
                          .update({
                        'status': 'cancelled',
                        'cancelledAt': FieldValue.serverTimestamp(),
                        'refundAmount': refundAmount,
                        'refundAccountType': selectedPaymentMethod,
                        'refundAccountNumber': accountNumberController.text,
                      });

                      // Remove the user's UID from the original SpaceSharing document's 'acceptedBy' array
                      await _firestore.collection('SpaceSharings').doc(ride.id).update({
                        'acceptedBy': FieldValue.arrayRemove([widget.currentUser.uid]),
                      });

                      _showSuccessDialog(context,
                          'Ride cancelled. $refundMessage Your money will be received back within 15 working days.');
                    } catch (e) {
                      print("Error canceling accepted ride: $e");
                      _showSnackBar(context, 'Failed to cancel ride: $e');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066CC),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirm Cancellation'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .doc(widget.currentUser.uid)
          .collection('acceptedSpaceSharings')
          .where('status', isEqualTo: 'accepted') // Only show currently accepted rides
          .orderBy('acceptedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.event_note, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No accepted rides yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Accept a ride from the "Available" tab to see it here.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final acceptedRideDoc = snapshot.data!.docs[index];
            final originalSpaceSharingId = acceptedRideDoc['spaceSharingId'];

            return FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection('SpaceSharings').doc(originalSpaceSharingId).get(),
              builder: (context, rideSnapshot) {
                if (rideSnapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC))),
                    ),
                  );
                }
                if (rideSnapshot.hasError) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Error loading ride details: ${rideSnapshot.error}', style: const TextStyle(color: Colors.red)));
                }
                if (!rideSnapshot.hasData || !rideSnapshot.data!.exists) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ride not found or deleted by driver.',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Original ID: $originalSpaceSharingId',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () => _cancelAcceptedRide(acceptedRideDoc.id, SpaceSharingModel(
                                id: originalSpaceSharingId, driverId: '', driverName: '', vehicleNumber: '', vehicleType: '',
                                departureCity: '', arrivalCity: '', departureDateTime: DateTime.now(),
                                seatsAvailable: 0, costPerSeat: 0.0, postedAt: DateTime.now(), status: '', contactNumber: '',
                              )),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0066CC),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Remove from My Accepted'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final ride = SpaceSharingModel.fromDocument(rideSnapshot.data!);
                return AcceptedRideCard(
                  ride: ride,
                  onCancel: (docId, rideModel) => _cancelAcceptedRide(docId, rideModel),
                  getProfileImageUrl: widget.getProfileImageUrl,
                );
              },
            );
          },
        );
      },
    );
  }
}

// Reusable Ride Card for Available Space Sharing
class RideCard extends StatelessWidget {
  final SpaceSharingModel ride;
  final bool isMyRide; // To determine if the current user posted this ride
  final VoidCallback onAccept;
  final VoidCallback onHide;
  final VoidCallback onDelete; // Only for my rides
  final Future<String?> Function(String userId) getProfileImageUrl;

  const RideCard({
    super.key,
    required this.ride,
    required this.isMyRide,
    required this.onAccept,
    required this.onHide,
    required this.onDelete,
    required this.getProfileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Driver's profile image, using FutureBuilder and CachedNetworkImage
              FutureBuilder<String?>(
                future: getProfileImageUrl(ride.driverId),
                builder: (context, snapshot) {
                  return CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[200], // Placeholder background
                    backgroundImage: snapshot.data != null
                        ? CachedNetworkImageProvider(snapshot.data!) // Use fetched URL
                        : null,
                    child: snapshot.data == null
                        ? const Icon(Icons.person, color: Colors.grey) // Default icon if no image
                        : null,
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Driver: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0066CC), // Blue color
                          ),
                        ),
                        Text(
                          ride.driverName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Placeholder for a verified icon (can be dynamic based on user data)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF0066CC), // Blue verified icon
                          size: 20,
                        ),
                      ],
                    ),
                    Text(
                      "Route: ${ride.departureCity} → ${ride.arrivalCity}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Settings/Delete button for my own rides
              if (isMyRide)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete Ride'),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: "Travel Date: ",
                  style: TextStyle(
                    color: Color(0xFF0066CC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "${DateFormat('MMM dd, EEEE HH:mm').format(ride.departureDateTime)}\n"),
                TextSpan(
                  text: "Vehicle Number: ", // Corrected label
                  style: TextStyle(
                    color: Color(0xFF0066CC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "${ride.vehicleNumber} (${ride.vehicleType})\n"),
                TextSpan(
                  text: "Contact: ",
                  style: TextStyle(
                    color: Color(0xFF0066CC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "${ride.contactNumber}\n"),
                TextSpan(
                  text: "Seats Available: ",
                  style: TextStyle(
                    color: Color(0xFF0066CC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "${ride.seatsAvailable}\n"), // Added newline
                TextSpan(
                  text: "Cost per Seat: ",
                  style: TextStyle(
                    color: Color(0xFF0066CC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "PKR ${ride.costPerSeat.toStringAsFixed(2)}\n"),
                TextSpan(
                  text: "Total Cost: ",
                  style: TextStyle(
                    color: Color(0xFF0066CC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "PKR ${(ride.costPerSeat * ride.seatsAvailable).toStringAsFixed(2)}"),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Star ratings (placeholder, implement actual rating if needed)
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < 4 ? Icons.star : Icons.star_border, // Example: 4 stars filled
                color: Colors.amber,
                size: 20,
              );
            }),
          ),
          const SizedBox(height: 8),
          // Action buttons (Accept/Hide for others' rides)
          if (!isMyRide)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept, // Call the onAccept callback
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066CC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onHide, // Call the onHide callback
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Use a different color for Hide
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Hide",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// Reusable Card for My Accepted Rides
class AcceptedRideCard extends StatelessWidget {
  final SpaceSharingModel ride;
  final Function(String acceptedRideDocId, SpaceSharingModel ride) onCancel;
  final Future<String?> Function(String userId) getProfileImageUrl;

  const AcceptedRideCard({
    super.key,
    required this.ride,
    required this.onCancel,
    required this.getProfileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Driver's profile image
              FutureBuilder<String?>(
                future: getProfileImageUrl(ride.driverId),
                builder: (context, snapshot) {
                  return CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: snapshot.data != null
                        ? CachedNetworkImageProvider(snapshot.data!)
                        : null,
                    child: snapshot.data == null
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Driver: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0066CC), // Blue color
                          ),
                        ),
                        Text(
                          ride.driverName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Route: ${ride.departureCity} → ${ride.arrivalCity}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: "Departure: ",
                  style: TextStyle(
                    color: Color(0xFF0066CC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "${DateFormat('MMM dd, EEEE HH:mm').format(ride.departureDateTime)}\n"),
                TextSpan(
                  text: "Vehicle Number: ", // Corrected label
                  style: TextStyle(
                    color: Color(0xFF0066CC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "${ride.vehicleNumber} (${ride.vehicleType})\n"),
                TextSpan(
                  text: "Contact: ",
                  style: TextStyle(
                    color: Color(0xFF0066CC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "${ride.contactNumber}\n"),
                TextSpan(
                  text: "Booked Seats: ",
                  style: TextStyle(
                    color: Color(0xFF0066CC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "1\n"), // Assuming one seat booked per acceptance
                TextSpan(
                  text: "Cost per Seat: ",
                  style: TextStyle(
                    color: Color(0xFF0066CC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "PKR ${ride.costPerSeat.toStringAsFixed(2)}\n"),
                TextSpan(
                  text: "Total Cost: ",
                  style: TextStyle(
                    color: Color(0xFF0066CC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "PKR ${(ride.costPerSeat * 1).toStringAsFixed(2)}"), // Total cost for 1 booked seat
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Star ratings
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < 4 ? Icons.star : Icons.star_border, // Example: 4 stars filled
                color: Colors.amber,
                size: 20,
              );
            }),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => onCancel(ride.id, ride), // Pass acceptedRideDoc.id and ride object
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066CC), // Blue for cancel button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Cancel Ride",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper function to show a consistent SnackBar
void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: const Color(0xFF0066CC),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

// Helper function to show a consistent Success Dialog
Future<void> _showSuccessDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap button to dismiss
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Success!', style: TextStyle(color: Color(0xFF0066CC))),
        content: Text(message, style: const TextStyle(color: Colors.black87)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss dialog
            },
            child: const Text('OK', style: TextStyle(color: Color(0xFF0066CC))),
          ),
        ],
      );
    },
  );
}

// New Page for Ride History
class RideHistoryPage extends StatefulWidget {
  final User currentUser;
  final Future<String?> Function(String userId) getProfileImageUrl;

  const RideHistoryPage({
    super.key,
    required this.currentUser,
    required this.getProfileImageUrl,
  });

  @override
  State<RideHistoryPage> createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isMultiSelectMode = false;
  final Set<String> _selectedHistoryDocIds = {}; // Store acceptedSpaceSharings doc IDs

  void _toggleMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedHistoryDocIds.clear(); // Clear selection when exiting multi-select mode
      }
    });
  }

  void _toggleSelection(String docId) {
    setState(() {
      if (_selectedHistoryDocIds.contains(docId)) {
        _selectedHistoryDocIds.remove(docId);
      } else {
        _selectedHistoryDocIds.add(docId);
      }
    });
  }

  Future<void> _deleteSelectedHistoryRides() async {
    if (_selectedHistoryDocIds.isEmpty) {
      _showSnackBar(context, 'No rides selected for deletion.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Selected Rides', style: TextStyle(color: Color(0xFF0066CC))),
        content: Text('Are you sure you want to delete ${_selectedHistoryDocIds.length} selected ride(s) from history?', style: const TextStyle(color: Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF0066CC))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066CC),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context); // Dismiss dialog
              try {
                for (String docId in _selectedHistoryDocIds) {
                  await _firestore
                      .collection('users')
                      .doc(widget.currentUser.uid)
                      .collection('acceptedSpaceSharings')
                      .doc(docId)
                      .delete();
                }
                _showSnackBar(context, '${_selectedHistoryDocIds.length} ride(s) deleted from history.');
                setState(() {
                  _selectedHistoryDocIds.clear();
                  _isMultiSelectMode = false;
                });
              } catch (e) {
                print("Error deleting history rides: $e");
                _showSnackBar(context, 'Failed to delete history rides: $e');
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0066CC),
        title: const Text("Ride History", style: TextStyle(color: Colors.white)),
        elevation: 0,
        centerTitle: true, // Centered the title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (_isMultiSelectMode || _selectedHistoryDocIds.isNotEmpty) // Show delete icon if in multi-select or items are selected
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _deleteSelectedHistoryRides,
            )
          // Removed the "select all" icon from here
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(widget.currentUser.uid)
            .collection('acceptedSpaceSharings')
            .where('status', whereIn: ['cancelled', 'completed']) // Show cancelled and completed
            .orderBy('acceptedAt', descending: true) // Order by latest accepted/cancelled
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.history_toggle_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No ride history yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Completed and cancelled rides will appear here.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final historyDoc = snapshot.data!.docs[index];
              final originalSpaceSharingId = historyDoc['spaceSharingId'];
              final status = historyDoc['status'] as String;
              final refundAmount = (historyDoc['refundAmount'] as num?)?.toDouble();
              final refundAccountType = historyDoc['refundAccountType'] as String?;
              final refundAccountNumber = historyDoc['refundAccountNumber'] as String?;

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('SpaceSharings').doc(originalSpaceSharingId).get(),
                builder: (context, rideSnapshot) {
                  if (rideSnapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC))),
                      ),
                    );
                  }
                  if (rideSnapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Error loading ride details: ${rideSnapshot.error}', style: const TextStyle(color: Colors.red)),
                    );
                  }
                  if (!rideSnapshot.hasData || !rideSnapshot.data!.exists) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Original ride not found or deleted.',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Status: ${status.toUpperCase()}',
                              style: TextStyle(color: status == 'cancelled' ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
                            ),
                            if (status == 'cancelled' && refundAmount != null) ...[
                              const SizedBox(height: 4),
                              Text('Refund: PKR ${refundAmount?.toStringAsFixed(2) ?? '0.00'}', style: const TextStyle(color: Colors.black87)),
                              Text('To: $refundAccountType ($refundAccountNumber)', style: const TextStyle(color: Colors.black87)),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  final ride = SpaceSharingModel.fromDocument(rideSnapshot.data!);
                  return HistoryRideCard(
                    ride: ride,
                    status: status,
                    refundAmount: refundAmount,
                    refundAccountType: refundAccountType,
                    refundAccountNumber: refundAccountNumber,
                    getProfileImageUrl: widget.getProfileImageUrl,
                    isMultiSelectMode: _isMultiSelectMode,
                    isSelected: _selectedHistoryDocIds.contains(historyDoc.id),
                    onToggleSelection: () => _toggleSelection(historyDoc.id),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// New Card for Ride History Display
class HistoryRideCard extends StatelessWidget {
  final SpaceSharingModel ride;
  final String status;
  final double? refundAmount;
  final String? refundAccountType;
  final String? refundAccountNumber;
  final Future<String?> Function(String userId) getProfileImageUrl;
  final bool isMultiSelectMode; // New
  final bool isSelected; // New
  final VoidCallback onToggleSelection; // New

  const HistoryRideCard({
    super.key,
    required this.ride,
    required this.status,
    this.refundAmount,
    this.refundAccountType,
    this.refundAccountNumber,
    required this.getProfileImageUrl,
    this.isMultiSelectMode = false, // Default to false
    this.isSelected = false, // Default to false
    required this.onToggleSelection, // Required
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    if (status == 'completed') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status == 'cancelled') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.grey;
      statusIcon = Icons.info;
    }

    return GestureDetector(
      onLongPress: onToggleSelection, // Enable multi-selection on long press
      onTap: isMultiSelectMode ? onToggleSelection : null, // Toggle selection if in multi-select mode
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0066CC).withOpacity(0.2) : Colors.white, // Highlight if selected
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: const Color(0xFF0066CC), width: 2) : null, // Blue border if selected
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FutureBuilder<String?>(
                  future: getProfileImageUrl(ride.driverId),
                  builder: (context, snapshot) {
                    return CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: snapshot.data != null
                          ? CachedNetworkImageProvider(snapshot.data!)
                          : null,
                      child: snapshot.data == null
                          ? const Icon(Icons.person, color: Colors.grey)
                          : null,
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Driver: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0066CC), // Blue color
                            ),
                          ),
                          Text(
                            ride.driverName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Route: ${ride.departureCity} → ${ride.arrivalCity}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Removed the status icon from here
                if (isMultiSelectMode)
                  Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      onToggleSelection();
                    },
                    activeColor: const Color(0xFF0066CC),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: "Travel Date: ", // Corrected label
                    style: TextStyle(
                      color: Color(0xFF0066CC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: "${DateFormat('MMM dd, EEEE HH:mm').format(ride.departureDateTime)}\n"),
                  TextSpan(
                    text: "Vehicle Number: ", // Corrected label
                    style: TextStyle(
                      color: Color(0xFF0066CC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: "${ride.vehicleNumber} (${ride.vehicleType})\n"),
                  TextSpan(
                    text: "Contact: ",
                    style: TextStyle(
                      color: Color(0xFF0066CC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: "${ride.contactNumber}\n"),
                  TextSpan(
                    text: "Status: ",
                    style: TextStyle(
                      color: Color(0xFF0066CC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: status.toUpperCase()),
                ],
              ),
            ),
            Text(
              "Booked Seats: 1", // Assuming one seat booked per acceptance
              style: const TextStyle(
                color: Color(0xFF0066CC), // Blue color
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Cost per Seat: PKR ${ride.costPerSeat.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFF0066CC), // Blue color
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Total Cost: PKR ${(ride.costPerSeat * 1).toStringAsFixed(2)}', // Total cost for 1 booked seat
              style: const TextStyle(
                color: Color(0xFF0066CC), // Blue color
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Star ratings
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < 4 ? Icons.star : Icons.star_border, // Example: 4 stars filled
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            if (status == 'cancelled' && refundAmount != null) ...[
              const SizedBox(height: 8),
              Text(
                'Refund Amount: PKR ${refundAmount?.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Refunded to: $refundAccountType ($refundAccountNumber)',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
