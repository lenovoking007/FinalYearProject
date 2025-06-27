import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:async'; // Import for Timer
import 'package:firebase_storage/firebase_storage.dart'; // Import for Firebase Storage
import 'package:cached_network_image/cached_network_image.dart'; // Import for CachedNetworkImage

enum BuddyStatus {
  buddy,
  requestSent,
  requestReceived,
  blocked,
  unknown,
}

class TravelBuddy extends StatefulWidget {
  @override
  _TravelBuddyState createState() => _TravelBuddyState();
}

class _TravelBuddyState extends State<TravelBuddy> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance; // Added Firebase Storage
  late User _currentUser;
  late TabController _tabController;
  bool _isInitialPageLoading = true; // State for initial full-page loading

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this); // Add observer for app lifecycle
    _updateUserPresence(true); // Set user online on app start

    // Listen to the buddies stream to determine when initial data is loaded
    _firestore
        .collection('users')
        .doc(_currentUser.uid)
        .collection('buddies')
        .snapshots()
        .listen((snapshot) {
      if (_isInitialPageLoading && snapshot.docs.isNotEmpty || snapshot.docs.isEmpty) { // If data is available (even empty) or if it confirms empty
        setState(() {
          _isInitialPageLoading = false;
        });
      }
    }, onError: (error) {
      print("Error listening to initial buddies stream: $error");
      setState(() {
        _isInitialPageLoading = false; // Stop loading even on error
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateUserPresence(true); // User came back to the app
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _updateUserPresence(false); // User left the app
    }
  }

  // Update user's presence (isOnline, lastSeen)
  Future<void> _updateUserPresence(bool isOnline) async {
    try {
      await _firestore.collection('users').doc(_currentUser.uid).set({
        'lastSeen': FieldValue.serverTimestamp(),
        'isOnline': isOnline,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error updating user presence: $e");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    _updateUserPresence(false); // Set user offline on app dispose
    super.dispose();
  }

  // Function to get user profile image URL
  Future<String?> _getProfileImageUrl(String userId) async {
    try {
      final url = await _storage.ref('profile_images/$userId').getDownloadURL();
      return url;
    } catch (e) {
      // If no profile image exists, return null to indicate default image
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0066CC),
        elevation: 0,
        title: const Text('Travel Buddy', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFriendPage()),
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
            Tab(text: 'Buddies'),
            Tab(text: 'Requests'),
            Tab(text: 'Blocked'),
          ],
        ),
      ),
      body: _isInitialPageLoading
          ? const Center( // Full-page loading indicator
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
        ),
      )
          : TabBarView(
        controller: _tabController,
        children: [
          _buildBuddiesTab(),
          _buildRequestsTab(),
          _buildBlockedUsersTab(),
        ],
      ),
    );
  }

  Widget _buildBuddiesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .collection('buddies')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // CircularProgressIndicator for loading the tab's data
          return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
              ));
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading buddies: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
          );
        }

        final buddies = snapshot.data!.docs;

        if (buddies.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.group, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No buddies yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Add friends to start chatting',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: buddies.length,
          itemBuilder: (context, index) {
            return _buildBuddyCard(buddies[index]);
          },
        );
      },
    );
  }

  Widget _buildBuddyCard(DocumentSnapshot buddy) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getBuddyCardData(buddy.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a simplified loading state for individual cards while data is being fetched
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: const Color(0xFF0066CC).withOpacity(0.5)),
            ),
            elevation: 4,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)), strokeWidth: 2),
                  SizedBox(width: 16),
                  Text('Loading buddy info...'),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.red[50], // Light red background for error
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.red),
            ),
            elevation: 4,
            child: const ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Icon(Icons.error_outline, color: Colors.red),
              title: Text('Error loading buddy data', style: TextStyle(color: Colors.red)),
              subtitle: Text('Please try again later.'),
            ),
          );
        }

        final data = snapshot.data!;
        final userData = data['userData'] as Map<String, dynamic>;
        final unreadCount = data['unreadCount'] as int;
        final lastMessage = data['lastMessage'] as String;
        final lastMessageTime = data['lastMessageTime'] as String;
        final isBlocked = data['isBlocked'] as bool; // Combined blocked status
        final isOnline = userData['isOnline'] ?? false; // Get online status
        // final lastSeen = userData['lastSeen']?.toDate(); // Get last seen timestamp

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white, // Always white background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: const Color(0xFF0066CC).withOpacity(0.5)), // Blue border
          ),
          elevation: 4, // Increased shadow
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: Stack(
              children: [
                ClipOval( // Ensures the image is clipped to a circle
                  child: SizedBox(
                    width: 48, // 24 radius * 2
                    height: 48, // 24 radius * 2
                    child: FutureBuilder<String?>(
                      future: _getProfileImageUrl(buddy.id), // Fetch profile image URL
                      builder: (context, avatarSnapshot) {
                        // CachedNetworkImage handles its own placeholders and error widgets efficiently
                        return CachedNetworkImage(
                          imageUrl: avatarSnapshot.data ?? '', // Provide empty string if data is null to let errorWidget handle
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/circleimage.png', // Default image on error
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.greenAccent : Colors.grey, // Green for online, grey for offline
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              userData['name'] ?? 'Unknown',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isBlocked ? Colors.grey[600] : null, // Grey text if blocked
              ),
            ),
            subtitle: isBlocked
                ? const Text(
              'Blocked User',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            )
                : Text(
              lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isBlocked && unreadCount > 0) // Show unread count only if not blocked and > 0
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0066CC),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(width: (!isBlocked && unreadCount > 0) ? 8 : 0),
                if (!isBlocked) // Show time only if not blocked
                  Text(
                    lastMessageTime,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: isBlocked ? Colors.grey : const Color(0xFF0066CC)),
                  onSelected: (value) {
                    if (value == 'remove') {
                      _removeBuddy(buddy.id, userData['name'] ?? 'Unknown');
                    } else if (value == 'block') {
                      _blockUser(buddy.id, userData['name'] ?? 'Unknown');
                    } else if (value == 'unblock') {
                      _unblockUser(buddy.id, userData['name'] ?? 'Unknown');
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.person_remove, color: Color(0xFF0066CC)),
                            SizedBox(width: 8),
                            Text('Remove Buddy'),
                          ],
                        ),
                      ),
                      if (!isBlocked) // Show block option if not already blocked
                        const PopupMenuItem<String>(
                          value: 'block',
                          child: Row(
                            children: [
                              Icon(Icons.block, color: Color(0xFF0066CC)),
                              SizedBox(width: 8),
                              Text('Block User'),
                            ],
                          ),
                        )
                      else // Show unblock option if blocked
                        const PopupMenuItem<String>(
                          value: 'unblock',
                          child: Row(
                            children: [
                              Icon(Icons.lock_open, color: Color(0xFF0066CC)),
                              SizedBox(width: 8),
                              Text('Unblock User'),
                            ],
                          ),
                        ),
                    ];
                  },
                ),
              ],
            ),
            onTap: isBlocked ? null : () => _openChat(userData, buddy.id), // Disable tap if blocked
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getBuddyCardData(String buddyId) async {
    final currentUser = _auth.currentUser!;
    final chatId = _getChatId(currentUser.uid, buddyId);

    // Fetch user data
    final userDoc = await _firestore.collection('users').doc(buddyId).get();
    final userData = userDoc.data() as Map<String, dynamic>;

    // Fetch chat data for last message and time
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    String lastMessage = "Tap to chat";
    String lastMessageTime = "";
    if (chatDoc.exists) {
      final chatData = chatDoc.data() as Map<String, dynamic>;
      lastMessage = chatData['lastMessage'] ?? "Tap to chat";
      final timestamp = chatData['lastMessageTime'] as Timestamp?;
      if (timestamp != null) {
        lastMessageTime = _formatTime(timestamp.toDate());
      }
    }

    // Get unread message count
    final unreadSnapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('receiverId', isEqualTo: currentUser.uid)
        .where('isRead', isEqualTo: false)
        .get();
    final unreadCount = unreadSnapshot.docs.length;

    // Check if current user blocked buddy OR if buddy blocked current user
    final blockedByMe = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('blocked')
        .doc(buddyId)
        .get()
        .then((doc) => doc.exists);

    final blockedByBuddy = await _firestore
        .collection('users')
        .doc(buddyId)
        .collection('blocked')
        .doc(currentUser.uid)
        .get()
        .then((doc) => doc.exists);

    final isBlocked = blockedByMe || blockedByBuddy;

    return {
      'userData': userData,
      'unreadCount': unreadCount,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'isBlocked': isBlocked,
    };
  }

  Widget _buildRequestsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .collection('receivedRequests')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // CircularProgressIndicator for loading the tab's data
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading requests: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
          );
        }

        final requests = snapshot.data!.docs;

        if (requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.group_add, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No pending requests',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Friend requests will appear here',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return _buildRequestCard(requests[index]);
          },
        );
      },
    );
  }

  Widget _buildRequestCard(DocumentSnapshot request) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(request.id).get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: const Color(0xFF0066CC).withOpacity(0.5)),
            ),
            elevation: 2,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)), strokeWidth: 2),
                  SizedBox(width: 16),
                  Text('Loading request info...'),
                ],
              ),
            ),
          );
        }

        if (userSnapshot.hasError) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.red[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.red),
            ),
            elevation: 2,
            child: const ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Icon(Icons.error_outline, color: Colors.red),
              title: Text('Error loading request data', style: TextStyle(color: Colors.red)),
              subtitle: Text('Please try again later.'),
            ),
          );
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white, // Explicitly set card background to white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: const Color(0xFF0066CC).withOpacity(0.5)), // Subtle border
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 56, // 28 radius * 2
                        height: 56, // 28 radius * 2
                        child: FutureBuilder<String?>(
                          future: _getProfileImageUrl(request.id), // Fetch profile image
                          builder: (context, avatarSnapshot) {
                            return CachedNetworkImage(
                              imageUrl: avatarSnapshot.data ?? '',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/circleimage.png', // Default image on error
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userData['phone'] ?? '',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0066CC),
                        side: const BorderSide(color: Color(0xFF0066CC)), // Blue border
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _rejectRequest(request.id),
                      child: const Text('Decline'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066CC),
                        foregroundColor: Colors.white, // White text
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _acceptRequest(request.id),
                      child: const Text('Accept'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildBlockedUsersTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .collection('blocked')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // CircularProgressIndicator for loading the tab's data
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading blocked users: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
          );
        }

        final blockedUsers = snapshot.data!.docs;

        if (blockedUsers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.block, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No blocked users',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Blocked users will appear here',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: blockedUsers.length,
          itemBuilder: (context, index) {
            return _buildBlockedUserCard(blockedUsers[index]);
          },
        );
      },
    );
  }

  Widget _buildBlockedUserCard(DocumentSnapshot blockedUser) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(blockedUser.id).get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.grey[100],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Adjusted padding
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
                ),
              ),
            ),
          );

        }

        if (userSnapshot.hasError) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            color: Colors.red[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.red),
            ),
            elevation: 0,
            child: const ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Icon(Icons.error_outline, color: Colors.red),
              title: Text('Error loading user data', style: TextStyle(color: Colors.red)),
              subtitle: Text('Please try again later.'),
            ),
          );
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: Colors.grey[100],
            leading: ClipOval(
              child: SizedBox(
                width: 48, // 24 radius * 2
                height: 48, // 24 radius * 2
                child: FutureBuilder<String?>(
                  future: _getProfileImageUrl(blockedUser.id), // Fetch profile image
                  builder: (context, avatarSnapshot) {
                    return CachedNetworkImage(
                      imageUrl: avatarSnapshot.data ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/circleimage.png', // Default image on error
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
            title: Text(
              userData['name'] ?? 'Unknown',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              userData['phone'] ?? '',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: TextButton(
              onPressed: () => _unblockUser(blockedUser.id, userData['name'] ?? 'Unknown'),
              child: const Text(
                'Unblock',
                style: TextStyle(color: Color(0xFF0066CC)),
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper methods
  String _getChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode
        ? '$uid1-$uid2'
        : '$uid2-$uid1';
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(date);
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MM/dd').format(date);
    }
  }

  // Firebase operations
  Future<void> _sendBuddyRequest(String peerId) async {
    final currentUser = _auth.currentUser!;

    try {
      // Check if the current user is blocked by the peer
      final peerBlockedCurrentUser = await _firestore
          .collection('users')
          .doc(peerId)
          .collection('blocked')
          .doc(currentUser.uid)
          .get();

      if (peerBlockedCurrentUser.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You cannot send a friend request to this user because they have blocked you.")),
        );
        return;
      }

      // Add to recipient's received requests
      await _firestore
          .collection('users')
          .doc(peerId)
          .collection('receivedRequests')
          .doc(_currentUser.uid)
          .set({
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Add to sender's sent requests
      await _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .collection('sentRequests')
          .doc(peerId)
          .set({
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Friend request sent")));
    } catch (e) {
      print("Error sending buddy request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send friend request. Please try again.")),
      );
    }
  }

  Future<void> _acceptRequest(String requesterId) async {
    try {
      // Remove from requests
      await _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .collection('receivedRequests')
          .doc(requesterId)
          .delete();

      await _firestore
          .collection('users')
          .doc(requesterId)
          .collection('sentRequests')
          .doc(_currentUser.uid)
          .delete();

      // Add to buddies for both users
      final batch = _firestore.batch();

      final currentUserBuddyRef = _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .collection('buddies')
          .doc(requesterId);
      batch.set(currentUserBuddyRef, {
        'timestamp': FieldValue.serverTimestamp(),
      });

      final peerBuddyRef = _firestore
          .collection('users')
          .doc(requesterId)
          .collection('buddies')
          .doc(_currentUser.uid);
      batch.set(peerBuddyRef, {
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Create a chat document if it doesn't exist
      final chatId = _getChatId(_currentUser.uid, requesterId);
      final chatRef = _firestore.collection('chats').doc(chatId);
      batch.set(chatRef, {
        'participants': [_currentUser.uid, requesterId],
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You are now buddies!")));
    } catch (e) {
      print("Error accepting request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to accept request. Please try again.")),
      );
    }
  }

  Future<void> _rejectRequest(String requesterId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .collection('receivedRequests')
          .doc(requesterId)
          .delete();

      await _firestore
          .collection('users')
          .doc(requesterId)
          .collection('sentRequests')
          .doc(_currentUser.uid)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Request declined")));
    } catch (e) {
      print("Error rejecting request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to decline request. Please try again.")),
      );
    }
  }

  Future<void> _removeBuddy(String buddyId, String buddyName) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Buddy'),
        content: Text('Are you sure you want to remove $buddyName from your buddies?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF0066CC))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066CC),
              foregroundColor: Colors.white, // Text color for the button
            ),
            onPressed: () async {
              Navigator.pop(context);
              try {
                // Remove from both users' buddy lists
                await _firestore
                    .collection('users')
                    .doc(_currentUser.uid)
                    .collection('buddies')
                    .doc(buddyId)
                    .delete();

                await _firestore
                    .collection('users')
                    .doc(buddyId)
                    .collection('buddies')
                    .doc(_currentUser.uid)
                    .delete();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buddy removed successfully')),
                );
              } catch (e) {
                print("Error removing buddy: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to remove buddy. Please try again.")),
                );
              }
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Future<void> _blockUser(String userId, String userName) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text('Are you sure you want to block $userName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF0066CC))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066CC),
              foregroundColor: Colors.white, // Text color for the button
            ),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _firestore
                    .collection('users')
                    .doc(_currentUser.uid)
                    .collection('blocked')
                    .doc(userId)
                    .set({
                  'timestamp': FieldValue.serverTimestamp(),
                });

                // Remove from buddies if they were buddies
                await _firestore
                    .collection('users')
                    .doc(_currentUser.uid)
                    .collection('buddies')
                    .doc(userId)
                    .delete();

                // Remove from the other user's buddies list
                await _firestore
                    .collection('users')
                    .doc(userId)
                    .collection('buddies')
                    .doc(_currentUser.uid)
                    .delete();

                // Remove any pending requests
                await _firestore
                    .collection('users')
                    .doc(_currentUser.uid)
                    .collection('receivedRequests')
                    .doc(userId)
                    .delete();

                await _firestore
                    .collection('users')
                    .doc(_currentUser.uid)
                    .collection('sentRequests')
                    .doc(userId)
                    .delete();

                await _firestore
                    .collection('users')
                    .doc(userId)
                    .collection('receivedRequests')
                    .doc(_currentUser.uid)
                    .delete();

                await _firestore
                    .collection('users')
                    .doc(userId)
                    .collection('sentRequests')
                    .doc(_currentUser.uid)
                    .delete();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User blocked successfully')),
                );
              } catch (e) {
                print("Error blocking user: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to block user. Please try again.")),
                );
              }
            },
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  Future<void> _unblockUser(String userId, String userName) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unblock User'),
        content: Text('Are you sure you want to unblock $userName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF0066CC))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066CC),
              foregroundColor: Colors.white, // Text color for the button
            ),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _firestore
                    .collection('users')
                    .doc(_currentUser.uid)
                    .collection('blocked')
                    .doc(userId)
                    .delete();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User unblocked successfully')),
                );
              } catch (e) {
                print("Error unblocking user: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to unblock user. Please try again.")),
                );
              }
            },
            child: const Text('Unblock'),
          ),
        ],
      ),
    );
  }

  Future<void> _openChat(Map<String, dynamic> userData, String peerId) async {
    // Check if user is blocked by current user
    final isBlockedByMe = await _firestore
        .collection('users')
        .doc(_currentUser.uid)
        .collection('blocked')
        .doc(peerId)
        .get()
        .then((doc) => doc.exists);

    if (isBlockedByMe) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have blocked this user')),
      );
      return;
    }

    // Check if current user is blocked by peer
    final isBlockedByPeer = await _firestore
        .collection('users')
        .doc(peerId)
        .collection('blocked')
        .doc(_currentUser.uid)
        .get()
        .then((doc) => doc.exists);

    if (isBlockedByPeer) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This user has blocked you')),
      );
      return;
    }


    // Check if they are buddies
    final isBuddy = await _firestore
        .collection('users')
        .doc(_currentUser.uid)
        .collection('buddies')
        .doc(peerId)
        .get()
        .then((doc) => doc.exists);

    if (!isBuddy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be buddies to chat')),
      );
      return;
    }

    // Fetch peer's profile image for chat page
    final peerAvatarUrl = await _getProfileImageUrl(peerId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          peerId: peerId,
          peerName: userData['name'] ?? 'Unknown',
          peerAvatar: peerAvatarUrl ?? 'assets/images/circleimage.png', // Pass fetched URL or default
        ),
      ),
    );
  }
}

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance; // Added Firebase Storage
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounce; // Debounce timer

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // Cancel the timer on dispose
    super.dispose();
  }

  // Function to get user profile image URL
  Future<String?> _getProfileImageUrl(String userId) async {
    try {
      final url = await _storage.ref('profile_images/$userId').getDownloadURL();
      return url;
    } catch (e) {
      // If no profile image exists, return null to indicate default image
      return null;
    }
  }

  // --- Duplicated methods from _TravelBuddyState for AddFriendPage functionality ---
  // These methods are needed here so AddFriendPage can directly interact with Firebase
  // for sending/accepting requests and unblocking, without needing a GlobalKey or complex callbacks.

  Future<BuddyStatus> _isBuddyOrPending(String userId) async {
    final currentUser = _auth.currentUser!;

    try {
      // Check if searched user has blocked the current user
      final blockedMeDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('blocked')
          .doc(currentUser.uid)
          .get();

      if (blockedMeDoc.exists) return BuddyStatus.blocked; // If they blocked me, I can't interact

      // Check if current user has blocked the searched user
      final blockedDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('blocked')
          .doc(userId)
          .get();

      if (blockedDoc.exists) return BuddyStatus.blocked;


      // Check if already buddies
      final buddyDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('buddies')
          .doc(userId)
          .get();

      if (buddyDoc.exists) return BuddyStatus.buddy;

      // Check if request already sent
      final sentRequest = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('sentRequests')
          .doc(userId)
          .get();

      if (sentRequest.exists) return BuddyStatus.requestSent;

      // Check if request received
      final receivedRequest = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('receivedRequests')
          .doc(userId)
          .get();

      if (receivedRequest.exists) return BuddyStatus.requestReceived;

      return BuddyStatus.unknown;
    } catch (e) {
      print("Error checking buddy status in AddFriendPage: $e");
      return BuddyStatus.unknown; // Default to unknown on error
    }
  }

  Future<void> _sendBuddyRequest(String peerId) async {
    final currentUser = _auth.currentUser!;

    try {
      // Check if current user has blocked the peer
      final isBlockedByMe = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('blocked')
          .doc(peerId)
          .get()
          .then((doc) => doc.exists);

      if (isBlockedByMe) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have blocked this user. Unblock them to send a request.')),
        );
        return;
      }

      // Check if the peer has blocked the current user
      final isBlockedByPeer = await _firestore
          .collection('users')
          .doc(peerId)
          .collection('blocked')
          .doc(currentUser.uid)
          .get()
          .then((doc) => doc.exists);

      if (isBlockedByPeer) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This user has blocked you. You cannot send them a request.')),
        );
        return;
      }

      // Add to recipient's received requests
      await _firestore
          .collection('users')
          .doc(peerId)
          .collection('receivedRequests')
          .doc(currentUser.uid)
          .set({
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Add to sender's sent requests
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('sentRequests')
          .doc(peerId)
          .set({
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Friend request sent")));
      // Refresh the UI to reflect the "Request sent" status
      setState(() {});
    } catch (e) {
      print("Error sending buddy request in AddFriendPage: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send friend request. Please try again.")),
      );
    }
  }

  Future<void> _acceptRequest(String requesterId) async {
    final currentUser = _auth.currentUser!;

    try {
      // Remove from requests
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('receivedRequests')
          .doc(requesterId)
          .delete();

      await _firestore
          .collection('users')
          .doc(requesterId)
          .collection('sentRequests')
          .doc(currentUser.uid)
          .delete();

      // Add to buddies for both users
      final batch = _firestore.batch();

      final currentUserBuddyRef = _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('buddies')
          .doc(requesterId);
      batch.set(currentUserBuddyRef, {
        'timestamp': FieldValue.serverTimestamp(),
      });

      final peerBuddyRef = _firestore
          .collection('users')
          .doc(requesterId)
          .collection('buddies')
          .doc(currentUser.uid);
      batch.set(peerBuddyRef, {
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Create a chat document if it doesn't exist
      final chatId = '${currentUser.uid.hashCode <= requesterId.hashCode ? '${currentUser.uid}-$requesterId' : '$requesterId-${currentUser.uid}'}';
      final chatRef = _firestore.collection('chats').doc(chatId);
      batch.set(chatRef, {
        'participants': [currentUser.uid, requesterId],
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You are now buddies!")));
      // Refresh the UI to reflect the "Already buddies" status or remove from results
      setState(() {
        _searchResults.removeWhere((doc) => doc.id == requesterId);
      });
    } catch (e) {
      print("Error accepting request in AddFriendPage: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to accept request. Please try again.")),
      );
    }
  }

  Future<void> _unblockUser(String userId, String userName) async {
    final currentUser = _auth.currentUser!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unblock User'),
        content: Text('Are you sure you want to unblock $userName?'),
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
              Navigator.pop(context);
              try {
                await _firestore
                    .collection('users')
                    .doc(currentUser.uid)
                    .collection('blocked')
                    .doc(userId)
                    .delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User unblocked successfully")),
                );
                // Refresh the UI to reflect the "Add" status
                setState(() {});
              } catch (e) {
                print("Error unblocking user in AddFriendPage: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to unblock user. Please try again.")),
                );
              }
            },
            child: const Text('Unblock'),
          ),
        ],
      ),
    );
  }
  // --- End of duplicated methods ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0066CC),
        title: const Text('Add Friend', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0066CC)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0066CC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0066CC), width: 2),
                ),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  _searchUsers(value);
                });
              },
            ),
            const SizedBox(height: 16),
            _isSearching
                ? const Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
            ))
                : _searchResults.isEmpty && _searchController.text.isNotEmpty
                ? Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No user found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Try a different phone number',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
                : _searchResults.isEmpty && _searchController.text.isEmpty
                ? Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.group_add, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Search for friends',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Enter a phone number to find friends',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final user = _searchResults[index];
                  final userData = user.data() as Map<String, dynamic>;
                  return _buildUserCard(user.id, userData);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final currentUser = _auth.currentUser!;

    try {
      // Get list of blocked user IDs by current user
      final blockedByCurrentUserSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('blocked')
          .get();
      final blockedByCurrentUserIds = blockedByCurrentUserSnapshot.docs.map((doc) => doc.id).toSet();

      String normalizedQuery = query.replaceAll(RegExp(r'[^0-9]'), '');

      List<String> searchCandidates = [];
      searchCandidates.add(query); // Original input
      searchCandidates.add(normalizedQuery); // Digits only

      // Add common Pakistani number format variations
      if (normalizedQuery.startsWith('0') && normalizedQuery.length >= 10) {
        searchCandidates.add('+92${normalizedQuery.substring(1)}');
        searchCandidates.add('92${normalizedQuery.substring(1)}');
      } else if (normalizedQuery.startsWith('92') && normalizedQuery.length >= 11) {
        searchCandidates.add('+${normalizedQuery}');
        searchCandidates.add('0${normalizedQuery.substring(2)}');
      } else if (normalizedQuery.startsWith('+92') && normalizedQuery.length >= 12) {
        searchCandidates.add('0${normalizedQuery.substring(3)}');
        searchCandidates.add(normalizedQuery.substring(1));
      } else if (normalizedQuery.length >= 10) {
        searchCandidates.add(normalizedQuery.substring(normalizedQuery.length - 10)); // Last 10 digits
        searchCandidates.add('0${normalizedQuery.substring(normalizedQuery.length - 10)}'); // With leading 0
        searchCandidates.add('+92${normalizedQuery.substring(normalizedQuery.length - 10)}'); // With +92
      }

      searchCandidates = searchCandidates.toSet().take(10).toList(); // Ensure unique and limit to 10 for `whereIn`

      List<DocumentSnapshot> tempResults = [];

      for (String candidate in searchCandidates) {
        final snapshot = await _firestore
            .collection('users')
            .where('phone', isEqualTo: candidate)
            .get();

        for (var doc in snapshot.docs) {
          // 1. Exclude current user
          if (doc.id == currentUser.uid) {
            continue;
          }
          // 2. Exclude users blocked by current user
          if (blockedByCurrentUserIds.contains(doc.id)) {
            continue;
          }
          // 3. Exclude users who have blocked the current user
          final hasBlockedCurrentUser = await _firestore
              .collection('users')
              .doc(doc.id)
              .collection('blocked')
              .doc(currentUser.uid)
              .get()
              .then((blockDoc) => blockDoc.exists);

          if (hasBlockedCurrentUser) {
            continue;
          }

          // Add if not already in tempResults (avoid duplicates from different formats)
          if (!tempResults.any((element) => element.id == doc.id)) {
            tempResults.add(doc);
          }
        }
      }

      setState(() {
        _searchResults = tempResults;
        _isSearching = false;
      });
    } catch (e) {
      print('Error searching users: $e');
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error searching for users. Please try again.')),
      );
    }
  }


  Widget _buildUserCard(String userId, Map<String, dynamic> userData) {
    return FutureBuilder<BuddyStatus>(
      future: _isBuddyOrPending(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)), strokeWidth: 2),
                  SizedBox(width: 16),
                  Text('Loading user status...'),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.red[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.red),
            ),
            child: const ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Icon(Icons.error_outline, color: Colors.red),
              title: Text('Error loading user data', style: TextStyle(color: Colors.red)),
              subtitle: Text('Please try again later.'),
            ),
          );
        }

        final status = snapshot.data!;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: ClipOval(
              child: SizedBox(
                width: 48, // 24 radius * 2
                height: 48, // 24 radius * 2
                child: FutureBuilder<String?>(
                  future: _getProfileImageUrl(userId), // Fetch profile image
                  builder: (context, avatarSnapshot) {
                    return CachedNetworkImage(
                      imageUrl: avatarSnapshot.data ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/circleimage.png', // Default image on error
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
            title: Text(
              userData['name'] ?? 'Unknown',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              userData['phone'] ?? '',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: _buildActionButton(userId, userData['name'] ?? 'Unknown', status),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(String userId, String userName, BuddyStatus status) {
    switch (status) {
      case BuddyStatus.buddy:
        return const Text('Already buddies', style: TextStyle(color: Colors.green));
      case BuddyStatus.requestSent:
        return const Text('Request sent', style: TextStyle(color: Colors.orange));
      case BuddyStatus.requestReceived:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0066CC),
            foregroundColor: Colors.white, // Text color
          ),
          onPressed: () => _acceptRequest(userId),
          child: const Text('Accept'),
        );
      case BuddyStatus.blocked:
        return const Text('Blocked', style: TextStyle(color: Colors.red)); // Show 'Blocked' status, not Unblock button here
      case BuddyStatus.unknown:
      default:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0066CC),
            foregroundColor: Colors.white, // Text color
          ),
          onPressed: () => _sendBuddyRequest(userId),
          child: const Text('Add'),
        );
    }
  }
}

