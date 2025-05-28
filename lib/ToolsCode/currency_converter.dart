import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:travelmate/services/currency_api_service.dart';
import 'package:travelmate/utils/date_formatter.dart';
import 'package:travelmate/utils/currency_names.dart';
import '../model/currency_model.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final CurrencyApiService _currencyApiService = CurrencyApiService();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _fromAmountController = TextEditingController();
  final TextEditingController _toAmountController = TextEditingController();
  String _searchQuery = '';
  String _fromCurrency = 'PKR';
  String _toCurrency = 'USD';
  double _exchangeRate = 0.0;
  String? _errorMessage;
  bool _isCalculating = false;
  bool _initialLoad = true;
  bool _conversionDone = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialRates();
    _fromAmountController.addListener(_updateButtonState);
    _toAmountController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {});
  }

  Future<void> _fetchInitialRates() async {
    try {
      final result = await _currencyApiService.fetchCurrencyRates();
      final rates = result.rates;
      setState(() {
        _exchangeRate = (_toCurrency == 'USD')
            ? 1.0 / (rates['PKR'] ?? 1.0)
            : (rates[_toCurrency] ?? 1.0) / (rates['PKR'] ?? 1.0);
        _initialLoad = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load initial rates: ${e.toString()}';
        _initialLoad = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fromAmountController.dispose();
    _toAmountController.dispose();
    super.dispose();
  }

  Future<void> _convertCurrency() async {
    if (_fromAmountController.text.isEmpty && _toAmountController.text.isEmpty) return;

    setState(() {
      _isCalculating = true;
      _conversionDone = true;
    });

    try {
      final result = await _currencyApiService.fetchCurrencyRates();
      final rates = result.rates;

      if (_fromCurrency == _toCurrency) {
        setState(() {
          _exchangeRate = 1.0;
          if (_fromAmountController.text.isNotEmpty) {
            _toAmountController.text = _fromAmountController.text;
          } else {
            _fromAmountController.text = _toAmountController.text;
          }
          _isCalculating = false;
        });
        return;
      }

      double fromRate = _fromCurrency == 'USD' ? 1.0 : rates[_fromCurrency]?.toDouble() ?? 1.0;
      double toRate = _toCurrency == 'USD' ? 1.0 : rates[_toCurrency]?.toDouble() ?? 1.0;

      if (_fromAmountController.text.isNotEmpty) {
        double usdValue = double.parse(_fromAmountController.text) / fromRate;
        double convertedValue = usdValue * toRate;
        setState(() {
          _exchangeRate = toRate / fromRate;
          _toAmountController.text = convertedValue.toStringAsFixed(2);
          _isCalculating = false;
        });
      } else {
        double usdValue = double.parse(_toAmountController.text) / toRate;
        double convertedValue = usdValue * fromRate;
        setState(() {
          _exchangeRate = toRate / fromRate;
          _fromAmountController.text = convertedValue.toStringAsFixed(2);
          _isCalculating = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to convert currency: ${e.toString()}';
        _isCalculating = false;
      });
    }
  }

  void _showCurrencySelector(BuildContext context, bool isFromCurrency) async {
    final selectedCurrency = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Currency',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0066CC).withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search currency...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF0066CC)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(top: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder<CurrencyModel>(
                      future: _currencyApiService.fetchCurrencyRates(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: SpinKitFadingCircle(
                              color: const Color(0xFF0066CC),
                              size: 50.0,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error loading currencies',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.rates.isEmpty) {
                          return Center(
                            child: Text(
                              'No currency data available',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }

                        final rates = snapshot.data!.rates;
                        final currencies = rates.keys.toList();

                        final filteredCurrencies = _searchQuery.isEmpty
                            ? currencies
                            : currencies.where((currency) {
                          final name = currencyNames[currency] ?? '';
                          return currency.toLowerCase().contains(_searchQuery) ||
                              name.toLowerCase().contains(_searchQuery);
                        }).toList();

                        return ListView.builder(
                          itemCount: filteredCurrencies.length,
                          itemBuilder: (context, index) {
                            final currency = filteredCurrencies[index];
                            return ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0066CC).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    currency,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0066CC).withOpacity(0.9),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                currencyNames[currency] ?? currency,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                currency,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context, currency);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selectedCurrency != null) {
      setState(() {
        if (isFromCurrency) {
          _fromCurrency = selectedCurrency;
        } else {
          _toCurrency = selectedCurrency;
        }
        _toAmountController.clear();
        _fromAmountController.clear();
        _conversionDone = false;
      });

      try {
        final result = await _currencyApiService.fetchCurrencyRates();
        final rates = result.rates;
        setState(() {
          double fromRate = _fromCurrency == 'USD' ? 1.0 : rates[_fromCurrency]?.toDouble() ?? 1.0;
          double toRate = _toCurrency == 'USD' ? 1.0 : rates[_toCurrency]?.toDouble() ?? 1.0;
          _exchangeRate = toRate / fromRate;
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to update exchange rate: ${e.toString()}';
        });
      }
    }
  }

  Widget _buildConversionCard(
      BuildContext context,
      String currencyCode,
      TextEditingController controller,
      bool isFrom,
      ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showCurrencySelector(context, isFrom),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFrom ? 'From' : 'To',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0066CC).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        currencyCode,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0066CC).withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currencyNames[currencyCode] ?? currencyCode,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currencyCode,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isFrom ? Colors.grey[50] : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  hintText: '0.00',
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                readOnly: !isFrom && _conversionDone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _swapCurrencies() {
    setState(() {
      final tempCurrency = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = tempCurrency;
      _exchangeRate = 1 / _exchangeRate;

      final tempAmount = _toAmountController.text;
      _toAmountController.text = _fromAmountController.text;
      _fromAmountController.text = tempAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_initialLoad) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0066CC),
          elevation: 0,
          title: const Text('Currency Converter', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: SpinKitFadingCircle(
            color: const Color(0xFF0066CC),
            size: 50.0,
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0066CC),
          elevation: 0,
          title: const Text('Currency Converter', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0066CC),
        elevation: 0,
        title: const Text('Currency Converter', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0066CC).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.update, color: Color(0xFF0066CC), size: 20),
                  const SizedBox(width: 8),
                  FutureBuilder<CurrencyModel>(
                    future: _currencyApiService.fetchCurrencyRates(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading...');
                      }
                      if (snapshot.hasError) {
                        return const Text('Last Update: N/A');
                      }
                      return Text(
                        DateFormatter.formatApiDate(snapshot.data?.timeLastUpdateUtc ?? 'N/A'),
                        style: TextStyle(
                          color: const Color(0xFF0066CC).withOpacity(0.9),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildConversionCard(
              context,
              _fromCurrency,
              _fromAmountController,
              true,
            ),
            const SizedBox(height: 16),
            IconButton(
              onPressed: _swapCurrencies,
              icon: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.swap_vert,
                  color: Color(0xFF0066CC),
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildConversionCard(
              context,
              _toCurrency,
              _toAmountController,
              false,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (_fromAmountController.text.isNotEmpty || _toAmountController.text.isNotEmpty)
                    ? _convertCurrency
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_fromAmountController.text.isNotEmpty || _toAmountController.text.isNotEmpty)
                      ? const Color(0xFF0066CC)
                      : Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: _isCalculating
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.currency_exchange, color: Colors.white),
                label: Text(
                  _isCalculating ? 'Converting...' : 'Convert Currency',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_conversionDone && (_fromAmountController.text.isNotEmpty || _toAmountController.text.isNotEmpty))
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Conversion Result',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0066CC).withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _fromAmountController.text.isNotEmpty
                            ? '${_fromAmountController.text} $_fromCurrency = ${_toAmountController.text} $_toCurrency'
                            : '${_toAmountController.text} $_toCurrency = ${_fromAmountController.text} $_fromCurrency',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Exchange Rate: 1 $_fromCurrency = ${_exchangeRate.toStringAsFixed(6)} $_toCurrency',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}