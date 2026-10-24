import 'package:flutter/material.dart';
import 'package:app_web/models/buyer.dart';
import 'package:app_web/models/vendor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_web/controllers/buyer_controller.dart';
import 'package:app_web/controllers/vendor_controller.dart';

class VendorWidget extends StatefulWidget {
  const VendorWidget({super.key});

  @override
  State<VendorWidget> createState() => _VendorWidgetState();
}

class _VendorWidgetState extends State<VendorWidget> {
  late Future<List<Vendor>> futureVendors;

  @override
  void initState() {
    super.initState();
    futureVendors = VendorController().loadVendors();
  }

  @override
  Widget build(BuildContext context) {
    Widget buyerData(int flex, Widget widget) {
      return Expanded(
        flex: flex,

        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
          ),
          child: Padding(padding: EdgeInsets.all(8), child: widget),
        ),
      );
    }

    return FutureBuilder(
      future: futureVendors,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error : ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Banners'));
        } else {
          final vendors = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
            itemCount: vendors.length,

            itemBuilder: (context, index) {
              final vendor = vendors[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    buyerData(
                      1,
                      CircleAvatar(
                        child: Text(
                          vendor.fullName[0],
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    buyerData(
                      3,
                      Text(
                        vendor.fullName,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    buyerData(
                      2,
                      Text(
                        vendor.email,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    buyerData(
                      2,
                      Text(
                        "${vendor.state} ${vendor.city}",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    buyerData(
                      1,
                      TextButton(onPressed: () {}, child: Text('Delete')),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
    ;
  }
}