class ChatPage extends StatefulWidget {
  final String peerId;
  final String peerName;
  final String peerAvatar; // Now this can be a URL or asset path

  const ChatPage({
    required this.peerId,
    required this.peerName,
    required this.peerAvatar,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  late User _currentUser;
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<QuerySnapshot>? _messageSubscription; // For managing the subscription
  bool _selectionMode = false;
  Set<String> _selectedMessageIds = {};

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _setupMessageReadListener();
    _updatePeerLastSeen(); // Start updating peer's last seen (This is for the current user)
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _setupMessageReadListener() {
    _messageSubscription = _firestore
        .collection('chats')
        .doc(_getChatId())
        .collection('messages')
        .where('receiverId', isEqualTo: _currentUser.uid)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.update({'isRead': true}).catchError((e) {
          print("Error marking message as read: $e");
        });
      }
      // Update current user's lastMessageSeen for this chat
      _firestore.collection('chats').doc(_getChatId()).set({
        'lastMessageSeenBy.${_currentUser.uid}': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)).catchError((e) {
        print("Error updating lastMessageSeenBy for current user: $e");
      });
    }, onError: (e) {
      print("Error listening to unread messages: $e");
    });
  }

  // Monitor peer's lastSeen and isOnline status
  Stream<Map<String, dynamic>> _getPeerStatusStream() {
    return _firestore.collection('users').doc(widget.peerId).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      final isOnline = data['isOnline'] ?? false;
      final lastSeenTimestamp = data['lastSeen'] as Timestamp?;
      return {
        'isOnline': isOnline,
        'lastSeen': lastSeenTimestamp?.toDate(),
      };
    }).handleError((e) {
      print("Error fetching peer status: $e");
      return { 'isOnline': false, 'lastSeen': null }; // Default on error
    });
  }

  // Periodically update current user's last seen status (for other users to see)
  void _updatePeerLastSeen() {
    // This function updates the CURRENT USER's presence status, not the peer's.
    // The peer's status is read via _getPeerStatusStream().
    // The TravelBuddy widget already updates the current user's presence,
    // so this periodic update here can be removed if TravelBuddy covers it sufficiently
    // for chat page context. However, for continuous "online" status, a periodic heartbeat is good.
    Timer.periodic(const Duration(seconds: 15), (timer) {
      if (mounted) {
        _firestore.collection('users').doc(_currentUser.uid).set({
          'lastSeen': FieldValue.serverTimestamp(),
          'isOnline': true, // Keep online status updated
        }, SetOptions(merge: true)).catchError((e) {
          print("Error updating user presence: $e");
        });
      } else {
        timer.cancel();
      }
    });
  }


  String _getChatId() {
    return _currentUser.uid.hashCode <= widget.peerId.hashCode
        ? '${_currentUser.uid}-${widget.peerId}'
        : '${widget.peerId}-${_currentUser.uid}';
  }

  void _toggleSelectionMode(String messageId) {
    setState(() {
      _selectionMode = true;
      _selectedMessageIds.add(messageId);
    });
  }

  void _toggleMessageSelection(String messageId) {
    setState(() {
      if (_selectedMessageIds.contains(messageId)) {
        _selectedMessageIds.remove(messageId);
      } else {
        _selectedMessageIds.add(messageId);
      }

      if (_selectedMessageIds.isEmpty) {
        _selectionMode = false;
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selectedMessageIds.clear();
    });
  }

  Future<void> _deleteSelectedMessages() async {
    if (_selectedMessageIds.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Messages'),
        content: Text('Are you sure you want to delete ${_selectedMessageIds.length} selected message(s)? This action cannot be undone.'),
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
              Navigator.pop(context);
              try {
                final batch = _firestore.batch();
                for (String messageId in _selectedMessageIds) {
                  batch.delete(_firestore.collection('chats').doc(_getChatId()).collection('messages').doc(messageId));
                }
                await batch.commit();

                // After deletion, find the new last message and update the chat document
                await _updateLastMessageInChat();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selected messages deleted')),
                );
                _exitSelectionMode();
              } catch (e) {
                print("Error deleting selected messages: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to delete messages. Please try again.")),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearChatHistory() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text('Are you sure you want to delete all messages in this chat? This action cannot be undone.'),
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
              Navigator.pop(context);
              try {
                final messagesSnapshot = await _firestore.collection('chats').doc(_getChatId()).collection('messages').get();
                final batch = _firestore.batch();
                for (var doc in messagesSnapshot.docs) {
                  batch.delete(doc.reference);
                }
                await batch.commit();

                // Clear last message in parent chat document
                await _firestore.collection('chats').doc(_getChatId()).set({
                  'lastMessage': '',
                  'lastMessageTime': null,
                  'lastMessageSeenBy.${_currentUser.uid}': null, // Clear seen status
                  'lastMessageSeenBy.${widget.peerId}': null, // Clear seen status for peer as well
                }, SetOptions(merge: true));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat history cleared')),
                );
                _exitSelectionMode(); // Exit selection mode after clearing
              } catch (e) {
                print("Error clearing chat history: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to clear chat history. Please try again.")),
                );
              }
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateLastMessageInChat() async {
    try {
      final latestMessageSnapshot = await _firestore
          .collection('chats')
          .doc(_getChatId())
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      String newLastMessage = '';
      Timestamp? newLastMessageTime;

      if (latestMessageSnapshot.docs.isNotEmpty) {
        final latestMessageData = latestMessageSnapshot.docs.first.data();
        newLastMessage = latestMessageData['text'] ?? '';
        newLastMessageTime = latestMessageData['timestamp'] as Timestamp?;
      }

      await _firestore.collection('chats').doc(_getChatId()).set({
        'lastMessage': newLastMessage,
        'lastMessageTime': newLastMessageTime,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error updating last message in chat: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF0066CC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _selectionMode ? _exitSelectionMode : () => Navigator.pop(context),
        ),
        title: _selectionMode
            ? Text('${_selectedMessageIds.length} selected', style: const TextStyle(color: Colors.white))
            : Row( // Use Row to place avatar and name/status
          children: [
            // Use ClipOval and CachedNetworkImage for the peer's avatar in the app bar
            ClipOval(
              child: SizedBox(
                width: 36, // 18 radius * 2
                height: 36, // 18 radius * 2
                child: widget.peerAvatar.startsWith('http')
                    ? CachedNetworkImage(
                  imageUrl: widget.peerAvatar,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // White for app bar
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/circleimage.png', // Default image on error
                    fit: BoxFit.cover,
                  ),
                )
                    : Image.asset(
                  widget.peerAvatar, // Assume it's a local asset if not a URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded( // Use Expanded to allow text to take available space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.peerName,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                  StreamBuilder<Map<String, dynamic>>(
                    stream: _getPeerStatusStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final isOnline = snapshot.data!['isOnline'] ?? false;
                        final lastSeen = snapshot.data!['lastSeen'] as DateTime?;

                        if (isOnline) {
                          return Row(
                            children: const [
                              Icon(Icons.circle, color: Colors.greenAccent, size: 10),
                              SizedBox(width: 4),
                              Text('Online', style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
                            ],
                          );
                        } else if (lastSeen != null) {
                          final now = DateTime.now();
                          final difference = now.difference(lastSeen);
                          String statusText;
                          if (difference.inMinutes < 1) {
                            statusText = 'Active now';
                          } else if (difference.inHours < 1) {
                            statusText = 'Last seen ${difference.inMinutes}m ago';
                          } else if (difference.inDays < 1) {
                            statusText = 'Last seen ${difference.inHours}h ago';
                          } else {
                            statusText = 'Last seen on ${DateFormat('MMM d,yyyy').format(lastSeen)}';
                          }
                          return Row(
                            children: [
                              Icon(Icons.circle, color: Colors.grey, size: 10),
                              SizedBox(width: 4),
                              Text(statusText, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (_selectionMode)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _selectedMessageIds.isNotEmpty ? _deleteSelectedMessages : null,
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'clear_chat') {
                _clearChatHistory();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'clear_chat',
                  child: Text('Clear Chat History'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(_getChatId())
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0XFF0066CC)),
                    ),
                  );
                }

                // Removed WidgetsBinding.instance.addPostFrameCallback for auto-scroll
                // as it can cause re-layout on every frame, contributing to blinking.
                // Replaced with a more controlled scroll to bottom after new message.
                // Note: For multi-selection, the user might not want auto-scroll.

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final messageData = message.data() as Map<String, dynamic>;
                    final isSelected = _selectedMessageIds.contains(message.id);
                    // Decide if 'Seen' indicator should be shown for this specific message
                    final isLastMessageSentByMe = messageData['senderId'] == _currentUser.uid &&
                        index == messages.length - 1; // Check if it's the very last message in the chat
                    final isReadByPeer = messageData['isRead'] == true; // Check if this specific message is read

                    return _buildMessageItem(messageData, message.id, isSelected, isLastMessageSentByMe, isReadByPeer);
                  },
                );
              },
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('chats').doc(_getChatId()).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const SizedBox.shrink();
              }
              final chatData = snapshot.data!.data() as Map<String, dynamic>;
              final peerLastMessageSeenBy = chatData['lastMessageSeenBy.${widget.peerId}'] as Timestamp?;
              final myLastSentMessageTimestamp = chatData['lastMessageTime'] as Timestamp?; // This is the timestamp of my last sent message updated in the chat doc

              // Determine if "Seen" status should be displayed
              // This is a simplified "seen" indicator for the overall chat, not per message.
              // A more precise per-message "seen" requires tracking each message's seen status more deeply.
              final bool showOverallSeenStatus = peerLastMessageSeenBy != null &&
                  myLastSentMessageTimestamp != null &&
                  peerLastMessageSeenBy.toDate().isAfter(myLastSentMessageTimestamp.toDate());

              return Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: showOverallSeenStatus
                      ? Text(
                    'Seen ${DateFormat('HH:mm').format(peerLastMessageSeenBy!.toDate())}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  )
                      : const SizedBox.shrink(),
                ),
              );
            },
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> messageData, String messageId, bool isSelected, bool isLastMessageSentByMe, bool isReadByPeer) {
    final isMe = messageData['senderId'] == _currentUser.uid;
    final timestamp = messageData['timestamp'] as Timestamp?;
    final time = timestamp != null ? DateFormat('HH:mm').format(timestamp.toDate()) : '';

    return GestureDetector(
      onLongPress: () {
        if (!_selectionMode) {
          _toggleSelectionMode(messageId);
        } else {
          _toggleMessageSelection(messageId);
        }
      },
      onTap: _selectionMode
          ? () => _toggleMessageSelection(messageId)
          : null, // Allow tapping to select/deselect in selection mode
      child: Container(
        color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent, // Highlight selected messages
        child: Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF0066CC) : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
                bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  messageData['text'] ?? '',
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        color: isMe ? Colors.white70 : Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                    if (isMe && isLastMessageSentByMe && isReadByPeer) // Show 'Seen' only for sender's last message if read
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Icon(
                          Icons.done_all, // Double checkmark for seen
                          size: 14,
                          color: Colors.white,
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

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFF0066CC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFF0066CC), width: 2), // Blue border on focus
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFF0066CC),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final chatId = _getChatId();
    final messageData = {
      'text': text,
      'senderId': _currentUser.uid,
      'receiverId': widget.peerId,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false, // Message is unread by default when sent
    };

    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData).then((_) {
      // After sending message, update the lastMessage in the chat document
      _firestore.collection('chats').doc(chatId).set({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'participants': [_currentUser.uid, widget.peerId],
      }, SetOptions(merge: true)).catchError((e) {
        print("Error updating last message in chat document: $e");
      });
      // Scroll to the bottom after sending a message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

    }).catchError((e) {
      print("Error sending message: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send message.")),
      );
    });

    _messageController.clear();
  }
}
// Extension to get the last element that satisfies a condition, or null
extension IterableExtension<E> on Iterable<E> {
  E? lastWhereOrNull(bool Function(E element) test) {
    E? result;
    bool found = false;
    for (int i = length - 1; i >= 0; i--) {
      final element = elementAt(i);
      if (test(element)) {
        result = element;
        found = true;
        break;
      }
    }
    return found ? result : null;
  }
}
