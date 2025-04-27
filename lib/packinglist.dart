import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PackingListPage extends StatefulWidget {
  const PackingListPage({super.key});

  @override
  State<PackingListPage> createState() => _PackingListPageState();
}

class _PackingListPageState extends State<PackingListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _selectedItems = [];
  bool _isSelecting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0XFF0066CC),
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search items...',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 12),
                    isDense: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        actions: [
          if (_isSelecting)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _deleteSelectedItems,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'My Packing List',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0XFF0066CC),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage items for your upcoming trip',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('packingLists')
                    .where('userId', isEqualTo: _user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.luggage, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            "No packing items yet",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Tap + to add your first item",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final packingList = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final searchTerm = _searchController.text.toLowerCase();
                    return data['item'].toString().toLowerCase().contains(searchTerm);
                  }).toList();

                  return ListView.builder(
                    itemCount: packingList.length,
                    itemBuilder: (context, index) {
                      final item = packingList[index];
                      return _buildPackingItemCard(item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPackingItemDialog(context),
        backgroundColor: const Color(0XFF0066CC),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPackingItemCard(DocumentSnapshot item) {
    final data = item.data() as Map<String, dynamic>;
    final description = data['description'] != null && data['description'].toString().isNotEmpty
        ? data['description'].toString().length > 50
        ? '${data['description'].toString().substring(0, 50)}...'
        : data['description'].toString()
        : null;

    final isSelected = _selectedItems.contains(item.id);

    return GestureDetector(
      onLongPress: () {
        setState(() {
          _isSelecting = true;
          _toggleItemSelection(item.id);
        });
      },
      onTap: () {
        if (_isSelecting) {
          setState(() {
            _toggleItemSelection(item.id);
          });
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? const BorderSide(color: Color(0XFF0066CC), width: 2)
              : BorderSide.none,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromRGBO(0, 102, 204, 0.3)
                  : const Color.fromRGBO(0, 102, 204, 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isSelected ? Icons.check : Icons.check_circle,
              color: isSelected ? Colors.white : const Color(0XFF0066CC),
            ),
          ),
          title: Text(
            data['item'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0XFF0066CC) : Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data['quantity'] != null && data['quantity'].toString().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Quantity: ${data['quantity']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? const Color.fromRGBO(0, 102, 204, 0.8)
                          : Colors.grey[600],
                    ),
                  ),
                ),
              if (description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? const Color.fromRGBO(0, 102, 204, 0.8)
                          : Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ),
          trailing: _isSelecting
              ? Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                _toggleItemSelection(item.id);
              });
            },
            activeColor: const Color(0XFF0066CC),
          )
              : PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0XFF0066CC)),
            onSelected: (value) => _handlePackingItemAction(value, item),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: const Text('Edit', style: TextStyle(color: Color(0XFF0066CC))),
              ),
              PopupMenuItem(
                value: 'delete',
                child: const Text('Delete', style: TextStyle(color: Color(0XFF0066CC))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleItemSelection(String itemId) {
    if (_selectedItems.contains(itemId)) {
      _selectedItems.remove(itemId);
      if (_selectedItems.isEmpty) {
        setState(() {
          _isSelecting = false;
        });
      }
    } else {
      _selectedItems.add(itemId);
    }
  }

  Future<void> _deleteSelectedItems() async {
    if (_selectedItems.isEmpty) return;

    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Items"),
        content: Text("Are you sure you want to delete ${_selectedItems.length} items?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Color(0XFF0066CC))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Color(0XFF0066CC)),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final batch = _firestore.batch();
      for (final itemId in _selectedItems) {
        batch.delete(_firestore.collection('packingLists').doc(itemId));
      }
      await batch.commit();

      setState(() {
        _selectedItems.clear();
        _isSelecting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${_selectedItems.length} items deleted successfully"),
          backgroundColor: const Color(0XFF0066CC),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _handlePackingItemAction(String action, DocumentSnapshot item) {
    switch (action) {
      case 'edit':
        _showEditPackingItemDialog(context, item);
        break;
      case 'delete':
        _showDeleteConfirmationDialog(item);
        break;
    }
  }

  void _showDeleteConfirmationDialog(DocumentSnapshot item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Item"),
        content: const Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Color(0XFF0066CC))),
          ),
          TextButton(
            onPressed: () {
              _firestore.collection('packingLists').doc(item.id).delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Item deleted successfully"),
                  backgroundColor: const Color(0XFF0066CC),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Color(0XFF0066CC)),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPackingItemDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final itemController = TextEditingController();
    final quantityController = TextEditingController();
    final descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add New Item",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF0066CC),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: itemController,
                label: "Item Name*",
                icon: Icons.luggage,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Item name is required';
                  }
                  if (value.length > 20) {
                    return 'Maximum 20 characters allowed';
                  }
                  return null;
                },
                maxLength: 20,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: quantityController,
                label: "Quantity (optional)",
                icon: Icons.confirmation_number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: descriptionController,
                label: "Description (optional)",
                icon: Icons.description,
                maxLines: 2,
                maxLength: 100,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0XFF0066CC)),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Color(0XFF0066CC)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await _firestore.collection('packingLists').add({
                            'item': itemController.text,
                            'quantity': quantityController.text.isEmpty
                                ? null
                                : int.parse(quantityController.text),
                            'description': descriptionController.text,
                            'userId': _user?.uid,
                            'createdAt': Timestamp.now(),
                            'isPacked': false,
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Item added successfully"),
                              backgroundColor: const Color(0XFF0066CC),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF0066CC),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditPackingItemDialog(BuildContext context, DocumentSnapshot item) {
    final data = item.data() as Map<String, dynamic>;
    final formKey = GlobalKey<FormState>();
    final itemController = TextEditingController(text: data['item']);
    final quantityController = TextEditingController(
        text: data['quantity']?.toString() ?? '');
    final descriptionController = TextEditingController(text: data['description'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Item",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF0066CC),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: itemController,
                label: "Item Name*",
                icon: Icons.luggage,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Item name is required';
                  }
                  if (value.length > 20) {
                    return 'Maximum 20 characters allowed';
                  }
                  return null;
                },
                maxLength: 20,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: quantityController,
                label: "Quantity",
                icon: Icons.confirmation_number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: descriptionController,
                label: "Description",
                icon: Icons.description,
                maxLines: 2,
                maxLength: 100,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0XFF0066CC)),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Color(0XFF0066CC)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await _firestore.collection('packingLists').doc(item.id).update({
                            'item': itemController.text,
                            'quantity': quantityController.text.isEmpty
                                ? null
                                : int.parse(quantityController.text),
                            'description': descriptionController.text,
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Item updated successfully"),
                              backgroundColor: const Color(0XFF0066CC),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF0066CC),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0XFF0066CC)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0XFF0066CC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0XFF0066CC), width: 2),
        ),
      ),
    );
  }
}