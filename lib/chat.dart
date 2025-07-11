import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelmate/homepage.dart';
import 'package:travelmate/settingmenu.dart';
import 'package:travelmate/tools.dart';
import 'package:travelmate/TripMainPage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late User _currentUser;
  int currentIndex = 3;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        final url = await _storage.ref('profile_images/$userId').getDownloadURL();
        if (mounted) {
          setState(() {
            _profileImageUrl = url;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _profileImageUrl = null;
          });
        }
      }
    }
  }

  Future<String?> _getProfileImageUrl(String userId) async {
    try {
      final url = await _storage.ref('profile_images/$userId').getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<List<DocumentSnapshot>> _searchUsersByName(String query) async {
    if (query.isEmpty) return [];

    try {
      final usersSnapshot = await _firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();

      return usersSnapshot.docs;
    } catch (e) {
      print("Error searching users: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF0066CC),
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        title: SizedBox(
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 5,
                fit: FlexFit.tight,
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
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
                    decoration: const InputDecoration(
                      hintText: 'Search here...',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      isDense: true,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsMenuPage(previousIndex: 3),
                      ),
                    ).then((_) {
                      _loadProfileImage();
                    });
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white24,
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : const AssetImage('assets/images/circleimage.png') as ImageProvider,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Chats',
              style: TextStyle(
                fontSize: screenHeight * 0.025,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF0066CC),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('users')
                    .doc(_currentUser.uid)
                    .collection('buddies')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0XFF0066CC)),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error loading chats: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                    );
                  }

                  final buddies = snapshot.data?.docs ?? [];

                  return FutureBuilder<List<DocumentSnapshot>>(
                    future: _searchUsersByName(_searchQuery),
                    builder: (context, searchSnapshot) {
                      if (searchSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0XFF0066CC)),
                          ),
                        );
                      }

                      if (searchSnapshot.hasError) {
                        return Center(
                          child: Text('Error searching users: ${searchSnapshot.error}', style: const TextStyle(color: Colors.red)),
                        );
                      }

                      final List<DocumentSnapshot> combinedList = [];

                      // Add buddies first
                      combinedList.addAll(buddies);

                      // Add search results if available
                      if (searchSnapshot.hasData) {
                        combinedList.addAll(searchSnapshot.data!);
                      }

                      // Filter duplicates
                      final uniqueIds = <String>{};
                      final uniqueList = combinedList.where((doc) {
                        if (uniqueIds.contains(doc.id)) return false;
                        uniqueIds.add(doc.id);
                        return true;
                      }).toList();

                      // Filter based on search
                      final filteredList = uniqueList.where((doc) {
                        if (_searchQuery.isEmpty) return true;
                        final name = _safeGetField(doc, 'name')?.toString().toLowerCase() ?? '';
                        return name.contains(_searchQuery);
                      }).toList();

                      if (filteredList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off, size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'No buddies yet'
                                    : 'No results for "$_searchQuery"',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'Add friends to start chatting'
                                    : 'Try a different search term',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final userDoc = filteredList[index];
                          return _buildBuddyCard(userDoc.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedItemColor: const Color(0XFF0066CC),
            unselectedItemColor: Colors.grey[600],
            showUnselectedLabels: true,
            currentIndex: currentIndex,
            items: [
              _buildBottomNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isActive: currentIndex == 0,
              ),
              _buildBottomNavItem(
                icon: Icons.widgets_outlined,
                activeIcon: Icons.widgets,
                label: 'Tools',
                isActive: currentIndex == 1,
              ),
              _buildBottomNavItem(
                icon: Icons.airplane_ticket_outlined,
                activeIcon: Icons.airplane_ticket,
                label: 'Trips',
                isActive: currentIndex == 2,
              ),
              _buildBottomNavItem(
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                label: 'Chat',
                isActive: currentIndex == 3,
              ),
            ],
            onTap: (index) {
              if (index == currentIndex) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    if (index == 0) return HomePage();
                    if (index == 1) return Tools();
                    if (index == 2) return TripPage();
                    if (index == 3) return MessagePage();
                    return HomePage();
                  },
                ),
                    (route) => false,
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper function to safely get document fields
  dynamic _safeGetField(DocumentSnapshot doc, String field) {
    try {
      return doc.get(field);
    } catch (e) {
      return null;
    }
  }

  Widget _buildBuddyCard(String userId) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getBuddyCardData(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0XFF0066CC)), strokeWidth: 2),
                  SizedBox(width: 16),
                  Text('Loading chat info...'),
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
            elevation: 3,
            child: const ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: Icon(Icons.error_outline, color: Colors.red),
              title: Text('Error loading chat data', style: TextStyle(color: Colors.red)),
              subtitle: Text('Please try again later.'),
            ),
          );
        }

        final data = snapshot.data!;
        final userData = data['userData'] as Map<String, dynamic>;
        final unreadCount = data['unreadCount'] as int;
        final lastMessage = data['lastMessage'] as String;
        final lastMessageTime = data['lastMessageTime'] as String;
        final isBlocked = data['isBlocked'] as bool;
        final isOnline = userData['isOnline'] ?? false;
        final peerAvatarUrl = userData['photoUrl'];
        final isBuddy = data['isBuddy'] as bool;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Stack(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: CachedNetworkImage(
                      imageUrl: peerAvatarUrl ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0XFF0066CC)),
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/circleimage.png',
                        fit: BoxFit.cover,
                      ),
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
                      color: isOnline ? Colors.greenAccent : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              userData['name']?.toString() ?? 'Unknown',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isBlocked ? Colors.grey[600] : null,
              ),
            ),
            subtitle: isBlocked
                ? const Text(
              'Blocked User',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            )
                : Text(
              isBuddy ? lastMessage : 'Tap to start chatting',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isBuddy ? lastMessageTime : '',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                if (!isBlocked && isBuddy && unreadCount > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0XFF0066CC),
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
              ],
            ),
            onTap: isBlocked
                ? null
                : () async {
              if (isBuddy) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _ChatScreen(
                      peerId: userId,
                      peerName: userData['name']?.toString() ?? 'Unknown',
                      peerAvatar: peerAvatarUrl ?? 'assets/images/circleimage.png',
                    ),
                  ),
                );
              } else {
                // Add non-buddy as a new buddy
                await _addBuddy(userId, userData['name']?.toString() ?? 'Unknown');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _ChatScreen(
                      peerId: userId,
                      peerName: userData['name']?.toString() ?? 'Unknown',
                      peerAvatar: peerAvatarUrl ?? 'assets/images/circleimage.png',
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getBuddyCardData(String userId) async {
    final currentUser = _auth.currentUser!;

    // Check if this user is a buddy
    bool isBuddy = false;
    try {
      isBuddy = (await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('buddies')
          .doc(userId)
          .get())
          .exists;
    } catch (e) {
      print("Error checking buddy status: $e");
    }

    Map<String, dynamic> userData = {
      'name': 'Unknown',
      'isOnline': false,
      'photoUrl': null,
    };

    try {
      // Fetch user data
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc.data() != null) {
        userData = userDoc.data()!;
        // Add photoUrl to userData
        userData['photoUrl'] = await _getProfileImageUrl(userId);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }

    // Initialize chat-related variables
    String lastMessage = "Tap to chat";
    String lastMessageTime = "";
    int unreadCount = 0;

    // Only fetch chat data if they are buddies
    if (isBuddy) {
      final chatId = _getChatId(currentUser.uid, userId);

      try {
        final chatDoc = await _firestore.collection('chats').doc(chatId).get();
        if (chatDoc.exists && chatDoc.data() != null) {
          final chatData = chatDoc.data()!;
          lastMessage = chatData['lastMessage']?.toString() ?? "Tap to chat";
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
        unreadCount = unreadSnapshot.docs.length;
      } catch (e) {
        print("Error fetching chat data: $e");
      }
    }

    // Check if current user blocked buddy OR if buddy blocked current user
    bool blockedByMe = false;
    bool blockedByBuddy = false;

    try {
      blockedByMe = (await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('blocked')
          .doc(userId)
          .get())
          .exists;

      blockedByBuddy = (await _firestore
          .collection('users')
          .doc(userId)
          .collection('blocked')
          .doc(currentUser.uid)
          .get())
          .exists;
    } catch (e) {
      print("Error checking blocked status: $e");
    }

    final isBlocked = blockedByMe || blockedByBuddy;

    return {
      'userData': userData,
      'unreadCount': unreadCount,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'isBlocked': isBlocked,
      'isBuddy': isBuddy,
    };
  }

  Future<void> _addBuddy(String userId, String userName) async {
    final currentUser = _auth.currentUser!;

    try {
      // Add to current user's buddies
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('buddies')
          .doc(userId)
          .set({
        'name': userName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Add current user to the buddy's buddies list
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('buddies')
          .doc(currentUser.uid)
          .set({
        'name': currentUser.displayName ?? 'Unknown',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding buddy: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add buddy. Please try again.")),
      );
    }
  }

  String _getChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '$uid1-$uid2' : '$uid2-$uid1';
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

  BottomNavigationBarItem _buildBottomNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isActive ? const Color(0XFF0066CC).withOpacity(0.1) : Colors.transparent,
        ),
        child: Icon(icon, color: isActive ? const Color(0XFF0066CC) : Colors.grey[600]),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0XFF0066CC).withOpacity(0.1),
        ),
        child: Icon(activeIcon, color: const Color(0XFF0066CC)),
      ),
      label: label,
    );
  }
}

