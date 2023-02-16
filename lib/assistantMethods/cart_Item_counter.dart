import 'package:flutter/cupertino.dart';
import 'package:cakery_app_users_app/global/global.dart';

class CartItemCounter extends ChangeNotifier{


  int cartListItemCounter = sharedPreferences!.getStringList("userCart")!.length - 1 ;
  int get count => cartListItemCounter;

  Future<void> displayCartListItemsNumber() async{
    // firebasede garabgeValue olduğu için -1 yapıyoruz garabageValue yu dikkate almamak için
    cartListItemCounter= sharedPreferences!.getStringList("userCart")!.length - 1;

    await Future.delayed(const Duration(milliseconds: 100), (){
     notifyListeners();
    }
    );
  }
}