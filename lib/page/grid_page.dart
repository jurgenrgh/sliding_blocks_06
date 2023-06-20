import 'package:flutter/material.dart';

//
//This is a simple GridView with no attempt to animate.
//The next more complicated sample is board_page
//
class GridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.blue[100],
        body: Center(
          child: Container(
            color: Colors.blue[100],
            width: 400,
            height: 500,
            child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 4,
                children: <Widget>[
                  for (var i = 1; i <= 20; i++)
                    Text(
                      i.toString(),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    )
                ]),
          ),
        ),
      );
}
