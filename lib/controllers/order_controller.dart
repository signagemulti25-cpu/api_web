import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_web/models/order.dart';
import 'package:app_web/glob_variable.dart';

class OrderController {
  Future<List<Order>> loadOrders() async {
    try {
      //send http reto get data from response body, fetch list of orders from server
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        //convert the dynamic list into list of order objects
        //why: mapping each json object into an order object,allow us to work with structered data

        List<Order> orders = data
            .map((order) => Order.fromJson(order))
            .toList();
        return orders;
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Error  to load orders $e');
    }
  }
}
