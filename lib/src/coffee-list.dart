import 'package:app_coffee/src/coffee.dart';
import 'package:flutter/material.dart';

class CoffeeList extends StatefulWidget {
  @override
  _CoffeeListState createState() => _CoffeeListState();
}

class _CoffeeListState extends State<CoffeeList> {
  
  double _currentPage = 0.0;

  final _pageCoffeeController = PageController(
    viewportFraction: 0.35
  );

  void _coffeScrollListener(){
    setState(() {
          _currentPage = _pageCoffeeController.page!;        
        });
  }

  @override
    void initState() {
      _pageCoffeeController.addListener(  _coffeScrollListener );
      super.initState();
    }
  
  @override
    void dispose() {
      _pageCoffeeController.removeListener(  _coffeScrollListener );
      _pageCoffeeController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            left: 20,
            right: 20,
            bottom: -_size.height * 0.22,
            height: _size.height * 0.3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown,
                    blurRadius: 90,
                    spreadRadius: 45
                  )
                ]
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: 100.0,
            child: Container(
              color: Colors.red,
            ) 
          ),
          PageView.builder(
            controller: _pageCoffeeController,
            itemCount: coffees.length + 1,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index){
              if (index == 0) return SizedBox.shrink();

              final _result = _currentPage - index + 1;
              final _value = -0.4 * _result + 1; 
              final _opacity = _value.clamp(0.0, 1.0);

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.identity()
                  ..setEntry(3,2,0.001)
                  ..translate(0.0, _size.height / 2.6 * (1 - _value).abs())
                  ..scale(_value),
                  child: Opacity(
                    opacity: _opacity,
                    child: Image.asset(coffees[index - 1].image)
                  )
                ),
              );
            }
          )
        ],
      ),
    );
  }
}