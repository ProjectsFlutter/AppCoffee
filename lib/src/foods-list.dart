import 'package:app_coffee/src/coffee-list.dart';
import 'package:app_coffee/src/foods.dart';
import 'package:flutter/material.dart';

const double _initialPage = 2.0;

class FoodList extends StatefulWidget {
  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  double _currentPage = _initialPage;
  int _page = _initialPage.toInt();
  bool _active = false;

  double _begin = 1.0;
  double _end = 0.0;

  double _beginC = 0.0;
  double _endC = 10.0;

  final _pageFoodsController = PageController(viewportFraction: 0.35, initialPage: _initialPage.toInt());
  final _pageTextController = PageController(initialPage: _initialPage.toInt());

  void _foodsScrollListener() {
    setState(() {
        _currentPage = _pageFoodsController.page!;
        if(!_active){ _page = _currentPage.toInt();}
    });
  }

  @override
  void initState() {
    _pageFoodsController.addListener(_foodsScrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _pageFoodsController.removeListener(_foodsScrollListener);
    _pageFoodsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          _GradientBackground(beginC: _beginC, endC: _endC),
          _GradientCircle(size: _size),
          Positioned(
            left: _size.width * 0.05 ,
            top: _size.height * 0.13,
            child: Text('Menu',style: TextStyle(
               color: Colors.grey,
               fontSize: 70.0,

             )
            ),
          ),
          Positioned(
              left: 0,
              top: _size.height * 0.3,
              right: 0,
              height: 150.0,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: _begin, end: _end),
                builder: (context, value, child) {
                  return Transform.translate( offset: Offset(0, -100 * value), child: child);
                },
                duration: Duration(milliseconds: 600),
                child: Column(
                  children: [
                    _FoodName(pageTextController: _pageTextController, size: _size),
                    _FoodPrice(currentPage: _page)
                  ],
                ),
              )),
          Positioned(
            left: 0,
            right: 0,
            top: _size.height * 0.04,
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              child: Transform.scale(
                scale: 1.5,
                alignment: Alignment.bottomCenter,
                child: PageView.builder(
                    controller: _pageFoodsController,
                    itemCount: foods.length + 1,
                    scrollDirection: Axis.vertical,
                    onPageChanged: (value) {
                      if (value < foods.length && !_active) {
                        _pageTextController.animateToPage(value, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                      }
                    },
                    itemBuilder: (context, index) {
                      if (index == 0) return SizedBox.shrink();
                      final _foods = foods[index - 1];
                      final _result = _currentPage - index + 1;
                      final _value = -0.5 * _result + 1;
                      final _opacity = _value.clamp(0.0, 1.0);

                      return _FoodsImage(size: _size, value: _value, opacity: _opacity, food: _foods);
                    }
                ),
              ),
            ),
          ),
          Positioned(
            left: _size.width * 0.04,
            top: _size.height * 0.04,
            child: Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        _active = true;

                        _begin = 0.0;
                        _end = 2.0;

                        _beginC = 10.0;
                        _endC = 0.0;

                        _pageFoodsController.animateToPage(2, duration: Duration(seconds: 1), curve: Curves.linear).whenComplete(() => 
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>CoffeeList()))
                        );
                      }
                  )
                ],
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

class _FoodPrice extends StatelessWidget {
  final int _currentPage;
  const _FoodPrice({required int currentPage}) : _currentPage = currentPage;

  @override
  Widget build(BuildContext context) {
    int _positionPage;
    _positionPage = (_currentPage == foods.length) ? _currentPage - 1 : _currentPage;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TweenAnimationBuilder<double>(
          key: Key(foods[_positionPage].name),
          duration: Duration(milliseconds: 300),
          tween: Tween(begin: 0.5, end: 1.0),
          builder: (context, value, child) {
            return Opacity(opacity: value, child: child);
          },
          child: Text('\$${foods[_positionPage].price.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w400,
                  color: Colors.brown[400]
              )
          ),
        ),
      ),
    );
  }
}

class _FoodName extends StatelessWidget {
  const _FoodName({required PageController pageTextController, required Size size}): _pageTextController = pageTextController, _size = size;
  final PageController _pageTextController;
  final Size _size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: PageView.builder(
            controller: _pageTextController,
            physics: NeverScrollableScrollPhysics(),
            itemCount: foods.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: _size.width * 0.1),
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    foods[index].name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[900]
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

class _FoodsImage extends StatelessWidget {
  final Size _size;
  final double _value;
  final double _opacity;
  final Food _food;

  const _FoodsImage({required Size size, required double value, required double opacity, required Food food}): _size = size, _value = value, _opacity = opacity, _food = food;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Transform(
          alignment: Alignment.centerRight,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(0.0, _size.height / 2.5  * (1 - _value).abs())
            ..scale(_value),
          child: Opacity(
              opacity: _opacity,
              child: Image.asset(_food.image, fit: BoxFit.fitHeight)
          )
      ),
    );
  }
}
