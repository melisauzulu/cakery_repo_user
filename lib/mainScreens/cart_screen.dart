import 'package:cakery_app_users_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {

  final String? sellerUID;
  const CartScreen({this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  void initState(){
    super.initState();
    
      }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: MyAppBar(sellerUID: widget.sellerUID,),
      floatingActionButton: Row(
        
        mainAxisAlignment: MainAxisAlignment.spaceAround, //there will be 2 buttons on the bottom-they'll have space in between
        children:[
          SizedBox(width: 12 ,),
            Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                label: const Text("Clear Cart", style: TextStyle(fontSize: 15)),
                backgroundColor: Colors.pink,
                icon: const Icon(Icons.clear_all),
                onPressed:() {
                  

                } ,

              ),
            ),

              Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                label: const Text("Check Out",style: TextStyle(fontSize: 15),),
                backgroundColor: Colors.pink,
                icon: const Icon(Icons.navigate_next),
                onPressed:() {
                  



                } ,

              ),
            ),

        ]),


    );
  }
}