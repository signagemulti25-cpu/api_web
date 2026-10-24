import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_web/glob_variable.dart';
import 'package:app_web/models/subcategory.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:app_web/services/manage_http_response.dart';

class SubcategoryController {
  uploadSubcateogry({
    required String categoryId,
    required String categoryName,
    required dynamic pickedImage,
    required String subCategoryName,
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
      Subcategory subcategory = Subcategory(
        id: '',
        categoryId: categoryId,
        categoryName: categoryName,
        image: image,
        subCategoryName: subCategoryName,
      );

      http.Response response = await http.post(
        Uri.parse('$uri/api/subcategories/'),
        body: subcategory.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "subcateogy uploaded succesfully");
        },
      );
    } catch (e) {
      print("Error occured $e");
    }
  }

  Future<List<Subcategory>> loadSubCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/subcategories'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
   
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Convert each item directly from Map
        List<Subcategory> subcategories = data
            .map<Subcategory>(
              (subcategory) => Subcategory.fromJson(subcategory),
            )
            .toList();
        return subcategories;
      } else {
        print("Failed to load Subcategories: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error loading subcategories: $e");
      return [];
    }
  }
}
