import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchCategories() async {
  final response = await http.get(Uri.parse('https://run.mocky.io/v3/058729bd-1402-4578-88de-265481fd7d54'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final categories = data['сategories'] as List<dynamic>?;

    if (categories != null) {
      return categories.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Categories data is missing or null');
    }
  } else {
    throw Exception('Failed to fetch categories from API');
  }
}
