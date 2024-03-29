import 'package:cakery_app_users_app/models/sellers.dart';
import 'package:cakery_app_users_app/widgets/sellers_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class SearchScreen extends StatefulWidget
{
  @override
  _SearchScreenState createState() => _SearchScreenState();
}




class _SearchScreenState extends State<SearchScreen>
{
  Future<QuerySnapshot>? restaurantsDocumentsList;
  String sellerNameText = "";

  initSearchingRestaurant(String textEntered) async
  {
    // is grater kısmını değiştirirsen arama kısmında sana farklı sonuçlar gösterebilir,
    // isGreaterThanOrEqualTo,  if it has something matching something small words similar also displayed those results
    restaurantsDocumentsList = FirebaseFirestore.instance
        .collection("sellers")
        .where("sellerName", isGreaterThanOrEqualTo: textEntered)
        .get();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pinkAccent,
                  Colors.white60,
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: TextField(
          onChanged: (textEntered)
          {

            setState(() {
              sellerNameText = textEntered;
            });

            //init search
            initSearchingRestaurant(textEntered);

          },
          decoration: InputDecoration(
            hintText: "Search Bakery",
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search_outlined),
              color: Colors.white,
              onPressed: ()
              {
                initSearchingRestaurant(sellerNameText);
              },
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: restaurantsDocumentsList,
        builder: (context, snapshot)
        {
          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index)
            {
              Sellers model = Sellers.fromJson(
                  snapshot.data!.docs[index].data()! as Map<String, dynamic>
              );

              return SellersDesignWidget(
                model: model,
                context: context,
              );
            },
          )
              : const Center(child: Text("No Record Found"),);
        },
      ),
    );
  }
}
