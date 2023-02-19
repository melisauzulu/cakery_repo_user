import 'package:cakery_app_users_app/mainScreens/save_address_screen.dart';
import 'package:cakery_app_users_app/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {

  final double? totalAmount;
  final String? sellerUID;

  AddressScreen({this.totalAmount, this.sellerUID});


  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add New Address"),
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.add_location_alt, color: Colors.white,),
        onPressed: (){

          //save address to user collection
          Navigator.push(context, MaterialPageRoute(builder: (c)=>SaveAddressScreen()));
        },


      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Select Address: ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,

                ),

              ),
            ),
          ),
        ],
      ),
    );
  }
}
