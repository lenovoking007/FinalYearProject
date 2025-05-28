import 'dart:convert';
import 'package:http/http.dart' as http;


import '../model/currency_model.dart';

class CurrencyApiService {
  Future<CurrencyModel> fetchCurrencyRates() async {
    final response = await http.get(
      Uri.parse('https://open.er-api.com/v6/latest/USD'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body.toString());
      return CurrencyModel.fromJson(data);
    } else {
      throw Exception('Failed to load currency rates');
    }
  }
}