import 'package:cakery_app_users_app/global/global.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //header drawer
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [

                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          sharedPreferences!.getString("photoUrl")!
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "Train"),
                )
              ],
            ),
          ),

          //Body Drawer
        ],
      ),
    );
  }
}
