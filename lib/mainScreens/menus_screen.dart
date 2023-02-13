import 'package:cakery_app_users_app/global/global.dart';
import 'package:cakery_app_users_app/models/menus.dart';
import 'package:cakery_app_users_app/models/sellers.dart';
import 'package:cakery_app_users_app/widgets/menus_design.dart';
import 'package:cakery_app_users_app/widgets/sellers_design.dart';
import 'package:cakery_app_users_app/widgets/my_drawer.dart';
import 'package:cakery_app_users_app/widgets/progress_bar.dart';
import 'package:cakery_app_users_app/widgets/text_widget_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MenusScreen extends StatefulWidget {

  final Sellers? model;
  MenusScreen({this.model});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
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
          style: TextStyle(fontSize: 40, fontFamily: "Signatra"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,

      ),

      body:CustomScrollView(
          slivers:[

            SliverPersistentHeader(pinned:true, delegate: TextWidgetHeader(title: widget.model!.sellerName.toString() + " Menus")),
            StreamBuilder <QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("sellers")
                  .doc(widget.model!.sellerUID)
                  .collection("menus")
                  .orderBy("publishDate", descending: true) //menü sıralaması yeniden eskiye
                  .snapshots(),

              builder: ((context, snapshot) {

                return !snapshot.hasData //if data not exists
                    ? SliverToBoxAdapter(
                  child:Center(child:circularProgress()),

                )
                    : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                  itemBuilder: (context,index){

                    Menus model = Menus.fromJson(

                      snapshot.data!.docs[index].data()! as Map<String, dynamic>,

                    );
                    return MenusDesignWidget(
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