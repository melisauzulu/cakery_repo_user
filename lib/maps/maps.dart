import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
class MapsUtils{

  MapsUtils._();
// latitude longitude
  static Future<void> openMapWithPosition(double latitude, double longitude) async{

    String googleMapUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    // ignore: deprecated_member_use
    if(await launch(googleMapUrl)){
      // ignore: deprecated_member_use
      await launch(googleMapUrl);
    }
    else{
      throw "Could not open the map ! ";
    }


  }

  static Future<void> openMapWithAddress(String fullAddress) async{

    String query = Uri.encodeComponent(fullAddress);
    String googleMapUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    // if(await canLaunch(googleMapUrl)){  !!
    // Bİ HATA ÇIKARSA BUNU YAZIN

    // ignore: deprecated_member_use
    if(await launch(googleMapUrl)){
      // ignore: deprecated_member_use
      await launch(googleMapUrl);
    }
    else{
      throw "Could not open the map ! ";
    }
  }
}

