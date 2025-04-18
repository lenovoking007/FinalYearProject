import 'package:flutter/material.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({Key? key}) : super(key: key);

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  // Default values for currency data
  String sourceCurrency = "USD";
  String targetCurrency = "PKR";
  double exchangeRate = 0.0;
  String conversionAmount = "1.0";
  double convertedAmount = 0.0;

  final TextEditingController amountController = TextEditingController();

  // Currency options for source and target
  List<String> currencies = ["USD", "EUR", "GBP", "PKR", "JPY", "INR"];

  @override
  void initState() {
    super.initState();
    // Initially set the exchange rate (USD to PKR)
    exchangeRate = _getExchangeRate(sourceCurrency, targetCurrency);
    _convertCurrency();
  }

  // Method to simulate currency conversion (This would be replaced by an actual API in a real app)
  void _convertCurrency() {
    setState(() {
      double amount = double.tryParse(amountController.text) ?? 1.0;
      convertedAmount = amount * exchangeRate; // Convert based on exchange rate
    });
  }

  // Simulated method to get exchange rate for the selected currencies
  double _getExchangeRate(String source, String target) {
    // Here you would use an API to fetch actual exchange rates, for simplicity, static values are used
    if (source == "USD" && target == "PKR") return 286.5; // Example exchange rate (USD to PKR)
    if (source == "EUR" && target == "PKR") return 306.2; // Example exchange rate (EUR to PKR)
    if (source == "GBP" && target == "PKR") return 358.1; // Example exchange rate (GBP to PKR)
    if (source == "INR" && target == "PKR") return 3.8; // Example exchange rate (INR to PKR)
    if (source == "JPY" && target == "PKR") return 2.2; // Example exchange rate (JPY to PKR)
    return 1.0; // Default (if source == target)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Currency Converter",
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
        child: ListView(
          children: [
            // Source Currency Dropdown
            _buildCurrencyDropdown("Select Source Currency", sourceCurrency, (String? value) {
              setState(() {
                sourceCurrency = value!;
                exchangeRate = _getExchangeRate(sourceCurrency, targetCurrency);
                _convertCurrency();
              });
            }),
            const SizedBox(height: 12),
            // Target Currency Dropdown
            _buildCurrencyDropdown("Select Target Currency", targetCurrency, (String? value) {
              setState(() {
                targetCurrency = value!;
                exchangeRate = _getExchangeRate(sourceCurrency, targetCurrency);
                _convertCurrency();
              });
            }),
            const SizedBox(height: 20),
            // Amount Field
            _buildAmountField("Enter Amount", amountController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _convertCurrency();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF0066CC),
                minimumSize: const Size(294.57, 43.24),
              ),
              child: const Text(
                "Convert Currency",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Conversion Result Card
            _buildResultCard("Converted Amount", convertedAmount.toStringAsFixed(2), Icons.currency_exchange),
          ],
        ),
      ),
    );
  }

  // Builds a dropdown for currency selection
  Widget _buildCurrencyDropdown(String label, String selectedValue, ValueChanged<String?> onChanged) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.arrow_drop_down_circle, color: Color(0XFF0066CC)),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          onChanged: onChanged,
          items: currencies.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Builds a text field for entering the amount to convert
  Widget _buildAmountField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
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
          suffixIcon: const Icon(
            Icons.money,
            size: 24,
            color: Color(0XFF0066CC),
          ),
        ),
      ),
    );
  }

  // Builds a card for displaying the converted amount
  Widget _buildResultCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0XFF0066CC)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
    );
  }
}


