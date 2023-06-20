import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GridViewBoard extends StatelessWidget {
  GridViewBoard({
    required this.title,
    required this.gameIx,
    required this.onTap,
    this.color = Colors.blue,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  String title;
  int gameIx;
  final VoidCallback? onTap;
  Color color;
  bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: color,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  title.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              selected ?? false
                  ? Icon(
                Icons.check,
                color: Colors.white,
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );

  }
}
