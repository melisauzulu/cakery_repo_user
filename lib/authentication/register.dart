import 'dart:io';
import 'package:cakery_app_users_app/global/global.dart';
import 'package:cakery_app_users_app/mainScreens/home_screen.dart';
import 'package:cakery_app_users_app/widgets/custom_text_field.dart';
import 'package:cakery_app_users_app/widgets/error_dialog.dart';
import 'package:cakery_app_users_app/widgets/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  XFile? imageXFile; // register sayfasında resim yüklememizi saglayan kısım
  final ImagePicker _picker= ImagePicker();


  String sellerImageUrl = "";
  LocationPermission? permission;



  Future<void> _getImage() async{

    imageXFile=await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }



  Future<void> formValidation() async{ //runs when user clicks on sign up button
    if(imageXFile == null){
      showDialog(
          context: context,
          builder: (c){
            return ErrorDialog(
              message: "Please select an image ! ",
            );
          }
      );
    }
    else{
      if(passwordController.text == confirmpasswordController.text){


        // confirm passwordunu doğrulama kısmını boş olmamasını kontrol ediyoruz
        if(confirmpasswordController.text.isNotEmpty && emailController.text.isNotEmpty && nameController.text.isNotEmpty && phoneController.text.isNotEmpty ){
          //start uploading image
          showDialog(
              context: context,
              builder: (c){
                return LoadingDialog(
                  message: "Registering account",

                );

              }
              );

              // after successfully uploading the image to the storage basically it gives us a download URL
              // and we serve that we assign that download URL to our seller
              String fileName = DateTime.now().millisecondsSinceEpoch.toString();
              fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("users").child(fileName);
              fStorage.UploadTask uploadTask= reference.putFile(File(imageXFile!.path));
              fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
              await taskSnapshot.ref.getDownloadURL().then((url){
                sellerImageUrl=url;

                // save info to firestore

                authenticateSellerAndSignUp();


          });



        }
        else{
          showDialog(
              context: context,
              builder: (c){
                return ErrorDialog(
                  message: "Please werite the complete required info for Registration ! ",
                );
              }
          );

        }
      }
      else{
        showDialog(
            context: context,
            builder: (c){
              return ErrorDialog(
                message: "Password do not match ! ",
              );
            }
        );

      }

    }
  }

  void authenticateSellerAndSignUp() async{
    //creates user ID and password inside the Firebase authentication

    User? currentUser;
    // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    // bu global.dart'ın içinde tanımlandığı için burdan silindi !
    
    await firebaseAuth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
       password: passwordController.text.trim(),
       ).then((auth) {

          currentUser= auth.user;

       }).catchError((error){
          Navigator.pop(context);
           showDialog(
            context: context,
            builder: (c){
              return ErrorDialog(
                message: error.message.toString(),
              );
            }
        );


       });

       if(currentUser != null){
        saveDataToFirestore(currentUser!).then((value) {

          Navigator.pop(context);
          //send user to home page
          Route newRoute= MaterialPageRoute(builder: (c) => HomeScreen());
          Navigator.pushReplacement(context, newRoute);

        });
       }



  }

  Future saveDataToFirestore(User currentUser) async{
    // this function basically we will pass user reviews from Firebase

    //saving to the firestore database
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({

      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": nameController.text.trim(),
      "photoUrl": sellerImageUrl,
      "phone": phoneController.text.trim(),
      "status": "approved",
      "userCart": ['garbage.value'],
      "customCart": [],

    });

      //saving the data locally
      sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences!.setString("uid", currentUser.uid);
      await sharedPreferences!.setString("email", currentUser.email.toString());
      await sharedPreferences!.setString("name", nameController.text.trim());
      await sharedPreferences!.setString("photoUrl", sellerImageUrl);
      await sharedPreferences!.setStringList("userCart", ['garbage.value']); //empty cart - temporary list of items

  }




// enable false olunca, bosluklara yazi yazilmamaktadır
  @override
  Widget build(BuildContext context) {
    // Sign up sayfasinda resim ayarlanan kısım
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 15,),
            InkWell(
              onTap: (){
                // sign up sayfasında resim seçtiren kısım
                _getImage();
              },
              child: CircleAvatar(

                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage: imageXFile==null ? null : FileImage(File(imageXFile!.path)),
                child: imageXFile == null?
                Icon(
                  Icons.add_photo_alternate,
                  size: MediaQuery.of(context).size.width * 0.20,
                  color: Colors.grey,
                ) : null

              ),
            ),
            const SizedBox(height: 15,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: "Name",
                    isObsecre: false,

                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Password",
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: confirmpasswordController,
                    hintText: "Confirm Password",
                    isObsecre: true,

                  ),
                  CustomTextField(
                    data: Icons.phone,
                    controller: phoneController,
                    hintText: "Phone",
                    isObsecre: false,

                  ),
                ],
              ),
            ),
            const SizedBox(height: 15,),
            ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[300],
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              onPressed: (){
                formValidation();

              },
              child: const Text(
                "Sign Up",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
              ),
            ),
            const SizedBox(height: 15,),
          ],
        ),
      ),
    );

  }
}
