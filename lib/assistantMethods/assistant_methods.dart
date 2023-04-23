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
Future<List<String>> cartItemsMethod() async {
  final uid = firebaseAuth.currentUser!.uid;
  final docSnapshot = await FirebaseFirestore.instance.collection("users").doc(uid).get();

  if (docSnapshot.exists) {
    final data = docSnapshot.data() as Map<String, dynamic>;
    final userCart = data["userCart"] as List<dynamic>;
    final cartItems = userCart.cast<String>().toList().sublist(1); // exclude first item
    return cartItems;
  } else {
    return [];
  }
}


Future<List<String>> cartItems() async {
  // Get a reference to the current user's document in the "users" collection
  DocumentReference userRef =
  FirebaseFirestore.instance.collection("users").doc(firebaseAuth.currentUser!.uid);

  // Fetch the user's document from Firebase Firestore
  DocumentSnapshot userDoc = await userRef.get();

  // Extract the "userCart" array from the document and exclude the first item
  List<dynamic> userCart = userDoc.get("userCart").sublist(1);

  // Convert the "userCart" array to a List<String>
  List<String> cartItems =
  userCart.map((item) => item.toString().split(":")[0]).toList();

  // Print the list of cart items to the console
  print(cartItems);

  return cartItems;
}


seperateItemIDsDatabase(){
  // Get a reference to the current user's document in the "users" collection
DocumentReference userRef = FirebaseFirestore.instance.collection("users").doc(firebaseAuth.currentUser!.uid);
List<String> separateItemIDsList2=[];
// Fetch the user's document from Firebase Firestore
userRef.get().then((doc) {
  // Extract the "userCart" array from the document
  List<dynamic> userCart = doc.get("userCart");

  // Convert the "userCart" array to a List<String>
  List<String> defaultItemList = userCart.map((item) => item.toString()).toList();
  int i=0;
  // Print the list of cart items to the console
  print(defaultItemList);
    for(i; i<defaultItemList.length; i++){
      if(i==0){
        continue;
      }
    //56557657:7
    // :7 this column counter
    String item=defaultItemList[i].toString();
    var pos = item.lastIndexOf(":"); //56557657:7 saving format

           //56557657
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\nThis is itemID now = " + getItemId);
      separateItemIDsList2.add(getItemId);

    // we added the separate item to our this list, which is by the name separate item IDs list
      separateItemIDsList2.add(getItemId);

  }
  
  print("\n This is itemID now = " );
  print(separateItemIDsList2);

  return separateItemIDsList2;

}).catchError((error) {
  print("Failed to fetch user cart: $error");
});
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