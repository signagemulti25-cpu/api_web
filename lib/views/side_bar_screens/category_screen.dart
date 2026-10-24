import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:app_web/controllers/category_controller.dart';
import 'package:app_web/views/side_bar_screens/widgets/category_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = '/categoryScreen';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController _categoryController = CategoryController();
  String? name;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Uint8List? _bannerImage;
  Uint8List? _image;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
      });
    }
  }

  pickBannerImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result != null) {
      setState(() {
        _bannerImage = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ FIX 1
      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ FIX 2
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Categories",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(color: Colors.grey),
                ),

                Row(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: _image != null
                            ? Image.memory(
                                _image!,
                                // width: 150,
                                // height: 150,
                                // fit: BoxFit.fill,
                              )
                            : Text("No Image Selected"),
                      ),
                    ),

                    SizedBox(width: 10),

                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        onChanged: (value) {
                          name = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter category name';
                          }
                          return null;
                        },

                        decoration: InputDecoration(
                          labelText: "Enter Category Name",
                        ),
                      ),
                    ),

                    TextButton(onPressed: () {}, child: Text("Cancel")),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _categoryController.uploadCategory(
                            pickedImage: _image,
                            pickedBanner: _bannerImage,
                            name: name!,
                            context: context,
                          );
                          setState(() {
                            _formKey.currentState!
                                .reset(); //clear form value after send
                            _image = null;
                            _bannerImage = null;
                          });
                        }
                        ;
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: pickImage,
                  child: Text(
                    "Pick Image",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                Divider(color: Colors.grey),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: _bannerImage != null
                        ? Image.memory(
                            _bannerImage!,
                            // width: 150,
                            // height: 150,
                            // fit: BoxFit.fill,
                          )
                        : Text(
                            "Category Banner",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: pickBannerImage,
                    child: Text(
                      "Pick Image",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Divider(color: Colors.grey),
                CategoryWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
