import 'dart:io';
import 'package:cakery_app_users_app/assistantMethods/assistant_methods.dart';
import 'package:cakery_app_users_app/mainScreens/items_screen.dart';
import 'package:cakery_app_users_app/models/items.dart';
import 'package:cakery_app_users_app/widgets/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import 'package:number_inc_dec/number_inc_dec.dart';

import '../global/global.dart';
import '../models/sellers.dart';
import '../widgets/error_dialog.dart';
import '../widgets/progress_bar.dart';
import 'home_screen.dart';

class CustomCarptim extends StatefulWidget 
{

  final Sellers? modelSeller;
  final Items? model; 
  CustomCarptim({this.model, this.modelSeller});

  @override
  _CustomCarptimState createState() => _CustomCarptimState();
}

class _CustomCarptimState extends State<CustomCarptim> {
  Items? model;
  Sellers? modelSeller;
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController counterTextEditingController = TextEditingController();

  final List<String> flavorOptions = [
    'Vanilla',
    'Chocolate',
    'Strawberry',
    'Bubble'
  ];
  final List<String> toppingOptions = ['Sprinkles', 'Chocolate chips', 'Fruit'];
  final List<String> orderOptions = ['Delivery', 'Takeout', 'Eat in'];

  final List<String> sizeOptions = [
    '4 serving',
    '6 serving',
    '12 serving',
    '24 serving'
  ];

  String selectedSize = '4 serving';
  String selectedFlavor = 'Vanilla';
  String selectedTopping = 'Sprinkles';
  String selectedOrderType = 'Delivery';
  String downloadURL="";
  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  itemsUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.white54,
              Colors.grey,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(2.0, 2.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        title: const Text(
          "Uploading New Item",
          style: TextStyle(fontSize: 15, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {

            Navigator.push(context, MaterialPageRoute(builder: (c) =>  const HomeScreen()));
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              // add butonuna tıkladığımızda yapabileceğimiz aksiyonları gösterdiğimiz kısım
              " ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Varela",
                letterSpacing: 3,
              ),
            ),
            
            onPressed: uploading ? null : () => validateUploadForm(),

            // we are cheking that if uploading is true there and doing nothing means nothing else do validateUploadForm
          ),
        ],
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (imageXFile == null)
                  ElevatedButton(
                    child: const Text(
                      "Add Photo",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.pink),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: () {
                      takeImage(context);
                    },
                  )
                else
                  Container(
                    height: 230,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: FileImage(File(imageXFile!.path)),
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),
                    ),
                  ),
                ListTile(
                  leading: const Icon(
                    Icons.title,
                    color: Colors.white,
                  ),
                  title: Container(
                    width: 250,
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: "Custom Item Title",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.pink,
                  thickness: 1,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.perm_device_information,
                    color: Colors.white,
                  ),
                  title: Container(
                    width: 250,
                    child: TextField(
                      // menu bilgisinin girildiği kısım
                      style: const TextStyle(color: Colors.black),
                      controller: shortInfoController,
                      decoration: const InputDecoration(
                        hintText: "Custom Cake Description",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.pink,
                  thickness: 1,
                ),
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
                const Divider(
                  color: Colors.pink,
                  thickness: 1,
                ),
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
                const Divider(
                  color: Colors.pink,
                  thickness: 1,
                ),
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
                const Divider(
                  color: Colors.pink,
                  thickness: 1,
                ),
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
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: NumberInputPrefabbed.roundedButtons(
                    controller: counterTextEditingController,
                    incDecBgColor: Colors.pink,
                    min: 1,
                    max: 9,
                    initialValue: 1, //default seçilen item sayısı
                    buttonArrangement: ButtonArrangement.incRightDecLeft,
                  ),
                ),
                //TODO: ADD QUANTİTY INFO
                ElevatedButton(
                    child: const Text(
                      "Send Cake For Approval",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.pink),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: () {

                      //TODO: If cake already on approval this can cause an error so check same cake
                      validateUploadForm();

                    },
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }





  clearMenusUploadForm() {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      imageXFile = null;
      priceController.clear();
    });
  }

  validateUploadForm() async {
    setState(() {
      uploading = true;
    });

    if (shortInfoController.text.isNotEmpty &&
        titleController.text.isNotEmpty) {
      setState(() {
        uploading = true;
      });
      // upload image
      downloadURL = await uploadImage(File(imageXFile!.path));
      // save info to firebase
      saveInfo(downloadURL);
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              // eğer title ve info girmezse bu hata çıkıcak
              message: "Please write title and info for Custom Cake to inform seller.",
            );
          });
    }
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            "Menu Image",
            style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              onPressed: CaptureImageWithCamera,
              child: const Text(
                "Capture with Camera",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SimpleDialogOption(
              onPressed: pickImageFromGallery,
              child: const Text(
                "Select from Gallery",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SimpleDialogOption(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  CaptureImageWithCamera() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;
    });
  }

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

  saveInfo(String downloadUrl) {
    //saving menu information to database at this reference

    final ref = FirebaseFirestore.instance.collection("requested_cakes");

    //created sub collection by the name item for specific menus to keep the record

    ref.doc(uniqueIdName).set({
      //saving keys to database for items

      "itemID": uniqueIdName,
      "sellerUID": widget.modelSeller?.sellerUID!, 
      "userID": sharedPreferences!.getString("uid")!,
      "status": "waiting",

    }).then((value) {
      //save it as a main items collection
      final itemsRef = FirebaseFirestore.instance.collection("items");

      itemsRef.doc(uniqueIdName).set({
        "itemID": uniqueIdName,
        "sellerUID": widget.modelSeller?.sellerUID!,
        "sellerName": widget.modelSeller?.sellerName!,
        "shortInfo": shortInfoController.text.toString(),
        "title": titleController.text.toString(),
        "serving": selectedSize,
        "selectedFlavor": selectedFlavor,
        "selectedTopping": selectedTopping,
        "selectedOrderType": selectedOrderType,
        "publishDate": DateTime.now(),
        "status": "available",
        "responseMessage": "waiting",
        "thumbnailUrl": downloadUrl,
        "price": 0,
        "quantity":int.parse(counterTextEditingController.text),
      });
    }).then((value) {
      clearMenusUploadForm();
      Fluttertoast.showToast(
          msg: "Custom Cake Request Succsessfully Delivered.");
      //addItemToCart(uniqueIdName,context,1);

      setState(() {
        uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
        uploading = false;
      });

      Navigator.pop(context);
    });
  }

  uploadImage(mImageFile) async {
    // WE cleared a reference to infer storage and inside the item folder
    // we want to put our file, reference to our child
    //we serve that reference and references to the items
    // we have to basically get the download, which we cant get using the task snapshot
    // we implement that and using the task snapshot, we get the download URL of the uploaded image
    //and then we return the download URL
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child("items");
    storageRef.UploadTask uploadTask =
        reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return itemsUploadFormScreen();
  }
}
