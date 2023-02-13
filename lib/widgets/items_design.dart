import 'package:cakery_app_users_app/models/items.dart';
import 'package:cakery_app_users_app/models/sellers.dart';
import 'package:flutter/material.dart';



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

      splashColor: Colors.pink[50],
      child:Padding(
        padding: const EdgeInsets.all(5.0), //bakeryler arası mesafe
        child: Container(
            height:300,
            width: MediaQuery.of(context).size.width,
            child:SingleChildScrollView(
              child: Column(
                children: [
                  Divider(

                    height: 4,
                    thickness: 3,
                    color:Colors.pink[100],

                  ),
                  Image.network(
                    widget.model!.thumbnailUrl!,
                    height:250,
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
                     fontSize:12,
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