import 'package:flutter/material.dart';

class DetailsProvider with ChangeNotifier {
  int _selectItem = 0;
  double _selectScale = 0.6;
  String _selectTemp = 'hot';

 get selectItem {
   return _selectItem;
 }

 get selectScale {
   return _selectScale;
 }

 get selectTemp{
    return _selectTemp;
 }

 set selectTemp(temp){
   _selectTemp = temp;
   notifyListeners();
 }
 
 set selectItem (index){
   _selectItem = index;
   switch (_selectItem) {
     case 0:
        _selectScale = 0.6;
       break;
     case 1:
        _selectScale = 0.7;
       break;
     case 2:
        _selectScale = 0.9;
       break;
   }
   notifyListeners();
 }

}