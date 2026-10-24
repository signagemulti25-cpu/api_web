import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_web/glob_variable.dart';
import 'package:app_web/models/vendor.dart';

class VendorController {
  Future<List<Vendor>> loadVendors() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/vendors'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Vendor> vendors = data
            .map((vendor) => Vendor.fromMap(vendor))
            .toList();
        return vendors;
      } else {
        throw Exception('Failed to load vendors');
      }
    } catch (e) {
      throw Exception('Error  to load vendors');
    }
  }
}
