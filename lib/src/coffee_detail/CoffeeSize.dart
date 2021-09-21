import 'package:app_coffee/src/provider/CoffeeDetailProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeSize extends StatefulWidget {

  @override
  State<CoffeeSize> createState() => _CoffeeSizeState();
}

class _CoffeeSizeState extends State<CoffeeSize> {
  @override
  Widget build(BuildContext context) {
   final _coffeeDetail = Provider.of<CoffeeDetailProvider>(context);
   
    return BottomNavigationBar(
      backgroundColor: Colors.transparent,
      selectedItemColor: Colors.brown,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedFontSize: 18,
      elevation: 0,
      currentIndex: _coffeeDetail.selectItem,
      onTap: (index) => _coffeeDetail.selectItem = index,
      items: [
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/coffees/taza_s.png"), size: 50),
          label: "S",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/coffees/taza_m.png"), size: 65),
          label: "M",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/coffees/taza_l.png"), size: 60),
          label: "L",
        )
      ],
    );
  }
}
