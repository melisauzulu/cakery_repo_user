import 'package:cakery_app_users_app/models/items.dart';
import 'package:flutter/material.dart';

class CartItemDesign extends StatefulWidget {

  final Items? model;
  BuildContext? context;
  final int? quanNumber;

  CartItemDesign({

    this.model,
    this.context,
    this.quanNumber,
  });


  @override
  _CartItemDesignState createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.pink,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          height: 110,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [

              // image
              Image.network(widget.model!.thumbnailUrl!, width: 140, height: 120,),
              const SizedBox(width: 6,),

              //title
              //quantity
              //price

              // we want to display any quantity number
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // title
                  Text(
                    widget.model!.title!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontFamily: "Kiwi"
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),

                  // quantity number  //  x 7
                  Row(
                    children: [
                      const Text(
                        "x ",
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 23,
                            fontFamily: "Acme"
                        ),
                      ),
                      Text( // x 7
                        // this will display the total number of quantites that is quantity number
                       widget.quanNumber.toString(),
                        style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 23,
                            fontFamily: "Acme"
                        ),
                      ),
                    ],
                  ),

                  //price
                  Row(
                    children: [
                     const Text(
                        "Price: ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.pink,
                        ),
                      ),
                      const Text(
                        "€ ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.pink,
                        ),
                      ),
                      Text(
                        widget.model!.price.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.pink,
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
