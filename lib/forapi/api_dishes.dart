import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchDishes() async {
  final response = await http.get(Uri.parse('https://run.mocky.io/v3/aba7ecaa-0a70-453b-b62d-0e326c859b3b'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<Map<String, dynamic>> dishes = List<Map<String, dynamic>>.from(data['dishes']);
    return dishes;
  } else {
    throw Exception('Failed to fetch dishes from API');
  }
}
