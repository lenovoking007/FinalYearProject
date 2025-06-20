import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Define BuddyStatus enum at the top level
enum BuddyStatus {
  buddy,
  requestSent,
  requestReceived,
  unknown,
}

class TravelBuddy extends StatefulWidget {
  @override
  _TravelBuddyState createState() => _TravelBuddyState();
}

class _TravelBuddyState extends State<TravelBuddy> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _currentUser;
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF0066CC),
        elevation: 0,
        title: _isSearching
            ? _buildSearchField()
            : Text('Travel Buddy', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(icon: Icon(Icons.group)), // Buddies
            Tab(icon: Icon(Icons.notifications)), // Requests
            Tab(icon: Icon(Icons.person_add)), // Find Buddies
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBuddiesTab(),
          _buildRequestsTab(),
          _buildFindBuddiesTab(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Search by name or phone...",
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
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
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final buddies = snapshot.data!.docs;

        if (buddies.isEmpty) {
          return _buildEmptyState('No buddies yet', 'Add friends to start chatting');
        }

        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: buddies.length,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildBuddyCard(buddies[index]);
          },
        );
      },
    );
  }

  Widget _buildBuddyCard(DocumentSnapshot buddy) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(buddy.id).get(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return SizedBox.shrink();
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final chatId = _getChatId(_currentUser.uid, buddy.id);

        return StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('chats').doc(chatId).snapshots(),
          builder: (context, chatSnapshot) {
            String lastMessage = "Tap to chat";
            String lastMessageTime = "";

            if (chatSnapshot.hasData && chatSnapshot.data!.exists) {
              final chatData = chatSnapshot.data!.data() as Map<String, dynamic>;
              lastMessage = chatData['lastMessage'] ?? "Tap to chat";
              final timestamp = chatData['lastMessageTime'] as Timestamp?;
              if (timestamp != null) {
                lastMessageTime = _formatTime(timestamp.toDate());
              }
            }

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _openChat(userData, buddy.id),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(userData['photoUrl'] ?? ''),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData['name'] ?? 'Unknown',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        lastMessageTime,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
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

  Widget _buildRequestsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .collection('receivedRequests')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(
            
          ));
        }

        final requests = snapshot.data!.docs;

        if (requests.isEmpty) {
          return _buildEmptyState('No pending requests', 'Friend requests will appear here');
        }

        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: requests.length,
          separatorBuilder: (_, __) => SizedBox(height: 12),
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
        if (!userSnapshot.hasData) {
          return SizedBox.shrink();
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(userData['photoUrl'] ?? ''),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        userData['name'] ?? 'Unknown',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _rejectRequest(request.id),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Decline', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _acceptRequest(request.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0066CC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Accept'),
                      ),
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

  Widget _buildFindBuddiesTab() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search by name or phone number",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF0066CC)),
              ),
            ),
            onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final allUsers = snapshot.data!.docs.where((doc) {
                final userData = doc.data() as Map<String, dynamic>;
                final userId = doc.id;

                // Exclude current user
                if (userId == _currentUser.uid) return false;

                // Filter by search query
                if (_searchQuery.isNotEmpty) {
                  final name = userData['name']?.toString().toLowerCase() ?? '';
                  final phone = userData['phone']?.toString().toLowerCase() ?? '';
                  if (!name.contains(_searchQuery) && !phone.contains(_searchQuery)) {
                    return false;
                  }
                }

                return true;
              }).toList();

              if (allUsers.isEmpty) {
                return _buildEmptyState('No users found', 'Try a different search');
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: allUsers.length,
                separatorBuilder: (_, __) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final user = allUsers[index];
                  final userData = user.data() as Map<String, dynamic>;
                  return _buildPotentialBuddyCard(user.id, userData);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPotentialBuddyCard(String userId, Map<String, dynamic> userData) {
    return FutureBuilder<BuddyStatus>(
      future: _isBuddyOrPending(userId),
      builder: (context, snapshot) {
        final status = snapshot.data ?? BuddyStatus.unknown;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(userData['photoUrl'] ?? ''),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData['name'] ?? 'Unknown',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        userData['phone'] ?? '',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                _buildBuddyActionButton(userId, status),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBuddyActionButton(String userId, BuddyStatus status) {
    switch (status) {
      case BuddyStatus.buddy:
        return Text('Buddies', style: TextStyle(color: Colors.green));
      case BuddyStatus.requestSent:
        return Text('Request Sent', style: TextStyle(color: Colors.orange));
      case BuddyStatus.requestReceived:
        return ElevatedButton(
          onPressed: () => _acceptRequest(userId),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0066CC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('Accept'),
        );
      case BuddyStatus.unknown:
      default:
        return ElevatedButton(
          onPressed: () => _sendBuddyRequest(userId),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0066CC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('Add'),
        );
    }
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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

  Future<BuddyStatus> _isBuddyOrPending(String userId) async {
    // Check if already buddies
    final buddyDoc = await _firestore
        .collection('users')
        .doc(_currentUser.uid)
        .collection('buddies')
        .doc(userId)
        .get();

    if (buddyDoc.exists) return BuddyStatus.buddy;

    // Check if request already sent
    final sentRequest = await _firestore
        .collection('users')
        .doc(_currentUser.uid)
        .collection('sentRequests')
        .doc(userId)
        .get();

    if (sentRequest.exists) return BuddyStatus.requestSent;

    // Check if request received
    final receivedRequest = await _firestore
        .collection('users')
        .doc(_currentUser.uid)
        .collection('receivedRequests')
        .doc(userId)
        .get();

    if (receivedRequest.exists) return BuddyStatus.requestReceived;

    return BuddyStatus.unknown;
  }

  // Firebase operations
  Future<void> _sendBuddyRequest(String peerId) async {
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
        SnackBar(content: Text("Friend request sent")));
  }

  Future<void> _acceptRequest(String requesterId) async {
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

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You are now buddies!")));
  }

  Future<void> _rejectRequest(String requesterId) async {
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
        SnackBar(content: Text("Request declined")));
  }

  Future<void> _openChat(Map<String, dynamic> userData, String peerId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          peerId: peerId,
          peerName: userData['name'] ?? 'Unknown',
          peerAvatar: userData['photoUrl'] ?? '',
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerName;
  final String peerAvatar;

  const ChatScreen({
    required this.peerId,
    required this.peerName,
    required this.peerAvatar,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _markMessagesAsRead();
  }

  void _markMessagesAsRead() {
    _firestore
        .collection('chats')
        .doc(_getChatId())
        .collection('messages')
        .where('senderId', isEqualTo: widget.peerId)
        .where('isRead', isEqualTo: false)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.update({'isRead': true});
      }
    });
  }

  String _getChatId() {
    return _currentUser.uid.hashCode <= widget.peerId.hashCode
        ? '${_currentUser.uid}-${widget.peerId}'
        : '${widget.peerId}-${_currentUser.uid}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0066CC),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.peerAvatar),
              radius: 18,
            ),
            SizedBox(width: 10),
            Text(widget.peerName),
          ],
        ),
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
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data!.docs[index];
                    final messageData = message.data() as Map<String, dynamic>;
                    return _buildMessageItem(messageData);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> messageData) {
    final isMe = messageData['senderId'] == _currentUser.uid;
    final timestamp = messageData['timestamp'] as Timestamp?;
    final time = timestamp != null ? DateFormat('HH:mm').format(timestamp.toDate()) : '';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isMe ? Color(0xFF0066CC) : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: isMe ? Radius.circular(16) : Radius.circular(0),
            bottomRight: isMe ? Radius.circular(0) : Radius.circular(16),
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
            SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Color(0xFF0066CC)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Color(0xFF0066CC),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
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
        .add(messageData);

    // Update last message in chats collection
    _firestore.collection('chats').doc(chatId).set({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'participants': [_currentUser.uid, widget.peerId],
    }, SetOptions(merge: true));

    _messageController.clear();
  }
}