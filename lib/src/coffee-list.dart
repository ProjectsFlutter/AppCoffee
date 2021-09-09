import 'package:app_coffee/src/coffee-details.dart';
import 'package:app_coffee/src/coffee-home.dart';
import 'package:app_coffee/src/coffee.dart';
import 'package:flutter/material.dart';

const double _initialPage = 5.0;

class CoffeeList extends StatefulWidget {
  @override
  _CoffeeListState createState() => _CoffeeListState();
}

class _CoffeeListState extends State<CoffeeList> {
  double _currentPage = _initialPage;
  int _page = _initialPage.toInt();
  bool _active = false;

  double _begin = 1.0;
  double _end = 0.0;

  double _beginC = 0.0;
  double _endC = 10.0;

  final _pageCoffeeController = PageController(viewportFraction: 0.35, initialPage: _initialPage.toInt());
  final _pageTextController = PageController(initialPage: _initialPage.toInt());

  void _coffeScrollListener() {
    setState(() {
        _currentPage = _pageCoffeeController.page!;
        if(!_active){ _page = _currentPage.toInt();}
    });
  }

  @override
  void initState() {
    _pageCoffeeController.addListener(_coffeScrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _pageCoffeeController.removeListener(_coffeScrollListener);
    _pageCoffeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios),
      //     color: Colors.brown,
      //     onPressed: () {
      //       _close = true;
      //       _begin = 0.0;
      //       _end = 1.0;
      //       _ValidateToExit();
      //       _pageCoffeeController.animateToPage(5,
      //           duration: Duration(seconds: 1), curve: Curves.linear);
      //     },
      //   ),
      // ),
      body: Stack(
        children: [
          _GradientBackground(beginC: _beginC, endC: _endC),
          _GradientCircle(size: _size),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: 60,
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        _active = true;

                        _begin = 0.0;
                        _end = 2.0;

                        _beginC = 10.0;
                        _endC = 0.0;

                        _pageCoffeeController.animateToPage(5, duration: Duration(seconds: 1), curve: Curves.linear).whenComplete(() => 
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CoffeeHome()))
                        );
                      }
                  )
                ],
              ),
            ),
          ),
          Positioned(
              left: 0,
              top: 60,
              right: 0,
              height: 100.0,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: _begin, end: _end),
                builder: (context, value, child) {
                  return Transform.translate( offset: Offset(0, -100 * value), child: child);
                },
                duration: Duration(milliseconds: 600),
                child: Column(
                  children: [
                    _CoffeeName(pageTextController: _pageTextController, size: _size),
                    _CoffeePrice(currentPage: _page)
                  ],
                ),
              )),
          Positioned(
            left: 0,
            right: 0,
            top: 60,
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              child: Transform.scale(
                scale: 1.7,
                alignment: Alignment.bottomCenter,
                child: PageView.builder(
                    controller: _pageCoffeeController,
                    itemCount: coffees.length + 1,
                    scrollDirection: Axis.vertical,
                    onPageChanged: (value) {
                      if (value < coffees.length && !_active) {
                        _pageTextController.animateToPage(value, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                      }
                    },
                    itemBuilder: (context, index) {
                      if (index == 0) return SizedBox.shrink();
                      final _coffee = coffees[index - 1];
                      final _result = _currentPage - index + 1;
                      final _value = -0.4 * _result + 1;
                      final _opacity = _value.clamp(0.0, 1.0);

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              transitionDuration: Duration(microseconds: 650),
                              pageBuilder: (context, animation, _) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: CoffeeDetails(coffee: _coffee),
                                );
                              }
                          )
                          );
                        },
                        child: _CoffeeImage(size: _size, value: _value, opacity: _opacity, coffee: _coffee),
                      );
                    }
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _GradientBackground extends StatelessWidget {
  final double _beginC;
  final double _endC;
  const _GradientBackground({required double beginC, required double endC}) : _beginC = beginC, _endC = endC;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        duration: Duration(seconds: 1),
        tween: Tween(begin: _beginC, end: _endC),
        builder: (context, value, child) {
         return Transform.translate(
              offset: Offset(0, -100 * value), child: child);
        },
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0XFFA89276), Color(0XFFFFFF)]
              )
            )
        )
    );
  }
}

class _CoffeePrice extends StatelessWidget {
  final int _currentPage;
  const _CoffeePrice({required int currentPage}) : _currentPage = currentPage;

  @override
  Widget build(BuildContext context) {
    int _positionPage;
    _positionPage = (_currentPage == coffees.length) ? _currentPage - 1 : _currentPage;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TweenAnimationBuilder<double>(
        key: Key(coffees[_positionPage].name),
        duration: Duration(milliseconds: 300),
        tween: Tween(begin: 0.5, end: 1.0),
        builder: (context, value, child) {
          return Opacity(opacity: value, child: child);
        },
        child: Text('\$${coffees[_positionPage].price.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                color: Colors.brown[400]
            )
        ),
      ),
    );
  }
}

class _CoffeeName extends StatelessWidget {
  const _CoffeeName({required PageController pageTextController, required Size size}): _pageTextController = pageTextController, _size = size;
  final PageController _pageTextController;
  final Size _size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: PageView.builder(
            controller: _pageTextController,
            physics: NeverScrollableScrollPhysics(),
            itemCount: coffees.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: _size.width * 0.1),
                child: Hero(
                  tag: 'text_${coffees[index].name}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      coffees[index].name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[900]
                      ),
                    ),
                  ),
                ),
              );
            }
        )
    );
  }
}

class _GradientCircle extends StatelessWidget {
  final Size _size;
  const _GradientCircle({required Size size}) : _size = size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: -_size.height * 0.22,
      height: _size.height * 0.3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle, 
          boxShadow: [BoxShadow(color: Colors.brown, blurRadius: 90, spreadRadius: 45)]
        ),
      ),
    );
  }
}

class _CoffeeImage extends StatelessWidget {
  final Size _size;
  final double _value;
  final double _opacity;
  final Coffee _coffee;

  const _CoffeeImage({required Size size, required double value, required double opacity, required Coffee coffee}): _size = size, _value = value, _opacity = opacity, _coffee = coffee;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(0.0, _size.height / 2.6 * (1 - _value).abs())
            ..scale(_value),
          child: Opacity(
              opacity: _opacity,
              child: Hero(
                  tag: 'image_${_coffee.name}',
                  child: Image.asset(_coffee.image, fit: BoxFit.fitHeight)
              )
          )
      ),
    );
  }
}
