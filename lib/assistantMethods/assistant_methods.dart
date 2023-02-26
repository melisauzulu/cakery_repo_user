import 'package:cakery_app_users_app/assistantMethods/cart_Item_counter.dart';
import 'package:cakery_app_users_app/global/global.dart';
import 'package:cakery_app_users_app/splashScreen/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';



separateOrderItemIDs(oderIDs){

  List<String> separateItemIDsList=[], defaultItemList=[];
  int i=0;

  // defaultItemList contains our items, which is already in the cart
  defaultItemList =List<String>.from(oderIDs);

  for(i; i<defaultItemList.length; i++){

    //56557657:7
    // :7 this column counter
    String item=defaultItemList[i].toString();
    var pos = item.lastIndexOf(":"); //56557657:7 saving format

           //56557657
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\nThis is itemID now = " + getItemId);

    // we added the separate item to our this list, which is by the name separate item IDs list

    separateItemIDsList.add(getItemId);

  }

  print("\n This is itemID now = " );
  print(separateItemIDsList);

  return separateItemIDsList;

}

// which is to check if the item is already  in the cart

separateItemIDs(){

  List<String> separateItemIDsList=[], defaultItemList=[];
  int i=0;

  // defaultItemList contains our items, which is already in the cart
  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for(i; i<defaultItemList.length; i++){

    //56557657:7
    // :7 this column counter
    String item=defaultItemList[i].toString();
    var pos = item.lastIndexOf(":"); //56557657:7 saving format

           //56557657
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\nThis is itemID now = " + getItemId);

    // we added the separate item to our this list, which is by the name separate item IDs list

    separateItemIDsList.add(getItemId);

  }

  print("\n This is itemID now = " );
  print(separateItemIDsList);

  return separateItemIDsList;

}


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
    Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
  });


}
separateOrderItemQuantities(orderIDs){

  List<String> separateItemQuantityList=[];
  List<String> defaultItemList=[];
  int i=1; //to retrieve data from 1st index and skip the garbage value

  // defaultItemList contains our items, which is already in the cart
  defaultItemList = List<String>.from(orderIDs);

  for(i; i<defaultItemList.length; i++){

    //56557657:7
    // :7 this column counter
    String item = defaultItemList[i].toString();
    
   //:7
       List<String> ListItemCharacters = item.split(":").toList();
       var quanNumber = int.parse(ListItemCharacters[1].toString());

    print("\nThis is Quantity Number now = " + quanNumber.toString());

    // we added the separate item to our this list, which is by the name separate item IDs list

    separateItemQuantityList.add(quanNumber.toString());

  }
    print("\n This is Quantity List now = " );
    print(separateItemQuantityList);

  return separateItemQuantityList;
  }
 
separateItemQuantities(){

  List<int> separateItemQuantityList=[];
  List<String> defaultItemList=[];
  int i=1; //to retrieve data from 1st index and skip the garbage value

  // defaultItemList contains our items, which is already in the cart
  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for(i; i<defaultItemList.length; i++){

    //56557657:7
    // :7 this column counter
    String item = defaultItemList[i].toString();
    
   //:7
       List<String> ListItemCharacters = item.split(":").toList();
       var quanNumber = int.parse(ListItemCharacters[1].toString());

    print("\nThis is Quantity Number now = " + quanNumber.toString());

    // we added the separate item to our this list, which is by the name separate item IDs list

    separateItemQuantityList.add(quanNumber);

  }
    print("\n This is Quantity List now = " );
    print(separateItemQuantityList);

  return separateItemQuantityList;
  }

//clear cart function
 clearCartNow(context)
 {
   //user will have the garbage value as in their cart
   sharedPreferences!.setStringList("userCart", ['garbage.value']);
   List<String>? emptyList = sharedPreferences!.getStringList("userCart");

   FirebaseFirestore.instance
       .collection("users")
       .doc(firebaseAuth.currentUser!.uid)
       .update({"userCart": emptyList}).then((value) 
   {
     //list saved locally 
     sharedPreferences!.setStringList("userCart", emptyList!);
     Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();

         
   });


 }