import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  late User _currentUser;
  late TabController _tabController;
  List<String> selectedItems = [];
  bool isSelecting = false;
  Map<String, dynamic>? _currentUserData;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _tabController = TabController(length: 2, vsync: this);
    _loadCurrentUserData();
  }

  Future<void> _loadCurrentUserData() async {
    final userDoc = await _firestore.collection('users').doc(_currentUser.uid).get();
    setState(() {
      _currentUserData = userDoc.data();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0066CC),
        elevation: 0,
        title: const Text('Gallery', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          if (!isSelecting)
            IconButton(
              icon: const Icon(Icons.upload, color: Colors.white),
              onPressed: _showUploadOptions,
            ),
          if (isSelecting)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () => _showDeleteDialog(),
            ),
          if (isSelecting)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                setState(() {
                  isSelecting = false;
                  selectedItems.clear();
                });
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'My Gallery'),
            Tab(text: 'Trending'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUserGallery(),
          _buildTrendingGallery(),
        ],
      ),
    );
  }

  Widget _buildUserGallery() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileImageSection(),
          _buildGalleryUploadsSection(),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Profile Pictures',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0066CC),
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('galleryItems')
              .where('userId', isEqualTo: _currentUser.uid)
              .where('isProfileImage', isEqualTo: true)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
                ),
              );
            }

            final items = snapshot.data!.docs;
            if (items.isEmpty) {
              return Container(
                height: 200,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        'No profile pictures yet',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final data = item.data() as Map<String, dynamic>;
                return _buildProfileImageItem(item.id, data);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfileImageItem(String itemId, Map<String, dynamic> data) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          isSelecting = true;
          selectedItems.add(itemId);
        });
        _showDeleteProfileImageDialog();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF0066CC),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: data['downloadUrl'],
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF0066CC)),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.error, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryUploadsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Gallery Uploads',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0066CC),
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('galleryItems')
              .where('userId', isEqualTo: _currentUser.uid)
              .where('isProfileImage', isEqualTo: false)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF0066CC)),
                ),
              );
            }

            final items = snapshot.data!.docs;
            if (items.isEmpty) {
              return Container(
                height: 200,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        'No gallery uploads yet',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final data = item.data() as Map<String, dynamic>;
                return _buildGalleryItem(item.id, data);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildGalleryItem(String itemId, Map<String, dynamic> data) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          isSelecting = true;
          selectedItems.add(itemId);
        });
      },
      onTap: () {
        if (isSelecting) {
          setState(() {
            if (selectedItems.contains(itemId)) {
              selectedItems.remove(itemId);
            } else {
              selectedItems.add(itemId);
            }
            if (selectedItems.isEmpty) isSelecting = false;
          });
        } else {
          _showFullImage(data['downloadUrl']);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF0066CC),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: data['downloadUrl'],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF0066CC)),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.error, color: Colors.grey),
                ),
              ),
            ),
            if (selectedItems.contains(itemId))
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.black54,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 36),
                ),
              ),
            if (!data['isPublic'])
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.lock, color: Colors.white, size: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingGallery() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('galleryItems')
          .where('isPublic', isEqualTo: true)
          .where('isProfileImage', isEqualTo: false)
          .orderBy('likes', descending: true)
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
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.trending_up, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No trending images',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Public images with most likes appear here',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        final items = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return !(_currentUserData?['hiddenGalleryItems']?.contains(doc.id) ?? false);
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final data = item.data() as Map<String, dynamic>;
            return _buildTrendingItem(item.id, data);
          },
        );
      },
    );
  }

  Widget _buildTrendingItem(String itemId, Map<String, dynamic> data) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(data['userId']).get(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) return const SizedBox.shrink();

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final hasLiked = data['likedBy']?.contains(_currentUser.uid) ?? false;
        final isOwner = data['userId'] == _currentUser.uid;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showFullImage(data['downloadUrl']),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: CachedNetworkImage(
                        imageUrl: data['downloadUrl'],
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 300,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF0066CC)),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 300,
                          color: Colors.grey[200],
                          child: const Icon(Icons.error, color: Colors.grey),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.favorite, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${data['likes'] ?? 0}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    FutureBuilder(
                      future: _storage.ref('profile_images/${data['userId']}').getDownloadURL().catchError((_) => null),
                      builder: (context, snapshot) {
                        return CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: snapshot.hasData && snapshot.data != null
                              ? NetworkImage(snapshot.data!)
                              : const AssetImage('assets/images/circleimage.png') as ImageProvider,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        userData['name'] ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        hasLiked ? Icons.favorite : Icons.favorite_border,
                        color: hasLiked ? const Color(0xFF0066CC) : Colors.grey,
                      ),
                      onPressed: () => _toggleLike(itemId, data),
                    ),
                    if (!isOwner)
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text('Report'),
                            onTap: () => _reportImage(itemId),
                          ),
                          PopupMenuItem(
                            child: const Text('Hide'),
                            onTap: () => _hideImage(itemId),
                          ),
                        ],
                      ),
                    if (isOwner)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteDialog(itemId: itemId, data: data),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF0066CC)),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF0066CC)),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      final privacyChoice = await showDialog<bool>(
          context: context,
          builder: (context) =>AlertDialog(
            title: const Text('Privacy Setting'),
            content: const Text('Do you want to make this image public?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Private', style: TextStyle(color: Color(0xFF0066CC))),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066CC),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Public', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),

      );

    if (privacyChoice == null) return;

    await _uploadImage(File(pickedFile.path), privacyChoice, isProfileImage: false);
    } catch (e) {
    _showError('Failed to pick image: $e');
    }
  }

  Future<void> _uploadImage(File file, bool isPublic, {bool isProfileImage = false}) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
          ),
        ),
      );

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storagePath = isProfileImage
          ? 'profile_images/${_currentUser.uid}'
          : 'gallery/${_currentUser.uid}/${isPublic ? 'public' : 'private'}/$fileName';

      final uploadTask = _storage.ref(storagePath).putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await _firestore.collection('galleryItems').add({
        'userId': _currentUser.uid,
        'downloadUrl': downloadUrl,
        'storagePath': storagePath,
        'isPublic': isPublic,
        'isProfileImage': isProfileImage,
        'likes': 0,
        'likedBy': [],
        'timestamp': FieldValue.serverTimestamp(),
        'reports': 0,
        'reportedBy': [],
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully!')),
      );
    } catch (e) {
      Navigator.pop(context);
      _showError('Failed to upload image: $e');
    }
  }

  void _showDeleteProfileImageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile Picture'),
        content: const Text('Are you sure you want to delete your profile picture?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isSelecting = false;
                selectedItems.clear();
              });
            },
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF0066CC))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066CC)),
            onPressed: () async {
              Navigator.pop(context);
              await _deleteProfileImage();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProfileImage() async {
    try {
      // Delete all profile images from Firestore
      final query = await _firestore.collection('galleryItems')
          .where('userId', isEqualTo: _currentUser.uid)
          .where('isProfileImage', isEqualTo: true)
          .get();

      final batch = _firestore.batch();
      for (final doc in query.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Try to delete from storage (won't fail if file doesn't exist)
      try {
        await _storage.ref('profile_images/${_currentUser.uid}').delete();
      } catch (e) {
        // Ignore storage deletion errors
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture deleted')),
      );
    } catch (e) {
      _showError('Failed to delete profile picture: $e');
    } finally {
      setState(() {
        isSelecting = false;
        selectedItems.clear();
      });
    }
  }

  void _showDeleteDialog({String? itemId, Map<String, dynamic>? data}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Image'),
        content: const Text('Are you sure you want to delete the selected images?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isSelecting = false;
                selectedItems.clear();
              });
            },
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF0066CC))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066CC)),
            onPressed: () async {
              Navigator.pop(context);
              if (itemId != null && data != null) {
                await _deleteImage(itemId, data);
              } else {
                await _deleteSelectedItems();
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSelectedItems() async {
    try {
      final items = await _firestore.collection('galleryItems')
          .where(FieldPath.documentId, whereIn: selectedItems)
          .get();

      final batch = _firestore.batch();
      for (final item in items.docs) {
        final data = item.data() as Map<String, dynamic>;
        batch.delete(item.reference);
        try {
          await _storage.ref(data['storagePath']).delete();
        } catch (e) {
          // Ignore storage deletion errors
        }
      }

      await batch.commit();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selected items deleted')),
      );
    } catch (e) {
      _showError('Failed to delete items: $e');
    } finally {
      setState(() {
        isSelecting = false;
        selectedItems.clear();
      });
    }
  }

  Future<void> _deleteImage(String itemId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('galleryItems').doc(itemId).delete();
      try {
        await _storage.ref(data['storagePath']).delete();
      } catch (e) {
        // Ignore storage deletion errors
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image deleted')),
      );
    } catch (e) {
      _showError('Failed to delete image: $e');
    }
  }

  Future<void> _toggleLike(String itemId, Map<String, dynamic> data) async {
    try {
      final isLiked = data['likedBy']?.contains(_currentUser.uid) ?? false;

      await _firestore.collection('galleryItems').doc(itemId).update({
        'likes': isLiked ? FieldValue.increment(-1) : FieldValue.increment(1),
        'likedBy': isLiked
            ? FieldValue.arrayRemove([_currentUser.uid])
            : FieldValue.arrayUnion([_currentUser.uid]),
      });
    } catch (e) {
      _showError('Failed to update like: $e');
    }
  }

  Future<void> _reportImage(String itemId) async {
    try {
      await _firestore.collection('galleryItems').doc(itemId).update({
        'reports': FieldValue.increment(1),
        'reportedBy': FieldValue.arrayUnion([_currentUser.uid]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image reported. Thank you!')),
      );
    } catch (e) {
      _showError('Failed to report image: $e');
    }
  }

  Future<void> _hideImage(String itemId) async {
    try {
      await _firestore.collection('users').doc(_currentUser.uid).update({
        'hiddenGalleryItems': FieldValue.arrayUnion([itemId]),
      });

      // Force refresh of the trending tab
      setState(() {
        _loadCurrentUserData();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image hidden from your feed')),
      );
    } catch (e) {
      _showError('Failed to hide image: $e');
    }
  }

  void _showFullImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}