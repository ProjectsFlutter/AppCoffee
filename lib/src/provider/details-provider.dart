import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CoffeeMetaData{
  const CoffeeMetaData(this.imageBytes, this.position, this.size);
  final Uint8List imageBytes;
  final Offset position;
  final Size size;

}
class DetailsProvider with ChangeNotifier {
  int _selectItem = 0;
  double _selectScale = 0.6;
  String _selectTemp = 'hot';
  ValueNotifier<bool> _notifierCoffeAnimation = ValueNotifier(false);
  ValueNotifier<CoffeeMetaData?> _notifierCoffeeImage = ValueNotifier(null);

 get selectItem {
   return _selectItem;
 }

 get selectScale {
   return _selectScale;
 }

 get selectTemp{
    return _selectTemp;
 }

 get notifierCoffeAnimation{
   return _notifierCoffeAnimation;
 }

 get notifierCoffeeImage {
   return _notifierCoffeeImage;
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

void reset(){
  _notifierCoffeAnimation.value = false;
  _notifierCoffeeImage.value = null;
 }
 void startAnimationCoffee(){
   _notifierCoffeAnimation.value = true;
 }

 Future<void> tranformToImage(RenderRepaintBoundary boundary)async{
  final position = boundary.localToGlobal(Offset.zero);
  final size = boundary.size;
  final image = await boundary.toImage();
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  _notifierCoffeeImage.value = CoffeeMetaData(byteData!.buffer.asUint8List(), position, size);
 } 
}