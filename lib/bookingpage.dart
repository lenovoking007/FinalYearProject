import 'package:flutter/material.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  String selectedService = 'Hotel Room';
  String selectedDate = '2025-01-15';
  String selectedTime = '12:00 PM';
  String selectedGuests = '1';

  final List<String> services = ['Hotel Room', 'Flight', 'Restaurant', 'Spa'];
  final List<String> times = ['12:00 PM', '2:00 PM', '4:00 PM', '6:00 PM'];
  final List<String> guests = ['1', '2', '3', '4', '5', '6'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Bookings",
          style: TextStyle(
            color: Color(0XFF0066CC),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0XFF0066CC)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          children: [
            _buildBookingOption("Select Service", services, selectedService,
                    (value) {
                  setState(() {
                    selectedService = value!;
                  });
                }),
            const SizedBox(height: 12),
            _buildBookingOption("Select Date", [], selectedDate, (value) {
              setState(() {
                selectedDate = value!;
              });
            }, isDatePicker: true),
            const SizedBox(height: 12),
            _buildBookingOption("Select Time", times, selectedTime, (value) {
              setState(() {
                selectedTime = value!;
              });
            }),
            const SizedBox(height: 12),
            _buildBookingOption("Select Guests", guests, selectedGuests,
                    (value) {
                  setState(() {
                    selectedGuests = value!;
                  });
                }),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showBookingConfirmation(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF0066CC),
                minimumSize: const Size(294.57, 43.24),
              ),
              child: const Text(
                "Confirm Booking",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a dropdown or date picker for selecting booking options
  Widget _buildBookingOption(
      String label,
      List<String> options,
      String selectedValue,
      ValueChanged<String?> onChanged, {
        bool isDatePicker = false,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          Icons.calendar_today,
          color: const Color(0XFF0066CC),
        ),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: isDatePicker
            ? GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2101),
            );
            if (picked != null && picked != DateTime.now()) {
              setState(() {
                selectedDate = "${picked.year}-${picked.month}-${picked.day}";
              });
            }
          },
          child: Text(
            selectedDate,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        )
            : DropdownButton<String>(
          isExpanded: true,
          value: selectedValue,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Color(0XFF0066CC)),
          underline: Container(
            height: 2,
            color: Color(0XFF0066CC),
          ),
          onChanged: onChanged,
          items: options
              .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ))
              .toList(),
        ),
      ),
    );
  }

  // Booking Confirmation Popup
  void _showBookingConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Booking Confirmed!",
            style: TextStyle(color: Color(0XFF0066CC)),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Service: $selectedService"),
              Text("Date: $selectedDate"),
              Text("Time: $selectedTime"),
              Text("Guests: $selectedGuests"),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Your booking is confirmed!"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF0066CC),
              ),
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
