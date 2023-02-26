import 'package:cakery_app_users_app/assistantMethods/assistant_methods.dart';
import 'package:cakery_app_users_app/assistantMethods/total_amount.dart';
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


    separateItemQuantityList = separateItemQuantities();

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
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("items")
                .where("itemID", whereIn: separateItemIDs())
                .orderBy("publishDate", descending: true)
                .snapshots(),

            builder: (context, snapshot){

              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  :snapshot.data!.docs.length == 0
                  ?// startBuildingCart()
                      Container()
                  :SliverList(
                     delegate: SliverChildBuilderDelegate((context,index){
                        Items model = Items.fromJson(
                          snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                         );

                        //calculate total amount
                        if(index == 0)
                        //case for first item on the cart
                        {
                          totalAmount =0;
                          totalAmount = totalAmount + (model.price! * separateItemQuantityList![index]);
                        }
                        else
                        {
                          totalAmount = totalAmount + (model.price! * separateItemQuantityList![index]);

                        }

                        if(snapshot.data!.docs.length - 1 == index)
                        {
                          WidgetsBinding.instance!.addPostFrameCallback((timeStamp)
                          {
                            //display total amount
                           Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(totalAmount.toDouble());
                          });
                        }

                      return CartItemDesign(
                         model: model,
                         context: context,
                         quanNumber: separateItemQuantityList![index],
                      );
                    },
                      childCount: snapshot.hasData ? snapshot.data!.docs.length: 0,
                    ),
                  );
            },
          ),
        ],
      ),

    );
  }
}