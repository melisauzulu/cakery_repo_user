import 'package:cakery_app_users_app/mainScreens/items_screen.dart';
import 'package:cakery_app_users_app/models/menus.dart';
import 'package:cakery_app_users_app/models/sellers.dart';
import 'package:flutter/material.dart';



class MenusDesignWidget extends StatefulWidget {//this class will recieve these 2 parameters

  Menus? model;
  BuildContext? context;

  MenusDesignWidget({this.model, this.context});



  @override
  State<MenusDesignWidget> createState() => _MenusDesignWidgetState();
}

class _MenusDesignWidgetState extends State<MenusDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(model: widget.model)));
      },

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
                        widget.model!.menuTitle!,
                        style:const TextStyle(
                          color:Colors.black,
                          fontSize:15,
                          fontFamily: "Kiwi",
                        ),
                    ),
                   Text(
                    widget.model!.menuInfo!,
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