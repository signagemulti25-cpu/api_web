import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app_web/models/banner.dart';
import 'package:app_web/controllers/banner_controller.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  //A future that is hold the bannes that is load from the api controller
  late Future<List<BannerModel>> futureBanners;

  @override
  void initState() {
    super.initState();
    futureBanners = BannerController().loadBanners();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureBanners,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error : ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Banners'));
        } else {
          final banners = snapshot.data!;

          return Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              itemCount: banners.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 16 / 9,
              ),
              itemBuilder: (context, index) {
                final banner = banners[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(banner.image, fit: BoxFit.fill),
                );
              },
            ),
          );
        }
      },
    );
  }
}
