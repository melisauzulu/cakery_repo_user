import 'package:cakery_app_users_app/assistantMethods/assistant_methods.dart';
import 'package:cakery_app_users_app/models/items.dart';
import 'package:cakery_app_users_app/widgets/app_bar.dart';
import 'package:cakery_app_users_app/widgets/cart_item_design.dart';
import 'package:cakery_app_users_app/widgets/progress_bar.dart';
import 'package:cakery_app_users_app/widgets/text_widget_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {

  final String? sellerUID;
  const CartScreen({this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  List<int>? separateItemQuantityList;

  @override
  void initState(){
    super.initState();

    separateItemQuantityList = separateItemQuantities();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: MyAppBar(sellerUID: widget.sellerUID,),
      floatingActionButton: Row(
        
        mainAxisAlignment: MainAxisAlignment.spaceAround, //there will be 2 buttons on the bottom-they'll have space in between
        children:[
          SizedBox(width: 12 ,),
            Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                label: const Text("Clear Cart", style: TextStyle(fontSize: 15)),
                backgroundColor: Colors.pink,
                icon: const Icon(Icons.clear_all),
                onPressed:() {
                  

                } ,

              ),
            ),

              Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                label: const Text("Check Out",style: TextStyle(fontSize: 15),),
                backgroundColor: Colors.pink,
                icon: const Icon(Icons.navigate_next),
                onPressed:() {
                  



                } ,

              ),
            ),

        ]),
      body: CustomScrollView(
        slivers: [

          //overall total amount
          SliverPersistentHeader(
              pinned:true,
              delegate: TextWidgetHeader(title: "Total Amount = 120")
          ),

          

          // display cart items with quantity number
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