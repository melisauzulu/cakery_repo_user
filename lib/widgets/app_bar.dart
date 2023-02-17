import 'package:cakery_app_users_app/assistantMethods/cart_Item_counter.dart';
import 'package:cakery_app_users_app/mainScreens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget
{
  final PreferredSizeWidget? bottom;
  final String? sellerUID;
  MyAppBar({this.bottom, this.sellerUID});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          icon: const Icon(Icons.arrow_back),
          onPressed: ()
          {
            Navigator.pop(context);
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
                // send user to cart screen
                Navigator.push(context, MaterialPageRoute(builder: (c) => CartScreen(sellerUID: widget.sellerUID )));
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
    );
  }
}
