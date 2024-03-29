import 'package:cakery_app_users_app/global/global.dart';
import 'package:cakery_app_users_app/models/address.dart';
import 'package:cakery_app_users_app/widgets/simple_app_bar.dart';
import 'package:cakery_app_users_app/widgets/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class SaveAddressScreen extends StatelessWidget {

  final _name = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _flatNumber = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _completeAddress = TextEditingController();
  final _locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Position? position;
  List<Placemark>? placeMarks;
  String sellerImageUrl = "";
  LocationPermission? permission; // !!!!!!!! ÖNEMLİ
  String completeAddress = "";


  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    position = newPosition;

    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];

    String completeAddress = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    //'${pMark.thoroughfare}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.country}';

    _locationController.text = completeAddress;

    _flatNumber.text = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}';
    _city.text = '${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}';
    _state.text = '${pMark.country}';

    _completeAddress.text = completeAddress;

  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar:  SimpleAppBar(title:"Cakery"),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Save Address"),
        icon: const Icon(Icons.save),
        onPressed: ()
        {
          //save address info
          if(formKey.currentState!.validate())
          {
           final model = Address(
             name: _name.text.trim(),
             phoneNumber: _phoneNumber.text.trim(),
             flatNumber: _flatNumber.text.trim(),
             city: _city.text.trim(),
             state: _state.text.trim(),
             fullAddress: _completeAddress.text.trim(),
             lat: position!.latitude,
             lgn: position!.longitude,

           ).toJson();

           FirebaseFirestore.instance.collection("users")
               .doc(sharedPreferences!.getString("uid"))
               .collection("userAddress")
               .doc(DateTime.now().millisecondsSinceEpoch.toString())
               .set(model).then((value)
           {
             Fluttertoast.showToast(msg: "New Address has been saved.");
             formKey.currentState!.reset();
           });
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 6,),
            const Align(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Save New Address: ",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,

                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person_pin_circle_rounded,
                color: Colors.pink,
                size: 33,

              ),
              title: Container(
                width: 250,
                child: TextField(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: "Please enter your address " , // or What's your address ?
                    hintStyle: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6,),

            ElevatedButton.icon(
              label: const Text(
                "Get My Current Location",
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.location_on, color: Colors.white,),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.pink),

                  ),
                ),
              ),
              onPressed: () {
                // get my current location with address
                getCurrentLocation();
              },
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: "Name",
                    controller: _name,
                  ),
                  MyTextField(
                    hint: "Phone Number",
                    controller: _phoneNumber,
                  ),
                  MyTextField(
                    hint: "City",
                    controller: _city,
                  ),
                  MyTextField(
                    hint: "State / Country",
                    controller: _state,
                  ),
                  MyTextField(
                    hint: "Address Line",
                    controller: _flatNumber,
                  ),
                  MyTextField(
                    hint: "Complete Address",
                    controller: _completeAddress,
                  ),
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}
