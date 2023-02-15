import 'package:cakery_app_users_app/global/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


//add to cart function
addItemToCart(String? foodItemId, BuildContext context, int itemCounter)
{
  //get the userCart from the local storage using shared preferences
  //assign it to the temporary list
  //add our new item to the temporary list
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  tempList!.add(foodItemId! + ":$itemCounter"); //56557657:7 saving format

  //add/update data to firestore
  FirebaseFirestore.instance.collection("users")
      .doc(firebaseAuth.currentUser!.uid).update({
    "userCart": tempList,
  }).then((value) {

    //display message
    Fluttertoast.showToast(msg: "Item Added Successfully.");

    //update data locally
    sharedPreferences!.setStringList("userCart", tempList);

    //update the badge
  });

}