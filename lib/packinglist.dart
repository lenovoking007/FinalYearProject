import 'package:flutter/material.dart';

class PackingListPage extends StatefulWidget {
  const PackingListPage({Key? key}) : super(key: key);

  @override
  State<PackingListPage> createState() => _PackingListPageState();
}

class _PackingListPageState extends State<PackingListPage> {
  // Default packing list data
  List<Map<String, String>> packingList = [
    {
      'item': 'Passport',
      'quantity': '1',
      'description': 'Essential for international travel.'
    },
    {
      'item': 'Travel Adapter',
      'quantity': '2',
      'description': 'For charging electronics from different countries.'
    },
    {
      'item': 'T-shirt',
      'quantity': '5',
      'description': 'Comfortable clothing for sightseeing.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Packing List",
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
        child: ListView.builder(
          itemCount: packingList.length,
          itemBuilder: (context, index) {
            final item = packingList[index];
            return _buildPackingItemCard(item, index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPackingItemDialog(context),
        backgroundColor: const Color(0XFF0066CC),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Builds a card for displaying each packing item
  Widget _buildPackingItemCard(Map<String, String> item, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Color(0XFF0066CC)),
        title: Text(
          item['item']!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Quantity: ${item['quantity']}',
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handlePackingItemAction(value, item, index),
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
              const PopupMenuItem(
                value: 'view',
                child: Text('View Details'),
              ),
            ];
          },
        ),
      ),
    );
  }

  // Handle packing item action (edit, delete, view)
  void _handlePackingItemAction(String action, Map<String, String> item, int index) {
    switch (action) {
      case 'edit':
        _showEditPackingItemDialog(context, item, index);
        break;
      case 'delete':
        setState(() {
          packingList.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item deleted successfully!")),
        );
        break;
      case 'view':
        _showPackingItemDetailsDialog(context, item);
        break;
    }
  }

  // Show packing item details in a dialog
  void _showPackingItemDetailsDialog(BuildContext context, Map<String, String> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Packing Item Details",
            style: TextStyle(color: Color(0XFF0066CC)),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Item: ${item['item']}'),
                Text('Quantity: ${item['quantity']}'),
                Text('Description: ${item['description']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Color(0XFF0066CC)),
              ),
            ),
          ],
        );
      },
    );
  }

  // Show the add packing item dialog
  void _showAddPackingItemDialog(BuildContext context) {
    TextEditingController itemController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Add Packing Item",
            style: TextStyle(color: Color(0XFF0066CC)),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEditableTextField("Item", itemController, Icons.add_circle_outline),
                _buildEditableTextField("Quantity", quantityController, Icons.confirmation_number),
                _buildEditableTextField("Description", descriptionController, Icons.description),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color(0XFF0066CC)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  packingList.add({
                    'item': itemController.text,
                    'quantity': quantityController.text,
                    'description': descriptionController.text,
                  });
                });
                Navigator.of(context).pop(); // Close dialog after saving
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Packing item added successfully!"),
                  ),
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

  // Show edit packing item dialog
  void _showEditPackingItemDialog(BuildContext context, Map<String, String> item, int index) {
    TextEditingController itemController = TextEditingController(text: item['item']);
    TextEditingController quantityController = TextEditingController(text: item['quantity']);
    TextEditingController descriptionController = TextEditingController(text: item['description']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Edit Packing Item",
            style: TextStyle(color: Color(0XFF0066CC)),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEditableTextField("Item", itemController, Icons.add_circle_outline),
                _buildEditableTextField("Quantity", quantityController, Icons.confirmation_number),
                _buildEditableTextField("Description", descriptionController, Icons.description),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color(0XFF0066CC)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  packingList[index] = {
                    'item': itemController.text,
                    'quantity': quantityController.text,
                    'description': descriptionController.text,
                  };
                });
                Navigator.of(context).pop(); // Close dialog after saving
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Packing item updated successfully!"),
                  ),
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

  // Builds a text field for editing or adding packing item info
  Widget _buildEditableTextField(
      String label, TextEditingController controller, IconData icon) {
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
