import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:app_web/models/category.dart';
import 'package:app_web/controllers/category_controller.dart';
import 'package:app_web/controllers/subcategory_controller.dart';
import 'package:app_web/views/side_bar_screens/widgets/subcategory_widget.dart';

class SubcategoryScreen extends StatefulWidget {
  static const String id = '/subCategoryScreen';
  const SubcategoryScreen({super.key});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  final SubcategoryController subcategoryController = SubcategoryController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Category>> futureCategories;
  late String name;
  Category? selectedCategory;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    futureCategories = CategoryController().loadCategories();
    print(futureCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "SubCategories",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Divider(color: Colors.grey),
            ),
        
            FutureBuilder(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error : ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No Categories'));
                } else {
                  return DropdownButton<Category>(
                    value: selectedCategory,
                    hint: Text('Select Category'),
                    items: snapshot.data!.map((Category category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                      print(selectedCategory!.name);
                    },
                  );
                }
              },
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
                        : Text("SubCategory Image"),
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
                      labelText: "Enter sub Category Name",
                    ),
                  ),
                ),
        
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await subcategoryController.uploadSubcateogry(
                        categoryId: selectedCategory!.id,
                        categoryName: selectedCategory!.name,
                        pickedImage: _image,
                        subCategoryName: name,
                        context: context,
                      );
        
                      setState(() {
                        _formKey.currentState!
                            .reset(); //clear form value after send
                        _image = null;
                      });
                    }
                    ;
                  },
                  child: Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: pickImage,
                child: Text("Pick Image", style: TextStyle(color: Colors.white)),
              ),
            ),
        
            Divider(color: Colors.grey),
            SubcategoryWidget(),
          ],
        ),
      ),
    );
  }
}
