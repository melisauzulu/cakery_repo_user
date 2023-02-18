import 'package:flutter/widgets.dart';
//class to calculate total amount
class TotalAmount extends ChangeNotifier
{
  double _totalAmount = 0;
  
  double get tAmount => _totalAmount;
  
  displayTotalAmount(double number) async {
    _totalAmount = number;
    
    await Future.delayed(const Duration(milliseconds: 100), ()
        {
          notifyListeners();
        }
    );
  }
}