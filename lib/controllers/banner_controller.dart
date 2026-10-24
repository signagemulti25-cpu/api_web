import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_web/glob_variable.dart';
import 'package:app_web/models/banner.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:app_web/services/manage_http_response.dart';

class BannerController {
  uploadBanner({required dynamic pickedImage, required context}) async {
    //upload banner logic

    try {
      final cloudinary = CloudinaryPublic("dcspbth5g", "fwkm0p3w");
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'pickedImage',
          folder: "banners",
        ),
      );

      String image = imageResponse.secureUrl;

      BannerModel bannerModel = BannerModel(id: '', image: image);
      http.Response response = await http.post(
        Uri.parse('$uri/api/banner'),
        body: bannerModel.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Uploaded Banner Sucessfully');
        },
      );
    } catch (e) {
      print("Error occured $e");
    }
  }

  Future<List<BannerModel>> loadBanners() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/banner'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> banners = data
            .map((banner) => BannerModel.fromJson(banner))
            .toList();
        return banners;
      } else {
        return [];
      }
    } catch (e) {
      print("Error occured $e");
      return [];
    }
  }
}
