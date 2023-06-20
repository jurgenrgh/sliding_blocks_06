import 'package:flutter/material.dart';
import 'dart:math';
import 'package:sliding_blocks_06/widget/data.dart';
import 'package:sliding_blocks_06/widget/state.dart';
import 'package:sliding_blocks_06/widget/functions.dart';
import 'package:sliding_blocks_06/widget/globals.dart';

//////////////////////////////////////////////////////////////
//
//The MovableBlock item is a rectangle with a position, i.e.
//left and top parameters, that dynamically changes position
//by being dragged.
//
//When dragging ends the item is moved to the nearest
//raster position; i.e. the raster point nearest to
//the current (final) left & top values.
//
//Position arguments 'left' and 'top' are raster units, i.e. index of the tile of the
//upper left hand corner.
//Size arguments 'width' and 'height' are integers giving the width
//and height as multiples of the base unit
//Argument base unit is the side length of the base tile. This length
//is given as a real but should have no fractional part to avoid rounding
//errors.
//
class FixedBlock extends StatefulWidget {
  int gameIx = 0;
  int blockIx = 0;
  int leftIx = 0; //left tile index
  int topIx = 0; //top tile index
  int widthTiles; //width nbr of tiles
  int heightTiles; //height nbr of tiles
  double sideLength; //side length of a tile in nominal pixels
  double leftPix = 0.0; //pixel position
  double topPix = 0.0; //pixel position
  double blockWidthPix = 0.0;
  double blockHeightPix = 0.0;

  FixedBlock({
    Key? key,
    required this.gameIx,
    required this.blockIx,
    required this.leftIx,
    required this.topIx,
    required this.widthTiles,
    required this.heightTiles,
    required this.sideLength,
  }) : super(key: key) {
    this.leftPix = (sideLength * leftIx).toDouble();
    this.topPix = (sideLength * topIx).toDouble();
    //print("Input Block x: ${this.leftPix.round()} y: ${this.topPix.round()}");
    this.blockWidthPix = this.widthTiles * this.sideLength;
    this.blockHeightPix = this.heightTiles * this.sideLength;
  }

  @override
  _FixedBlockState createState() {
    return _FixedBlockState(x: this.leftPix, y: this.topPix);
  }
}

class _FixedBlockState extends State<FixedBlock> {
  double x;
  double y;

  Color color = Colors.lightBlue;

  _FixedBlockState({required this.x, required this.y}) {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border(
            left: BorderSide(color: Colors.white, width: 1),
            top: BorderSide(color: Colors.white, width: 1),
            right: BorderSide(color: Colors.black, width: 1),
            bottom: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        width: widget.blockWidthPix,
        height: widget.blockHeightPix,
        child: Center(
          child: Globals.showNumbers
              ? Text(
                  (widget.blockIx + 1).toString(),
                  textAlign: TextAlign.center,
                )
              : Text(""),
        ),
      ),
    );
  }
}
