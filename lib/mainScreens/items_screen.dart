import 'package:cakery_app_users_app/global/global.dart';
import 'package:cakery_app_users_app/models/items.dart';
import 'package:cakery_app_users_app/models/menus.dart';
import 'package:cakery_app_users_app/widgets/items_design.dart';
import 'package:cakery_app_users_app/widgets/sellers_design.dart';
import 'package:cakery_app_users_app/widgets/my_drawer.dart';
import 'package:cakery_app_users_app/widgets/progress_bar.dart';
import 'package:cakery_app_users_app/widgets/text_widget_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ItemsScreen extends StatefulWidget {

  final Menus? model;
  ItemsScreen({this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),

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
        title: const Text(
          "Cakery",
          style: TextStyle(fontSize: 25, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [

          // whenever you want to add a button or a text widget at the right side of an appBar in flutter, the news basically this atciton

          IconButton(
            // how much items has been there in the card already,
            // or if there is no one nor items already the card, then it will
            // display zero again unless you are two items into the display two
            icon: Icon(Icons.shopping_cart, color: Colors.white,),
            onPressed: (){
              // send user to cart screen

            },
          ),
          Positioned(
              child: Stack(
                children: const [
                  Icon(
                    Icons.brightness_1_rounded,
                    size: 20.0,
                    color: Colors.purpleAccent,
                  ),
                  Positioned(
                    top: 3,
                    right: 4,
                    child: Center(
                      child: Text("0", style: TextStyle(color: Colors.white, fontSize: 12),),
                    ),
                  ),

                ],
              )),



        ],
      ),

      body:CustomScrollView(
          slivers:[
// menünün içindeki ürünleri gösteren kısım
            SliverPersistentHeader(pinned:true, delegate: TextWidgetHeader(title: "Items of" + widget.model!.menuTitle.toString())),
            StreamBuilder <QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("sellers")
                  .doc(widget.model!.sellerUID)
                  .collection("menus")
                  .doc(widget.model!.menuID)
                  .collection("items")
                  .orderBy("publishDate", descending: true) //menü sıralaması yeniden eskiye
                  .snapshots(),

              builder: ((context, snapshot) {

                return !snapshot.hasData //if data not exists
                    ? SliverToBoxAdapter(
                  child:Center(child:circularProgress(),),

                )
                    : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                  itemBuilder: (context,index){


                    Items model = Items.fromJson(

                      snapshot.data!.docs[index].data()! as Map<String, dynamic>,

                    );
                    return ItemsDesignWidget(
                      model:model,
                      context: context,
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              }),
            ),
          ],
      ),
    );
  }
}