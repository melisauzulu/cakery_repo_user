import 'package:cakery_app_users_app/mainScreens/home_screen.dart';
import 'package:cakery_app_users_app/models/address.dart';
import 'package:flutter/material.dart';


class ShipmentAddressDesign extends StatelessWidget {
  final Address? model;

  ShipmentAddressDesign({this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(11.0),
          child: Text(
            'Shipping Details: ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text(
                      "Name: ",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(model!.name!),
                ],
              ),
              TableRow(
                children: [
                  const Text(
                    "Phone: ",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(model!.phoneNumber!),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,

        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            model!.fullAddress!,
            textAlign: TextAlign.justify,
          ),
        ),


        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.pink,
                        Colors.grey,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(2.0, 2.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    )
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: const Center(
                  child: Text(
                      "Go Back",
                  style: TextStyle(color: Colors.white, fontSize: 15.0),

                  ),
                ),
              ),
            ),
          ),
        )

      ],
    );
  }
}
