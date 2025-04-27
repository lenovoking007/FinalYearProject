import 'package:flutter/material.dart';
import 'package:travelmate/chat.dart';

class TravelBuddyPage extends StatelessWidget {
  const TravelBuddyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0066CC),
          elevation: 0,
          title: const Text(
            "Travel Buddy",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Buddies"),
              Tab(text: "Requests"),
              Tab(text: "Suggested Buddies"),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: const TabBarView(
          children: [
            // Buddies Tab
            BuddiesTab(),

            // Requests Tab
            RequestsTab(),

            // Suggested Buddies Tab
            SuggestedBuddiesTab(),
          ],
        ),
      ),
    );
  }
}

class BuddiesTab extends StatelessWidget {
  const BuddiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Buddies",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0066CC),
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(
            4,
                (index) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/pic${index + 1}.png'), // Updated profile images
                    radius: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ['Adil Bhutta', 'Ahmad Shahi', 'Muhammad Arif', 'Khurram Mustafa'][index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigate to chat screen when message icon is clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AhmadShahiChatPage()),
                      );
                    },
                    icon: const Icon(Icons.message),
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066CC),
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "See more",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class RequestsTab extends StatelessWidget {
  const RequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: List.generate(
          4,
              (index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/pic${index + 1}.png'), // Updated profile images
                  radius: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ['Ali Asghar', 'Saleem Khan', 'Omer Tariq', 'Farhan Ali'][index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Friendly and active user who loves to travel.",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.cancel, color: Color(0xFF0066CC)), // Changed to blue
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066CC), // Blue color
                        minimumSize: const Size(100, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(fontSize: 12, color: Colors.white),
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
  }
}

class SuggestedBuddiesTab extends StatelessWidget {
  const SuggestedBuddiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: List.generate(
          4,
              (index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/pic${index + 1}.png'), // Updated profile images
                  radius: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ['Usman Ali', 'Nadeem Ali', 'Hassan Raza', 'Sadam Iqbal'][index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Adventurous and loves exploring new cultures.",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.cancel, color: Color(0xFF0066CC)), // Changed to blue
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066CC), // Blue color
                        minimumSize: const Size(100, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Add Buddy",
                        style: TextStyle(fontSize: 12, color: Colors.white),
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
  }
}


