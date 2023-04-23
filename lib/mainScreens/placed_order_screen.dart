import 'package:cakery_app_users_app/assistantMethods/assistant_methods.dart';
import 'package:cakery_app_users_app/global/global.dart';
import 'package:cakery_app_users_app/mainScreens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PlacedOrderScreen extends StatefulWidget {
  String? addressID;
  double? totalAmount;
  String? sellerUID;

  PlacedOrderScreen({this.sellerUID, this.totalAmount, this.addressID});


  @override
  _PlacedOrderScreenState createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {

  String orderId = DateTime.now().millisecondsSinceEpoch.toString();

  addOrderDetails() {
    writeOrderDetailsForUser(
        {
          "addressID": widget.addressID,
          "totalAmount": widget.totalAmount,
          "orderBy": sharedPreferences!.getString("uid"),
          "productIDs": sharedPreferences!.getStringList("userCartDatabase"),
          "paymentDetails": "Cash on Delivery",
          "orderTime": orderId,
          "isSuccess": true,
          "sellerUID": widget.sellerUID,
          "riderUID": "",
          "status": "normal",
          "orderID": orderId,


        }
    );

    writeOrderDetailsForSeller({
        "addressID": widget.addressID,
        "totalAmount": widget.totalAmount,
        "orderBy": sharedPreferences!.getString("uid"),
        "productIDs": sharedPreferences!.getStringList("userCartDatabase"),
        "paymentDetails": "Cash on Delivery",
        "orderTime": orderId,
        "isSuccess": true,
        "sellerUID": widget.sellerUID,
        "riderUID": "",
        "status": "normal",
        "orderID": orderId,
    }).whenComplete(() {
      clearCartNow(context);
      setState(() {
        orderId="";
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
        Fluttertoast.showToast(msg: "Congratulations, Order has been placed successfully");

      });


    });
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async{
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  Future writeOrderDetailsForSeller(Map<String, dynamic> data) async{
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set(data);
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(2.0, 2.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images_user/delivery.jpg"),

            const SizedBox(height: 12,),

            ElevatedButton(
              child: const Text("Place Order"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
              ),
              onPressed: ()
              {
                addOrderDetails();

              },

            ),

          ],
        ),
        

      ),
    );
  }
}
