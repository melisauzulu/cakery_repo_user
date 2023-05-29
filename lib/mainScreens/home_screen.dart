import 'package:cakery_app_users_app/assistantMethods/assistant_methods.dart';
import 'package:cakery_app_users_app/authentication/auth_screen.dart';
import 'package:cakery_app_users_app/authentication/login.dart';
import 'package:cakery_app_users_app/global/global.dart';
import 'package:cakery_app_users_app/models/sellers.dart';
import 'package:cakery_app_users_app/splashScreen/splash_screen.dart';
import 'package:cakery_app_users_app/widgets/sellers_design.dart';
import 'package:cakery_app_users_app/widgets/my_drawer.dart';
import 'package:cakery_app_users_app/widgets/progress_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  // sliderda gözükecek fotoların eklendiği kısım
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

    restrictBlockedUsersFromUsingApp() async {
      await FirebaseFirestore.instance.collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .get().then((snapshot) {
        if(snapshot.data()!["status"] != "not approved"){

          Fluttertoast.showToast(msg: "You have been blocked !");
          firebaseAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
        }
        else{
          clearCartNow(context);

        }


      });

    }

    @override
  void initState() {
    super.initState();
    restrictBlockedUsersFromUsingApp();
    }



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
        elevation: 0.0,
        centerTitle: true,


          title:const Text(

          // sellerın ismini top bar kısımına yazdırıyoruz
         "Cakery",
            style: TextStyle(fontSize:40, letterSpacing: 3,color: Colors.white ,fontFamily: "Signatra"),
        ),
        backgroundColor: Colors.pink,
        ),
      drawer: MyDrawer(),

      body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(

              child: Padding(

                padding: const EdgeInsets.all(20.0),

                  child: Container(
                    // MediaQuery.of(context).size--> there is equity in height according to the screen size
                    // not fixed values

                    height: MediaQuery.of(context).size.height* .3,
                    width: MediaQuery.of(context).size.width,
                    child: CarouselSlider(
                      options: CarouselOptions(
                         height: MediaQuery.of(context).size.height* .4,
                         aspectRatio: 16/9,
                         viewportFraction: 0.8,
                         initialPage: 0,
                         enableInfiniteScroll: true,
                         reverse: true,
                         autoPlay: true,
                         autoPlayInterval: const Duration(seconds: 2),
                         autoPlayAnimationDuration: const Duration(milliseconds: 600),
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
              ),
                )

            ),


          StreamBuilder <QuerySnapshot> //get all document from the sellers collection
          (stream: FirebaseFirestore.instance
          .collection("sellers")
          .snapshots(),
          builder: (context,snapshot){

            return !snapshot.hasData //if data doesn't exist
            ? SliverToBoxAdapter(child: Center(child:circularProgress(),),) //Show a circular progress
            : SliverStaggeredGrid.countBuilder( //else display the sellers

            crossAxisCount: 1,
            staggeredTileBuilder:(c)=> StaggeredTile.fit(1) ,
            itemBuilder: (context, index) {
              Sellers sModel=Sellers.fromJson(
                snapshot.data!.docs[index].data()! as Map <String,dynamic>

                );

                //Design for displaying sellers
                return SellersDesignWidget(
                  // we are displaying all the sellers on the users app homescreen
                  model:sModel,
                  context: context,




                  );

         },

            //Number of bakeries in total
            itemCount: snapshot.data!.docs.length,

            );

          }
          ),



          ],

      ),
    );
  }
}