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

class CustomizedCakeScreen extends StatefulWidget {
  final Menus? model;
  CustomizedCakeScreen({this.model});

  @override
  _CustomizedCakeScreenState createState() => _CustomizedCakeScreenState();
}

class _CustomizedCakeScreenState extends State<CustomizedCakeScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  // TextEditingController shortInfoController = TextEditingController();
  // TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController flavourController = TextEditingController();
  TextEditingController fillingController = TextEditingController();
  TextEditingController icingController = TextEditingController();
  TextEditingController toppingController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  customizedCakeFormScreen() {
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
          "Creating New Customized Item",
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
            clearItemUploadForm();
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              // add butonuna tıkladığımızda yapabileceğimiz aksiyonları gösterdiğimiz kısım
              "Order",
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
      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text(""),
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
          const Divider(
            // çizgi ekler araya
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
                style: const TextStyle(color: Colors.black),
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "Cake Description",
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
              Icons.title,
              color: Colors.white,
            ),
            //controller: sizeController,
            title: Container(
              width: 250,
              child: DropdownButtonFormField<String>(
                value: '4 serving', // set default value
                decoration: const InputDecoration(
                  hintText: 'Select a serving size',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),

                onChanged: (String? newValue) {
                  // do something when a new value is selected
                  sizeController.text = newValue ?? '';
                },
                items: <String>[
                  '4 serving',
                  '6 serving',
                  '12 serving',
                  '16 serving',
                  '24 serving'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(
            color: Colors.pink,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.white,
            ),
            title: Container(
              width: 250,
              child: DropdownButtonFormField<String>(
                //controller: flavourController,
                value: 'vanilla', // set default value
                decoration: const InputDecoration(
                  hintText: 'Select a flavour',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: (String? newValue) {
                  // do something when a new value is selected
                  flavourController.text = newValue ?? '';
                },
                items: <String>[
                  'vanilla',
                  'chocolate',
                  'red velvet',
                  'lemon',
                  'carrot'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(
            color: Colors.pink,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.white,
            ),
            title: Container(
              width: 250,
              child: DropdownButtonFormField<String>(
                //controller: fillingController,
                value: 'buttercream', // set default value
                decoration: const InputDecoration(
                  hintText: 'Select a filling',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: (String? newValue) {
                  // do something when a new value is selected
                  fillingController.text = newValue ?? '';
                },
                items: <String>[
                  'buttercream',
                  'chocolate cream',
                  'strawberry cream',
                  'raspberry cream',
                  'cream cheese',
                  'none'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(
            color: Colors.pink,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.white,
            ),
            title: Container(
              width: 250,
              child: DropdownButtonFormField<String>(
                //controller: icingController
                value: 'buttercream', // set default value
                decoration: const InputDecoration(
                  hintText: 'Select an icing',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: (String? newValue) {
                  // do something when a new value is selected
                  icingController.text = newValue ?? '';
                },
                items: <String>[
                  'buttercream',
                  'whipped cream',
                  'chocolate ganache',
                  'meringue',
                  'royal icing',
                  'none'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(
            color: Colors.pink,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.white,
            ),
            //controller: toppingController,
            title: Container(
              width: 250,
              child: DropdownButtonFormField<String>(
                value: 'chocolate chips', // set default value
                decoration: const InputDecoration(
                  hintText: 'Select a topping',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),

                onChanged: (String? newValue) {
                  // do something when a new value is selected
                  toppingController.text = newValue ?? '';
                },
                items: <String>[
                  'chocolate chips',
                  'fresh fruit',
                  'powdered sugar',
                  'whipped cream',
                  'ganache',
                  'none'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(
            color: Colors.pink,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.image,
              color: Colors.white,
            ),
            title: Container(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Upload an image',
                      style: TextStyle(color: Colors.white)),
                  ElevatedButton(
                    onPressed: () {
                      takeImage(context); // call takeImage method
                    },
                    child: const Text('Choose an image',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Colors.white,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: "Total Price",
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
        ],
      ),
    );
  }

  clearItemUploadForm() {
    setState(() {
      priceController.clear();
      descriptionController.clear();
      sizeController.clear();
      flavourController.clear();
      fillingController.clear();
      icingController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    setState(() {
      uploading = true;
    });
    if (imageXFile != null) {
      if (fillingController.text.isNotEmpty &&
          sizeController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          priceController.text.isNotEmpty &&
          flavourController.text.isNotEmpty &&
          icingController.text.isNotEmpty &&
          toppingController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        // upload image
        String downloadURL = await uploadImage(File(imageXFile!.path));
        // save info to firebase
        saveInfo(downloadURL);
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                // eğer title ve info girmezse bu hata çıkıcak
                message: "Please fill the form correctly",
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              // eğer bir fotoğraf yüklemezse menüye bu hata çıkıcak
              message: "Please pick an picture for your cake",
            );
          });
    }
  }

  saveInfo(String downloadUrl) {
    //saving menu information to database at this reference

    final ref = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(widget.model!.menuID)
        .collection("items");
    //created sub collection by the name item for specific menus to keep the record

    ref.doc(uniqueIdName).set({
      //saving keys to database for items

      "itemID": uniqueIdName,
      "menuID": widget.model!.menuID,
      "sellerUID": sharedPreferences!.getString("uid"),
      "sellerName": sharedPreferences!.getString("name"),
      "longDescription": descriptionController.text.toString(),
      "serving": sizeController.text.toString(),
      "flavor": flavourController.text.toString(),
      "filling": fillingController.text.toString(),
      "icing": icingController.text.toString(),
      "topping": toppingController.text.toString(),
      "price": int.parse(priceController.text),
      "publishDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    }).then((value) {
      //save it as a main items collection
      final itemsRef = FirebaseFirestore.instance.collection("items");

      itemsRef.doc(uniqueIdName).set({
        "itemID": uniqueIdName,
        "menuID": widget.model!.menuID,
        "sellerUID": sharedPreferences!.getString("uid"),
        "sellerName": sharedPreferences!.getString("name"),
        "longDescription": descriptionController.text.toString(),
        "serving": sizeController.text.toString(),
        "flavor": flavourController.text.toString(),
        "filling": fillingController.text.toString(),
        "icing": icingController.text.toString(),
        "topping": toppingController.text.toString(),
        "price": int.parse(priceController.text),
        "publishDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
      });
    }).then((value) {
      clearItemUploadForm();
      setState(() {
        uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
        uploading = false;
      });
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
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? CustomizedCakeScreen() : HomeScreen();
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
}
