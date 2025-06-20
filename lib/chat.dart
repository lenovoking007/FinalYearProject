import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/homepage.dart';
import 'package:travelmate/settingmenu.dart';
import 'package:travelmate/tools.dart';
import 'package:travelmate/TripMainPage.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatelessWidget {
  final String peerId;
  final String peerName;
  final String peerAvatar;

  const ChatPage({
    required this.peerId,
    required this.peerName,
    required this.peerAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatScreen(
        peerId: peerId,
        peerName: peerName,
        peerAvatar: peerAvatar,
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  late User _currentUser;
  final ScrollController _scrollController = ScrollController();

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search here...',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      isDense: true,
                    ),
                    style: TextStyle(color: Colors.white),
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
                    );
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white24,
                    backgroundImage: NetworkImage(widget.peerAvatar),
                    child: null,
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
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .doc(_getChatId())
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                    }
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final message = snapshot.data!.docs[index];
                      final messageData = message.data() as Map<String, dynamic>;
                      return _buildMessageItem(messageData, screenHeight);
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Write a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0XFF0066CC)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> messageData, double screenHeight) {
    final isMe = messageData['senderId'] == _currentUser.uid;
    final timestamp = messageData['timestamp'] as Timestamp?;
    final time = timestamp != null ? DateFormat('HH:mm').format(timestamp.toDate()) : '';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        padding: EdgeInsets.all(screenHeight * 0.015),
        decoration: BoxDecoration(
          color: isMe ? Color(0XFF0066CC) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              messageData['text'] ?? '',
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey,
                fontSize: screenHeight * 0.014,
              ),
            ),
          ],
        ),
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

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int currentIndex = 3;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
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
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search here...',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      isDense: true,
                    ),
                    style: TextStyle(color: Colors.white),
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
                    );
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white24,
                    backgroundImage: NetworkImage(_currentUser.photoURL ?? ''),
                    child: null,
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
                color: Color(0XFF0066CC),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('users')
                    .doc(_currentUser.uid)
                    .collection('buddies')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final buddies = snapshot.data!.docs;

                  if (buddies.isEmpty) {
                    return Center(child: Text("No chats yet. Add some buddies!"));
                  }

                  return ListView.builder(
                    itemCount: buddies.length,
                    itemBuilder: (context, index) {
                      final buddy = buddies[index];
                      return _buildChatTile(buddy.id, screenHeight);
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

  Widget _buildChatTile(String buddyId, double screenHeight) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(buddyId).get(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return SizedBox.shrink();
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final chatId = _getChatId(_currentUser.uid, buddyId);
        final lastMessageRef = _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1);

        return StreamBuilder<QuerySnapshot>(
          stream: lastMessageRef.snapshots(),
          builder: (context, messageSnapshot) {
            String lastMessage = "No messages yet";
            String lastMessageTime = "";
            int unreadCount = 0;

            if (messageSnapshot.hasData && messageSnapshot.data!.docs.isNotEmpty) {
              final messageData = messageSnapshot.data!.docs.first.data() as Map<String, dynamic>;
              lastMessage = messageData['text'] ?? "";
              final timestamp = messageData['timestamp'] as Timestamp?;
              if (timestamp != null) {
                lastMessageTime = _formatTime(timestamp.toDate());
              }
            }

            // Get unread count
            final unreadRef = _firestore
                .collection('chats')
                .doc(chatId)
                .collection('messages')
                .where('senderId', isEqualTo: buddyId)
                .where('isRead', isEqualTo: false);

            return StreamBuilder<QuerySnapshot>(
              stream: unreadRef.snapshots(),
              builder: (context, unreadSnapshot) {
                if (unreadSnapshot.hasData) {
                  unreadCount = unreadSnapshot.data!.docs.length;
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          peerId: buddyId,
                          peerName: userData['displayName'] ?? 'Unknown',
                          peerAvatar: userData['photoUrl'] ?? '',
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    child: ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: screenHeight * 0.03,
                            backgroundImage: NetworkImage(userData['photoUrl'] ?? ''),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: screenHeight * 0.015,
                              height: screenHeight * 0.015,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        userData['displayName'] ?? 'Unknown',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight * 0.02
                        ),
                      ),
                      subtitle: Text(
                        lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            lastMessageTime,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: screenHeight * 0.015
                            ),
                          ),
                          if (unreadCount > 0)
                            Container(
                              margin: EdgeInsets.only(top: screenHeight * 0.005),
                              padding: EdgeInsets.all(screenHeight * 0.008),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0XFF0066CC),
                              ),
                              child: Text(
                                '$unreadCount',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenHeight * 0.015
                                ),
                              ),
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
      },
    );
  }

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