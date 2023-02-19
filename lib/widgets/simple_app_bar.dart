import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget with PreferredSizeWidget{

  final PreferredSizeWidget? bottom;

  SimpleAppBar({this.bottom});

  @override
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {


    return  AppBar(
      iconTheme: const IconThemeData(
        // geri gitme tuşunun rengi adrres secren ekranında
        color: Colors.white,
      ),
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
            tileMode: TileMode.clamp, ),
        ),
      ) ,
      centerTitle: true,

      title:const Text(

        // sellerın ismini top bar kısımına yazdırıyoruz
        "Cakery",
        style: TextStyle(fontSize:40, letterSpacing: 3,color: Colors.white ,fontFamily: "Signatra"),
      ),
    );
  }
}
