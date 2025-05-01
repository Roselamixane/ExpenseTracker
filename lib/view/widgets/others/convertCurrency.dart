import 'dart:convert';
import 'package:http/http.dart' as http;

Future<double> convertCurrency(String fromCurrency, String toCurrency, double amount) async {
  final apiKey = '1f226c68ade9fd1ad21bbeaf'; // Your actual API key
  final url =
      'https://v6.exchangerate-api.com/v6/$apiKey/latest/$fromCurrency'; // API endpoint

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      double rate = data['conversion_rates'][toCurrency]; // Extract the conversion rate
      return rate * amount; // Return the converted amount
    } else {
      throw Exception('Failed to fetch data');
    }
  } catch (e) {
    print(e.toString());
    return 0.0; // Return 0 if an error occurs
  }
}
