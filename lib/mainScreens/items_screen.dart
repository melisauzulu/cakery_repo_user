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

import '../widgets/app_bar.dart';

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

      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),

      body:CustomScrollView(
          slivers:[
// menünün içindeki ürünleri gösteren kısım burada
            SliverPersistentHeader(pinned:true, delegate: TextWidgetHeader(title: " " + widget.model!.menuTitle.toString())),
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