import 'dart:convert';

//Our model class 

class Sellers{

String? sellerName;
String? sellerUID;
String?  sellerAvatarUrl;
String? sellerEmail;

Sellers({ //Constructor

this.sellerName,
this.sellerUID,
this.sellerAvatarUrl,
this.sellerEmail,

});

//Retrieve information from firestore in form of json
Sellers.fromJson(Map<String, dynamic> json){

sellerName= json["sellerName"];
sellerUID= json["sellerUID"];
sellerAvatarUrl= json["sellerAvatarUrl"];
sellerEmail= json["sellerEmail"];
}

Map <String,dynamic>toJson(){

final Map<String,dynamic> data=new Map<String,dynamic>();

data["sellerName"]=this.sellerName;
data["sellerUID"]=this.sellerUID;
data["sellerAvatarUrl"]=this.sellerAvatarUrl;
data["sellerEmail"]=this.sellerEmail;

return data;

}
}