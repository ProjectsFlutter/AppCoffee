import 'package:flutter/material.dart';

class DetailsProvider with ChangeNotifier {
  int _selectItem = 0;
  double _scale = 1.0;

 get selectItem {
   return _selectItem;
 }
 get scale {
   return _scale;
 }
 set selectItem (index){
   _selectItem = index;
   switch (_selectItem) {
     case 0:
        _scale = 1.0;
       break;
     case 1:
        _scale = 1.1;
       break;
     case 2:
        _scale = 1.2;
       break;
   }
   notifyListeners();
 }

}