class _ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerName;
  final String peerAvatar;

  const _ChatScreen({
    required this.peerId,
    required this.peerName,
    required this.peerAvatar,
  });

  @override
  __ChatScreenState createState() => __ChatScreenState();
}

class __ChatScreenState extends State<_ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  late User _currentUser;
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<QuerySnapshot>? _messageSubscription;
  bool _selectionMode = false;
  Set<String> _selectedMessageIds = {};

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _setupMessageReadListener();
    _updatePeerLastSeen();
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
            child: const Text('Cancel', style: TextStyle(color: Color(0XFF0066CC))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0XFF0066CC),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              try {
                final messagesSnapshot = await _firestore
                    .collection('chats')
                    .doc(_getChatId())
                    .collection('messages')
                    .get();

                final batch = _firestore.batch();
                for (var doc in messagesSnapshot.docs) {
                  batch.delete(doc.reference);
                }
                await batch.commit();

                await _firestore.collection('chats').doc(_getChatId()).set({
                  'lastMessage': '',
                  'lastMessageTime': null,
                  'lastMessageSeenBy.${_currentUser.uid}': null,
                  'lastMessageSeenBy.${widget.peerId}': null,
                }, SetOptions(merge: true));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat history cleared')),
                );
                _exitSelectionMode();
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
      _firestore.collection('chats').doc(_getChatId()).set({
        'lastMessageSeenBy.${_currentUser.uid}': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)).catchError((e) {
        print("Error updating lastMessageSeenBy for current user: $e");
      });
    }, onError: (e) {
      print("Error listening to unread messages: $e");
    });
  }

  Stream<Map<String, dynamic>> _getPeerStatusStream() {
    return _firestore.collection('users').doc(widget.peerId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return {'isOnline': false, 'lastSeen': null};
      }
      final data = snapshot.data() as Map<String, dynamic>;
      final isOnline = data['isOnline'] ?? false;
      final lastSeenTimestamp = data['lastSeen'] as Timestamp?;
      return {
        'isOnline': isOnline,
        'lastSeen': lastSeenTimestamp?.toDate(),
      };
    }).handleError((e) {
      print("Error fetching peer status: $e");
      return {'isOnline': false, 'lastSeen': null};
    });
  }

  void _updatePeerLastSeen() {
    Timer.periodic(const Duration(seconds: 15), (timer) {
      if (mounted) {
        _firestore.collection('users').doc(_currentUser.uid).set({
          'lastSeen': FieldValue.serverTimestamp(),
          'isOnline': true,
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
            child: const Text('Cancel', style: TextStyle(color: Color(0XFF0066CC))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0XFF0066CC),
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

  Future<void> _removeBuddy() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Buddy'),
        content: Text('Are you sure you want to remove ${widget.peerName} from your buddies?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0XFF0066CC))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0XFF0066CC),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _firestore
                    .collection('users')
                    .doc(_currentUser.uid)
                    .collection('buddies')
                    .doc(widget.peerId)
                    .delete();

                await _firestore
                    .collection('users')
                    .doc(widget.peerId)
                    .collection('buddies')
                    .doc(_currentUser.uid)
                    .delete();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buddy removed successfully')),
                );
                Navigator.pop(context);
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

  Future<void> _blockUser() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text('Are you sure you want to block ${widget.peerName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0XFF0066CC))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0XFF0066CC),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _firestore
                    .collection('users')
                    .doc(_currentUser.uid)
                    .collection('blocked')
                    .doc(widget.peerId)
                    .set({
                  'timestamp': FieldValue.serverTimestamp(),
                });

                await _firestore
                    .collection('users')
                    .doc(_currentUser.uid)
                    .collection('buddies')
                    .doc(widget.peerId)
                    .delete();

                await _firestore
                    .collection('users')
                    .doc(widget.peerId)
                    .collection('buddies')
                    .doc(_currentUser.uid)
                    .delete();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User blocked successfully')),
                );
                Navigator.pop(context);
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
            : Row(
          children: [
            ClipOval(
              child: SizedBox(
                width: 36,
                height: 36,
                child: widget.peerAvatar.startsWith('http')
                    ? CachedNetworkImage(
                  imageUrl: widget.peerAvatar,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/circleimage.png',
                    fit: BoxFit.cover,
                  ),
                )
                    : Image.asset(
                  widget.peerAvatar,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.peerName,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  StreamBuilder<Map<String, dynamic>>(
                    stream: _getPeerStatusStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 12,
                          width: 50,
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                            backgroundColor: Colors.transparent,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text('Status Error', style: TextStyle(color: Colors.red, fontSize: 10));
                      }
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
              if (value == 'remove') {
                _removeBuddy();
              } else if (value == 'block') {
                _blockUser();
              } else if (value == 'clear_chat') {
                _clearChatHistory();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.person_remove, color: Color(0XFF0066CC)),
                      SizedBox(width: 8),
                      Text('Remove Buddy'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'block',
                  child: Row(
                    children: [
                      Icon(Icons.block, color: Color(0XFF0066CC)),
                      SizedBox(width: 8),
                      Text('Block User'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'clear_chat',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep, color: Color(0XFF0066CC)),
                      SizedBox(width: 8),
                      Text('Clear Chat History'),
                    ],
                  ),
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

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final messageData = message.data() as Map<String, dynamic>;
                    final isSelected = _selectedMessageIds.contains(message.id);
                    final isLastMessageSentByMe = messageData['senderId'] == _currentUser.uid &&
                        index == messages.length - 1;
                    final isReadByPeer = messageData['isRead'] == true;

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
              final myLastSentMessageTimestamp = chatData['lastMessageTime'] as Timestamp?;

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
      onTap: _selectionMode ? () => _toggleMessageSelection(messageId) : null,
      child: Container(
        color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
        child: Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isMe ? const Color(0XFF0066CC) : Colors.grey[200],
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
                    if (isMe && isLastMessageSentByMe && isReadByPeer)
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Icon(
                          Icons.done_all,
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
                  borderSide: const BorderSide(color: Color(0XFF0066CC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0XFF0066CC), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0XFF0066CC),
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
      'isRead': false,
    };

    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData)
        .then((_) {
      _firestore.collection('chats').doc(chatId).set({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'participants': [_currentUser.uid, widget.peerId],
      }, SetOptions(merge: true)).catchError((e) {
        print("Error updating last message in chat document: $e");
      });

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

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}