import 'package:cakery_app_users_app/widgets/simple_app_bar.dart';
import 'package:cakery_app_users_app/widgets/text_field.dart';
import 'package:flutter/material.dart';

class SaveAddressScreen extends StatelessWidget {

  final _name = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _flatNumber = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _completeAddress = TextEditingController();
  final _locationController = TextEditingController();

  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  SimpleAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Save Address"),
        icon: const Icon(Icons.save),
        onPressed: (){
          //save address info
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
              onPressed: (){
                // get my current location with address
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
