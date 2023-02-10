import 'package:cakery_app_users_app/authentication/auth_screen.dart';
import 'package:cakery_app_users_app/global/global.dart';
import 'package:cakery_app_users_app/widgets/my_drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

    final items = [
        "slider/cake_1.jpg",
        "slider/cake_2.jpg",
        "slider/cake_3.jpg",
        "slider/cake_4.jpg",
        "slider/cake_5.jpg",
        "slider/cake_6.jpg",
        "slider/cake_7.jpg",
        "slider/cake_8.jpg",
        "slider/cake_9.jpg",
        "slider/cake_10.jpg",
        "slider/cake_11.jpg",
        "slider/cake_12.jpg",
        "slider/cake_13.jpg",
        "slider/cake_14.jpg",
        "slider/cake_15.jpg",
        "slider/cake_16.jpg",
        "slider/cake_17.jpg",
        "slider/cake_18.jpg",
        "slider/cake_19.jpg",
        "slider/cake_20.jpg",
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
         flexibleSpace:Container(
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
            ) ,

              
          title: Text(

             
          // sellerın ismini top bar kısımına yazdırıyoruz
          sharedPreferences!.getString("name")!,
          

        ),
        centerTitle: true,
        automaticallyImplyLeading: true, //drawer button
        
        ),
      drawer: MyDrawer(),

      body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(

              child: Padding(

                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: MediaQuery.of(context).size.height* .3,
                  width: MediaQuery.of(context).size.width,
                  child: CarouselSlider(
                    options: CarouselOptions(
                       height: MediaQuery.of(context).size.height* .3,
                       aspectRatio: 16/9,
                       viewportFraction: 0.8,
                       initialPage: 0,
                       enableInfiniteScroll: true,
                       reverse: false,
                       autoPlay: true,
                       autoPlayInterval: Duration(seconds: 2),
                       autoPlayAnimationDuration: Duration(milliseconds: 600),
                       autoPlayCurve: Curves.easeInOut,
                       enlargeCenterPage: true,
                       //enlargeFactor: 0.3,              
                       scrollDirection: Axis.horizontal,
                  ),

                

                 items: items.map((index) {

                    return Builder(builder: (BuildContext_context) {
                    return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                    decoration: BoxDecoration(
                      color:Colors.pink[100] 
                      ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child:Image.asset(
                        index, 
                        fit: BoxFit.fill,
                      ),
                    ),

                      );
                    });

                  }).toList(),

                ),
              )

            ),
            ),

          ],

      ),
    );
  }
}