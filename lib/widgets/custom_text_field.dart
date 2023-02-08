import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecre=true;
  bool? enabled = true;

  CustomTextField({
    this.controller,
    this.data,
    this.hintText,
    this.isObsecre,
    this.enabled,
});

  @override
  Widget build(BuildContext context)
  {

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(10)),

      ),
      padding: const EdgeInsets.all(7.0),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: isObsecre!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Colors.black,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,

        ),
      ),
    );
  }
}

