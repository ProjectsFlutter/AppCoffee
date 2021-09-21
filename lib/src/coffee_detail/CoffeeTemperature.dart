import 'package:app_coffee/src/provider/CoffeeDetailProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeTemperature extends StatefulWidget {

  @override
  State<CoffeeTemperature> createState() => _CoffeeTemperatureState();
}

class _CoffeeTemperatureState extends State<CoffeeTemperature> {
  @override
  Widget build(BuildContext context) {
    final _coffeeDetail = Provider.of<CoffeeDetailProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () => _coffeeDetail.selectTemp = 'hot',
            child: Container(
                height: 40.0,
                decoration: (_coffeeDetail.selectTemp == "hot")
                    ? BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(blurRadius: 5.0),
                          BoxShadow(
                              color: Colors.white, offset: Offset(0, -16)),
                          BoxShadow(color: Colors.white, offset: Offset(0, 16)),
                          BoxShadow(
                              color: Colors.white, offset: Offset(-16, -16)),
                          BoxShadow(
                              color: Colors.white, offset: Offset(-16, 16)),
                          BoxShadow(
                              color: Colors.white, offset: Offset(-16, 0)),
                        ],
                      )
                    : null,
                alignment: Alignment.center,
                child: Text('Hot / Warm ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: (_coffeeDetail.selectTemp != "hot")
                          ? Colors.grey[400]
                          : Colors.black,
                    )
                )
            ),
          )
          ),
          Expanded(
            child: GestureDetector(
            onTap: () => _coffeeDetail.selectTemp = 'cold',
            child: Container(
                height: 40.0,
                decoration: (_coffeeDetail.selectTemp == "cold")
                    ? BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(blurRadius: 5.0),
                          BoxShadow(
                              color: Colors.white, offset: Offset(0, -16)),
                          BoxShadow(color: Colors.white, offset: Offset(0, 16)),
                          BoxShadow(
                              color: Colors.white, offset: Offset(16, -16)),
                          BoxShadow(
                              color: Colors.white, offset: Offset(16, 16)),
                          BoxShadow(color: Colors.white, offset: Offset(16, 0)),
                        ],
                    )
                    : null,
                alignment: Alignment.center,
                child: Text('Cold / Ice',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: (_coffeeDetail.selectTemp != "cold")
                          ? Colors.grey[400]
                          : Colors.black,
                    )
                )
            ),
          )
        ),
      ],
    ),
  );
}
}
