import 'package:cakery_app_users_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import '../assistantMethods/assistant_methods.dart';
import '../models/items.dart';

//user item screenden item detail screene geçiş yapıyor herhangi itema bastığında
class ItemDetailScreen extends StatefulWidget
{
  final Items? model;
  ItemDetailScreen({this.model});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}




class _ItemDetailScreenState extends State<ItemDetailScreen>
{
  TextEditingController counterTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //seçilen itemın imageı yerleştirildi
          Image.network(widget.model!.thumbnailUrl.toString()),

          //item counter
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: NumberInputPrefabbed.roundedButtons(
              controller: counterTextEditingController,
              incDecBgColor: Colors.pink,
              min: 1,
              max: 9,
              initialValue: 1, //default seçilen item sayısı
              buttonArrangement: ButtonArrangement.incRightDecLeft,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.title.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.longDescription.toString(),
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.price.toString() + " €" ,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),

         const SizedBox(height: 10,),

         Center(
           child: InkWell(
             onTap: () {
               int itemCounter = int.parse(counterTextEditingController.text);

               //1-check if the item exists already in cart


               //2- call add to cart function
               addItemToCart(widget.model!.itemID, context, itemCounter);

             },
             child: Container (
               decoration: const BoxDecoration(
                   gradient: LinearGradient(
                     colors: [
                       Colors.white54,
                       Colors.grey,
                     ],
                     begin: const FractionalOffset(0.0, 0.0),
                     end: const FractionalOffset(2.0, 2.0),
                     stops: [0.0, 1.0],
                     tileMode: TileMode.clamp,
                   )
               ),

               width: MediaQuery.of(context).size.width - 13,
               height: 50,
               child: const Center(
                 //Add to cart button
                 child: Text(
                   "Add to Cart",
                   style: TextStyle(color: Colors.pink, fontSize: 15),
                 ),
               ),


             ),

           ),
         ),

        ],
      ),
    );
  }
}
