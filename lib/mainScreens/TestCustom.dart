import 'dart:io';
import 'package:cakery_app_users_app/global/global.dart';
import 'package:cakery_app_users_app/mainScreens/home_screen.dart';
import 'package:cakery_app_users_app/models/menus.dart';
import 'package:cakery_app_users_app/widgets/error_dialog.dart';
import 'package:cakery_app_users_app/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

class TestCustom extends StatefulWidget {
  final Menus? model;
  TestCustom({this.model});

  @override
  _TestCustomState createState() => _TestCustomState();
}

class _TestCustomState extends State<TestCustom> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  final List<String> sizeOptions = [
    '4 serving',
    '6 serving',
    '12 serving',
    '24 serving'
  ];
  final List<String> flavorOptions = ['Vanilla', 'Chocolate', 'Strawberry'];
  final List<String> toppingOptions = ['Sprinkles', 'Chocolate chips', 'Fruit'];
  final List<String> orderOptions = ['Delivery', 'Takeout', 'Eat in'];

  String selectedSize = '4 serving';
  String selectedFlavor = 'Vanilla';
  String selectedTopping = 'Sprinkles';
  String selectedOrderType = 'Delivery';


  void _addToCart() {
    print('Added to cart:');
    print(' - Size: $selectedSize');
    print(' - Flavor: $selectedFlavor');
    print(' - Topping: $selectedTopping');
    print(' - Order Type: $selectedOrderType');
  }

  clearItemUploadForm() {
    setState(() {
      String selectedSize = '4 serving';
      String selectedFlavor = 'Vanilla';
      String selectedTopping = 'Sprinkles';
      String selectedOrderType = 'Delivery';
    });
  }

  final picker = ImagePicker();



    pickImageFromGallery() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dropdown Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Dropdown Demo'),
        ),
        body: Column(
          children: [
            if (imageXFile != null) Image.file(File(imageXFile!.path)),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: pickImageFromGallery,
                        child: Text('Pick Image'),
                      ),
                      SizedBox(height: 16.0),
                      DropdownButton<String>(
                        value: selectedSize,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSize = newValue!;
                          });
                        },
                        items: sizeOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.0),
                      DropdownButton<String>(
                        value: selectedFlavor,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFlavor = newValue!;
                          });
                        },
                        items: flavorOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.0),
                      DropdownButton<String>(
                        value: selectedTopping,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTopping = newValue!;
                          });
                        },
                        items: toppingOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.0),
                      DropdownButton<String>(
                        value: selectedOrderType,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOrderType = newValue!;
                          });
                        },
                        items: orderOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _addToCart,
                        child: Text('Add toCart'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: pickImageFromGallery,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}
