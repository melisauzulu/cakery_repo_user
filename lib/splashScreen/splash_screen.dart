import 'dart:async';
import 'package:cakery_app_users_app/authentication/auth_screen.dart';
import 'package:cakery_app_users_app/global/global.dart';
import 'package:cakery_app_users_app/mainScreens/customized_cake_screen.dart';
import 'package:cakery_app_users_app/mainScreens/home_screen.dart';
import 'package:flutter/material.dart';


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}



class _MySplashScreenState extends State<MySplashScreen> {

  startTimer(){

    Timer(const Duration(seconds: 5),  () async {

      if(firebaseAuth.currentUser != null){ // checks if the user is already logged-in/authenticated or not

        Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen())); //if yes, direct user to homescreen

      }

      else{ //if no, diret user to authscreen

        Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));

      }
    });
  }

  @override
  void initState() {
    // this function is called automatically whenever the user comes to their screen
    super.initState();
    startTimer();

  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child:Container(

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white38,
                Colors.pink,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset("images_user/welcome.jpg"),
                ),

                const SizedBox(height: 10,),

                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    // Baslik
                    "Order Cake in Cakery",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      // family ismini pubspec.yaml'daki isimden aldik
                      fontFamily: "Acme",
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ],
            ),

          ),
        )
    );
  }
}