import 'package:cakery_app_users_app/mainScreens/item_detail_screen.dart';
import 'package:cakery_app_users_app/models/items.dart';
import 'package:cakery_app_users_app/models/sellers.dart';
import 'package:flutter/material.dart';

import '../mainScreens/CustomCarptim.dart';
//import '../mainScreens/TestCustom.dart';
import '../mainScreens/customized_cake_screen.dart';



class ItemsDesignWidget extends StatefulWidget {//this class will recieve these 2 parameters

  Items? model;
  BuildContext? context;

  ItemsDesignWidget({this.model, this.context});



  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c) => ItemDetailScreen(model: widget.model)));

        //itema bastığımızda items detail screena gidiyor
      },

      splashColor: Colors.pink[50],
      child:Padding(
        padding: const EdgeInsets.all(5.0), //bakeryler arası mesafe
        child: Container(
            height:330,
            width: MediaQuery.of(context).size.width,
            child:SingleChildScrollView(
              child: Column(
                children: [
                  Divider(

                    height: 3,
                    thickness: 3,
                    color:Colors.pink[100],

                  ),
                  Image.network(
                    widget.model!.thumbnailUrl!,
                    height:260,
                    fit:BoxFit.cover,

                  ),


                  const SizedBox(height: 10.0,),
                  Text(
                    widget.model!.title!,
                    style:const TextStyle(
                      color:Colors.black,
                      fontSize:20,
                      fontFamily: "Kiwi",
                    ),
                  ),

                  Text(
                    widget.model!.shortInfo!,
                   style:const TextStyle(
                     color:Colors.black,
                     fontSize:15,
                   ),
                   ),

                  Divider(

                    height: 4,
                    thickness: 3,
                    color:Colors.pink[100],


                  ),


                ],),
            )


        ),



      ),
    );
  }
}