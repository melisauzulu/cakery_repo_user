import 'package:cakery_app_users_app/assistantMethods/assistant_methods.dart';
import 'package:cakery_app_users_app/global/global.dart';
import 'package:cakery_app_users_app/mainScreens/home_screen.dart';
import 'package:cakery_app_users_app/models/items.dart';
import 'package:cakery_app_users_app/models/menus.dart';
import 'package:cakery_app_users_app/models/sellers.dart';
import 'package:cakery_app_users_app/splashScreen/splash_screen.dart';
import 'package:cakery_app_users_app/widgets/menus_design.dart';
import 'package:cakery_app_users_app/widgets/sellers_design.dart';
import 'package:cakery_app_users_app/widgets/my_drawer.dart';
import 'package:cakery_app_users_app/widgets/progress_bar.dart';
import 'package:cakery_app_users_app/widgets/text_widget_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'CustomCarptim.dart';

class MenusScreen extends StatefulWidget {
  final Sellers? model;
   final Items? model_item;
  MenusScreen({this.model, this.model_item});



  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {

  void initState() {
    super.initState();
    // Initialization code that only runs once
    clearCartNow(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.pinkAccent,
                Colors.white54,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(2.0, 2.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              clearCartNow(context);

              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const HomeScreen()));
            },
          ),
          title: const Text(
            "Cakery",
            style: TextStyle(fontSize: 40, fontFamily: "Signatra"),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: Column(children: [
          ElevatedButton(
            child: const Text(
              "Add Custom Item",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => CustomCarptim(model: widget.model_item, modelSeller: widget.model ))); //MEL: model: widget.model_item ekledim.


            },
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                    pinned: true,
                    delegate: TextWidgetHeader(
                        title: widget.model!.sellerName.toString() + " Menus")),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("sellers")
                      .doc(widget.model!.sellerUID)
                      .collection("menus")
                      .orderBy("publishDate",
                          descending: true) //menü sıralaması yeniden eskiye
                      .snapshots(),
                  builder: ((context, snapshot) {
                    return !snapshot.hasData //if data not exists
                        ? SliverToBoxAdapter(
                            child: Center(child: circularProgress()),
                          )
                        : SliverStaggeredGrid.countBuilder(
                            crossAxisCount: 1,
                            staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                            itemBuilder: (context, index) {
                              Menus model = Menus.fromJson(
                                snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>,
                              );
                              return MenusDesignWidget(
                                model: model,
                                context: context,
                              );
                            },
                            itemCount: snapshot.data!.docs.length,
                          );
                  }),
                ),
              ],
            ),
          ),
        ]));
  }
}
