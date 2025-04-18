import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travelmate/chat.dart';
import 'package:travelmate/homepage.dart';
import 'package:travelmate/settingmenu.dart';
import 'package:travelmate/tools.dart';
import 'package:travelmate/tripprogresspage.dart';

class TripPage extends StatefulWidget {
  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  int _selectedIndex = 2;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String? _selectedCity;
  final List<String> cities = [
    'Karachi',
    'Lahore',
    'Islamabad',
    'Peshawar',
    'Quetta',
    'Multan',
    'Faisalabad',
    'Sialkot',
    'Gwadar',
    'Skardu'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Tools()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TripPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MessagePage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsMenuPage()),
        );
        break;
    }
  }

  void _showTripPlanDialog() {
    TextEditingController tripNameController = TextEditingController();
    String? _selectedTripType;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Plan Your Trip",
            style: TextStyle(color: Color(0XFF0066CC)),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEditableTextField("Trip Name", tripNameController, Icons.title),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _selectedTripType,
                  hint: const Text('Select Trip Type'),
                  items: ['Adventure', 'Relaxation', 'Cultural', 'Wildlife'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTripType = value;
                    });
                  },
                ),
                const SizedBox(height: 14),
                _buildEditableTextField("Number of People", TextEditingController(), Icons.people),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (picked != null) {
                      setState(() {
                        _startDate = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Start Date'),
                    child: Text("${_startDate.toLocal()}".split(' ')[0]),
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate: _startDate,
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (picked != null) {
                      setState(() {
                        _endDate = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'End Date'),
                    child: Text("${_endDate.toLocal()}".split(' ')[0]),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without saving
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color(0XFF0066CC)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Logic to save trip details
                Navigator.pop(context); // Close the dialog after saving
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Trip plan saved successfully!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF0066CC),
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showBudgetCalculatorDialog() {
    String? _selectedTripType;
    TextEditingController budgetController = TextEditingController();
    TextEditingController numberOfPeopleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "AI Budget Trip Calculator",
            style: TextStyle(color: Color(0XFF0066CC)),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedTripType,
                  hint: const Text('Select Trip Type'),
                  items: ['Adventure', 'Relaxation', 'Cultural', 'Wildlife'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTripType = value;
                    });
                  },
                ),
                const SizedBox(height: 14),
                _buildEditableTextField("Budget", budgetController, Icons.monetization_on),
                const SizedBox(height: 14),
                _buildEditableTextField("Number of People", numberOfPeopleController, Icons.people),
                const SizedBox(height: 14),
                // Add more fields as required
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without searching
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color(0XFF0066CC)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform search logic
                Navigator.pop(context); // Close the dialog after performing search
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Searching for trips...")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF0066CC),
              ),
              child: const Text(
                "Search",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, color: Colors.white),
      label: Text(label),
      backgroundColor: const Color(0xFF0066CC),
      labelStyle: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for trips...',
                    prefixIcon: const Icon(Icons.search, color: Color(0XFF0066CC)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/pro.jpg'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0XFF0066CC)),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildCategoryChip('Nature', Icons.nature),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Relax', Icons.spa),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Adventure', Icons.terrain),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Yoga', Icons.self_improvement),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Swimming', Icons.pool),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Featured Destinations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0XFF0066CC)),
              ),
            ),
            CarouselSlider(
              items: [
                _buildImageCard('Karachi', 'assets/images/karachi.jpg'),
                _buildImageCard('Lahore', 'assets/images/lahore.jpg'),
                _buildImageCard('Islamabad', 'assets/images/islamabad.jpg'),
              ],
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                aspectRatio: 2.0,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Explore More Amazing Destinations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0XFF0066CC)),
              ),
            ),
            CarouselSlider(
              items: [
                _buildImageCard('Quetta', 'assets/images/que.png'),
                _buildImageCard('Peshawar', 'assets/images/pesh.jpg'),
                _buildImageCard('Multan', 'assets/images/mul.jpg'),
              ],
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                aspectRatio: 2.0,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF0066CC), // Blue background
                      minimumSize: const Size(250, 40), // Decreased width
                    ),
                    onPressed: _showTripPlanDialog,
                    icon: const Icon(Icons.map, color: Colors.white),
                    label: const Text(
                      'Plan Trip',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF0066CC), // Blue background
                      minimumSize: const Size(250, 40), // Decreased width
                    ),
                    onPressed: _showBudgetCalculatorDialog,
                    icon: const Icon(Icons.calculate, color: Colors.white),
                    label: const Text(
                      'AI Budget Trip Calculator',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF0066CC), // Blue background
                      minimumSize: const Size(250, 40), // Decreased width
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TripStatusPage()),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: const Text(
                      'Trip Status',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0XFF0066CC),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildImageCard(String title, String imagePath) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0XFF88F2E8).withOpacity(0.1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0XFF0066CC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.green),
          ),
          hintText: label,
          hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
          suffixIcon: Icon(
            icon,
            size: 24,
            color: const Color(0XFF0066CC),
          ),
        ),
      ),
    );
  }
}