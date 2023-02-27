import 'package:cakery_app_users_app/mainScreens/home_screen.dart';
import 'package:cakery_app_users_app/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';

class StatusBanner extends StatelessWidget {

  final bool? status;
  final String? orderStatus;

  StatusBanner({this.status, this.orderStatus});


  @override
  Widget build(BuildContext context) {

    String? message;
    IconData? iconData;

    status! ? iconData = Icons.done_sharp : iconData = Icons.cancel_outlined;
    status! ? message = "Successful" : message = "Unsuccessful";

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pinkAccent,
              Colors.grey,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(2.0, 2.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const MySplashScreen()));
              // Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));

            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,

            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            orderStatus == "ended"
                ? "Parcel Delivered $message"
                : "Order Placed $message",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 5,
          ),
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 15,
              ),
            ),
          )
        ],
      ),

    );
  }
}
