import 'package:app_coffee/src/coffee-list.dart';
import 'package:app_coffee/src/coffee.dart';
import 'package:flutter/material.dart';
 
class CoffeeHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details){
          if(details.primaryDelta! < -20){
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: Duration(microseconds: 650),
                pageBuilder: (context, animation, _){
                  return FadeTransition(
                    opacity: animation,
                    child: CoffeeList(),
                  );
                }
              )
            );
          }
        },
        child: Stack(
          children: [
            SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0XFFA89276),
                      Color(0XFFFFFF)
                    ]
                  )
                )
              ),
            ),
            Positioned(
              height: _size.height * 0.4,
              right: 0,
              left: 0,
              top: _size.height * 0.06,
              child: Hero(
                tag: coffees[2].name,
                child: Image.asset(coffees[2].image),
              ),
            ),
            Positioned(
              height: _size.height * 0.55,
              right: 0,
              left: 0,
              top: _size.height * 0.15,
              child: Hero(
                tag: coffees[3].name,
                child: Image.asset(coffees[3].image),
              ),
            ),
            Positioned(
              height: _size.height * 0.7,
              right: 0,
              left: 0,
              bottom: 0,
              child: Hero(
                tag: coffees[4].name,
                child: Image.asset(
                  coffees[4].image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              height: _size.height,
              right: 0,
              left: 0,
              bottom: _size.height * -0.8,
              child: Hero(
                tag: coffees[5].name,
                child: Image.asset(
                  coffees[5].image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              height: 140,
              left: 0,
              right: 0,
              bottom: _size.height * 0.25,
              child: Image.asset('assets/logo.png')
            )
          ],
        ),
      )
    );
  }
}