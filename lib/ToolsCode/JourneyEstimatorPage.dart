import 'package:flutter/material.dart';

class JourneyEstimatorPage extends StatefulWidget {
  const JourneyEstimatorPage({super.key});

  @override
  State<JourneyEstimatorPage> createState() => _JourneyEstimatorPageState();
}

class _JourneyEstimatorPageState extends State<JourneyEstimatorPage> {
  final TextEditingController _fuelPriceController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  String? _selectedFuelType = 'Petrol';
  String? _selectedVehicleType;
  String? _selectedOwnershipType = 'Personal';
  double _estimatedCost = 0.0;
  double _serviceCharge = 0.0;

  // Vehicle mileage data (km per liter) and base service charges
  final Map<String, Map<String, dynamic>> _vehicleData = {
    'Motorcycle': {'mileage': 40.0, 'serviceCharge': 350.0},
    'Mini Car': {'mileage': 18.0, 'serviceCharge': 800.0},
    'Car': {'mileage': 15.0, 'serviceCharge': 1000.0},
    'SUV': {'mileage': 12.0, 'serviceCharge': 1500.0},
    'Pickup Truck': {'mileage': 10.0, 'serviceCharge': 2000.0},
  };

  void _calculateCost() {
    if (_fuelPriceController.text.isEmpty ||
        _distanceController.text.isEmpty ||
        _selectedVehicleType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final double fuelPrice = double.tryParse(_fuelPriceController.text) ?? 0;
    final double distance = double.tryParse(_distanceController.text) ?? 0;
    final double mileage = _vehicleData[_selectedVehicleType]?['mileage'] ?? 15.0;
    final double serviceCharge = _selectedOwnershipType == 'Rented'
        ? (_vehicleData[_selectedVehicleType]?['serviceCharge'] as double?) ?? 0
        : 0;


    final double fuelCost = (distance / mileage) * fuelPrice;
    final double totalCost = fuelCost + serviceCharge;

    setState(() {
      _estimatedCost = totalCost;
      _serviceCharge = serviceCharge;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF0066CC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Journey Estimator',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(constraints.maxWidth > 600 ? 24 : 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Current Fuel Price (PKR/liter)',
                      hint: 'e.g. 250',
                      icon: Icons.local_gas_station,
                      controller: _fuelPriceController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    _buildDropdownField(
                      label: 'Fuel Type',
                      hint: 'Select fuel type',
                      icon: Icons.inventory,
                      value: _selectedFuelType,
                      items: const ['Petrol', 'Diesel', 'CNG', 'Hybrid'],
                      onChanged: (value) {
                        setState(() {
                          _selectedFuelType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildDropdownField(
                      label: 'Vehicle Type',
                      hint: 'Select your vehicle',
                      icon: Icons.directions_car,
                      value: _selectedVehicleType,
                      items: _vehicleData.keys.toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedVehicleType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildDropdownField(
                      label: 'Ownership Type',
                      hint: 'Select ownership type',
                      icon: Icons.business_center,
                      value: _selectedOwnershipType,
                      items: const ['Personal', 'Rented'],
                      onChanged: (value) {
                        setState(() {
                          _selectedOwnershipType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: 'Distance (km)',
                      hint: 'e.g. 25',
                      icon: Icons.place,
                      controller: _distanceController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFF0066CC),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _calculateCost,
                        child: const Text(
                          'CALCULATE COST',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_estimatedCost > 0) _buildDetailedResultCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0XFF0066CC).withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF88F2E8).withOpacity(0.1),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFF0066CC).withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0066CC)),
            ),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon, color: const Color(0xFF0066CC).withOpacity(0.7)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0XFF0066CC).withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF88F2E8).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF0066CC).withOpacity(0.5),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: value,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(icon, color: const Color(0xFF0066CC)),
            ),
            hint: Text(hint, style: const TextStyle(color: Colors.grey)),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(color: Colors.black87)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedResultCard() {
    final double fuelPrice = double.tryParse(_fuelPriceController.text) ?? 0;
    final double distance = double.tryParse(_distanceController.text) ?? 0;
    final double mileage = _vehicleData[_selectedVehicleType]?['mileage'] ?? 15.0;
    final double fuelUsed = distance / mileage;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              _selectedOwnershipType == 'Rented' ? 'Rental Trip Cost' : 'Personal Trip Cost',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0XFF0066CC),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'PKR ${_estimatedCost.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            _buildCostDetailRow('Distance:', '${distance.toStringAsFixed(1)} km'),
            _buildCostDetailRow('Fuel Price:', 'PKR ${fuelPrice.toStringAsFixed(2)}/liter'),
            _buildCostDetailRow(
                'Fuel Efficiency:',
                '${mileage.toStringAsFixed(1)} km/liter (${_selectedVehicleType})'
            ),
            _buildCostDetailRow(
                'Fuel Needed:',
                '${fuelUsed.toStringAsFixed(2)} liters'
            ),
            if (_selectedOwnershipType == 'Rented') ...[
              const Divider(height: 24, thickness: 1),
              _buildCostDetailRow(
                  'Service Charge:',
                  'PKR ${_serviceCharge.toStringAsFixed(2)}'
              ),
            ],
            const Divider(height: 24, thickness: 1),
            _buildCostDetailRow(
                'Fuel Cost:',
                'PKR ${(_estimatedCost - _serviceCharge).toStringAsFixed(2)}'
            ),
            if (_selectedOwnershipType == 'Rented') _buildCostDetailRow(
                'Total Cost:',
                'PKR ${_estimatedCost.toStringAsFixed(2)}',
                isTotal: true
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? const Color(0XFF0066CC) : Colors.black87,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fuelPriceController.dispose();
    _distanceController.dispose();
    super.dispose();
  }
}