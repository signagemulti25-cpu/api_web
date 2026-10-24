import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_web/glob_variable.dart';
import 'package:app_web/models/category.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:app_web/services/manage_http_response.dart';

class CategoryController {
  uploadCategory({
    required dynamic pickedImage,
    required dynamic pickedBanner,
    required String name,
    required context,
  }) async {
    try {
      final cloudinary = CloudinaryPublic("dcspbth5g", "fwkm0p3w");

      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'pickedImage',
          folder: "categoryImages",
        ),
      );
      String image = imageResponse.secureUrl;
      CloudinaryResponse bannerResonse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedBanner,
          identifier: 'pickedBanner',
          folder: "categoryImages",
        ),
      );
      String banner = bannerResonse.secureUrl;
      Category category = Category(
        id: '',
        name: name,
        image: image,
        banner: banner,
      );
      http.Response response = await http.post(
        Uri.parse('$uri/api/categories/'),
        body: category.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Uploaded Category Sucessfully');
        },
      );
    } catch (e) {
      print("Error occured $e");
    }
  }

  Future<List<Category>> loadCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/categories'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        // Convert each item directly from Map
        return data.map<Category>((map) => Category.fromJson(map)).toList();
      } else {
        print("Failed to load categories: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error loading categories: $e");
      return [];
    }
  }
}
