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
                transitionDuration: Duration(seconds: 1),
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
        // onHorizontalDragUpdate: (details){
        //   if(details.primaryDelta! < -20){
        //     Navigator.of(context).push(
        //       PageRouteBuilder(
        //         transitionDuration: Duration(seconds: 1),
        //         pageBuilder: (context, animation, _){
        //           return FadeTransition(
        //             opacity: animation,
        //             child: CoffeeList(),
        //           );
        //         }
        //       )
        //     );
        //   }
        // },        
        child: Stack(
          children: [
            _GradientBackground(),
            // _Image2(size: _size),
            _Image3(size: _size),
            _Image4(size: _size),
            _Image5(size: _size),
            _CoffeeLogo(size: _size)
          ],
        ),
      )
    );
  }
}

class _Image5 extends StatelessWidget {
  final Size _size;
  const _Image5({required Size size}) : _size = size;

  @override
  Widget build(BuildContext context) {
    final Coffee _coffee = coffees[5];
    return Positioned(
      height: _size.height,
      right: 0,
      left: 0,
      bottom: _size.height * -0.8,
      child: Hero(
        tag: 'image_${_coffee.name}',
        child: Image.asset(
          _coffee.image,
          fit: BoxFit.cover
        ),
      ),
    );
  }
}

class _Image4 extends StatelessWidget {
  final Size _size;
  const _Image4({required Size size}) : _size = size;

  @override
  Widget build(BuildContext context) {
    final Coffee _coffee = coffees[4];
    return Positioned(
      height: _size.height * 0.7,
      right: 0,
      left: 0,
      bottom: 0,
      child: Hero(
        tag: 'image_${_coffee.name}',
        child: Image.asset(
         _coffee.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _Image3 extends StatelessWidget {
  final Size _size;
  const _Image3({required Size size}) : _size = size;

  @override
  Widget build(BuildContext context) {
    final Coffee _coffee = coffees[3];
    return Positioned(
      height: _size.height * 0.55,
      right: 0,
      left: 0,
      top: _size.height * 0.15,
      child: Hero(
        tag: 'image_${_coffee.name}',
        child: Image.asset(_coffee.image),
      ),
    );
  }
}

class _Image2 extends StatelessWidget {
  final Size _size;
  const _Image2({required Size size}) : _size = size;

  @override
  Widget build(BuildContext context) {
    final Coffee _coffee = coffees[2];
    return Positioned(
      height: _size.height * 0.4,
      right: 0,
      left: 0,
      top: _size.height * 0.06,
      child: Hero(
        tag: 'image_${_coffee.name}',
        child: Image.asset(_coffee.image),
      ),
    );
  }
}

class _GradientBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
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
    );
  }
}

class _CoffeeLogo extends StatelessWidget {
  final Size _size;
  const _CoffeeLogo({required Size size}) : _size = size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: 140,
      left: 0,
      right: 0,
      bottom: _size.height * 0.25,
      child: Image.asset('assets/coffees/logo.png')
    );
  }
}