import 'package:cakery_app_users_app/mainScreens/menus_screen.dart';
import 'package:cakery_app_users_app/models/sellers.dart';
import 'package:flutter/material.dart';



class SellersDesignWidget extends StatefulWidget {//this class will recieve these 2 parameters
 
Sellers? model;
BuildContext? context;

SellersDesignWidget({this.model, this.context});



  @override
  State<SellersDesignWidget> createState() => _SellersDesignWidgetState();
}

class _SellersDesignWidgetState extends State<SellersDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MenusScreen(model: widget.model )));
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
                  widget.model!.sellerAvatarUrl!,
                  height:250,
                  fit:BoxFit.cover,

                ),

                const SizedBox(height: 10.0,),
                Text(
                  widget.model!.sellerName!,
                  style:const TextStyle(
                    color:Colors.black,
                    fontSize:25,
                    fontFamily: "Signatra",
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