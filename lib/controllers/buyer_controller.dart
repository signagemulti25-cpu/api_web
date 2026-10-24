import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_web/models/buyer.dart';
import 'package:app_web/glob_variable.dart';

class BuyerController {
  Future<List<Buyer>> loadBuyers() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/users'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Buyer> buyers = data.map((buyer) => Buyer.fromMap(buyer)).toList();
        return buyers;
      } else {
        throw Exception('Failed to load buyers');
      }
    } catch (e) {
      throw Exception('Error  to load buyers');
    }
  }
}
