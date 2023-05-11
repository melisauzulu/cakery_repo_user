import 'dart:convert';

import 'package:cakery_app_users_app/assistantMethods/assistant_methods.dart';
import 'package:cakery_app_users_app/assistantMethods/total_amount.dart';
import 'package:cakery_app_users_app/global/global.dart';
import 'package:cakery_app_users_app/mainScreens/address_screen.dart';
import 'package:cakery_app_users_app/models/items.dart';
import 'package:cakery_app_users_app/splashScreen/splash_screen.dart';
import 'package:cakery_app_users_app/widgets/app_bar.dart';
import 'package:cakery_app_users_app/widgets/cart_item_design.dart';
import 'package:cakery_app_users_app/widgets/progress_bar.dart';
import 'package:cakery_app_users_app/widgets/text_widget_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../assistantMethods/cart_Item_counter.dart';

class CartScreen extends StatefulWidget {

  final String? sellerUID;
  CartScreen({this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;
  num totalAmount = 0;

  @override
  void initState(){
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);


    //separateItemQuantityList = separateItemQuantities();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        flexibleSpace:Container(
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
              )
          ),
        ) ,
        //Item pagede sol üste back button yerleştirildi
        leading: IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: ()
            {
              //we do NOT allow users to buy cakes from different bakeries in one order
              //you need to place different orders for different bakeries
              //this is why we replaced the back button with clear function
              clearCartNow(context);
            }
        ),
        title: const Text(
          "Cakery",
          style: TextStyle(fontSize: 45, fontFamily: "Signatra"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [

          // whenever you want to add a button or a text widget at the right side of an appBar in flutter, the news basically this atciton

          Stack(
            children: [
              IconButton(
                // how much items has been there in the card already,
                // or if there is no one nor items already the card, then it will
                // display zero again unless you are two items into the display two
                icon: Icon(Icons.shopping_cart, color: Colors.white,),
                onPressed: (){

                  //display message
                  //since we are already on the cart screen
                  print("clicked");

                },
              ),
              Positioned(
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.brightness_1_rounded,
                        size: 20.0,
                        color: Colors.purpleAccent,
                      ),
                      Positioned(
                        top: 3,
                        right: 4,
                        child: Center(
                          child: Consumer<CartItemCounter>(
                            builder: (context, counter, c){
                              return Text(
                                counter.count.toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              );
                            },
                          ),

                        ),
                      ),

                    ],
                  )),
            ],
          ),



        ],
      ),
      floatingActionButton: Row(
        
        mainAxisAlignment: MainAxisAlignment.spaceAround, //there will be 2 buttons on the bottom-they'll have space in between
        children:[
          const SizedBox(width: 12 ,),
            Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                heroTag: "btn1",
                label: const Text("Clear Cart", style: TextStyle(fontSize: 15)),
                backgroundColor: Colors.pink,
                icon: const Icon(Icons.clear_all),
                onPressed:() {
                  //call clearCartNow function 
                  
                  clearCartNow(context);

                  Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));

                  //display message
                  Fluttertoast.showToast(msg: "Cart has been cleared. ");
                  

                } ,

              ),
            ),

              Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                heroTag: "btn2",
                label: const Text("Check Out",style: TextStyle(fontSize: 15),),
                backgroundColor: Colors.pink,
                icon: const Icon(Icons.navigate_next),
                onPressed:() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c)=>AddressScreen(
                            totalAmount: totalAmount.toDouble(),
                            sellerUID: widget.sellerUID,
                          ),
                      ),
                  );

                } ,

              ),
            ),

        ],
      ),
      body: CustomScrollView(
        slivers: [

          //overall total amount
          SliverPersistentHeader(
              pinned:true,
              delegate: TextWidgetHeader(title: "My Cart List")
          ),

          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c)
            {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: cartProvider.count ==0
                      ? Container()
                      :Text(
                          "Total Price: " + amountProvider.tAmount.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                        ),
                ),
              );
            }),
          ),


          // display cart items with quantity number
          //this query is for displaying the items from the items collection from the cartlist 
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection("users").doc(firebaseAuth.currentUser!.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SliverToBoxAdapter(child: Center(child: circularProgress()),);
              }

              // Extract the "userCart" array from the document
              List<dynamic> userCart = snapshot.data!.get("userCart");

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("items").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text("Error: ${snapshot.error}"),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    );
                  }
                  List<String> cartItemIDs=[];

                  // Build a list of cart items based on the "userCart" array
                  List<Items> cartItems = [];
                  Iterable cartItemIds = userCart;
                  for (var item in cartItemIds) {
                    cartItemIDs.add(item.toString());
                    String itemId = item.toString().split(":")[0]; // Extract the item ID from the cart item string
                    var matchingItems = snapshot.data!.docs.where((doc) => doc.get("itemID") == itemId);
                    if (matchingItems.isNotEmpty) {
                      cartItems.add(Items.fromJson(matchingItems.first.data() as Map<String, dynamic>));
                    }
                  }
                  if (cartItemIDs != null) {
                    sharedPreferences?.setStringList("userCartDatabase", cartItemIDs);
                  }
                  List<String>? cartItemStrings2 = sharedPreferences!.getStringList("userCartDatabase");

                  print(cartItemStrings2);
                  // Display the cart items and calculate the total amount
                  double totalAmount = 0;
                  if (cartItems.isNotEmpty) {
                    for (var i = 0; i < cartItems.length; i++) {
                      totalAmount += cartItems[i].price!;
                    }
                    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                      // Display the total amount
                      Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(totalAmount);
                    });
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return CartItemDesign(
                          model: cartItems[index],
                          context: context,
                          //TODO: this sets the item quantity of many items çok benzeri seller order tarafında var
                            //DONE! FIXED
                          quanNumber: int.parse(separateOrderItemQuantities(cartItemIDs)[index])
                          //quanNumber: separateOrderItemQuantities[index],
                        );
                      }, childCount: cartItems.length),
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),


    );
  }
}