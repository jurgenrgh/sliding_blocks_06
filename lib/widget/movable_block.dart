import 'package:flutter/material.dart';
import 'dart:math';
import 'package:sliding_blocks_06/widget/data.dart';
import 'package:sliding_blocks_06/widget/state.dart';
import 'package:sliding_blocks_06/widget/functions.dart';
import 'package:sliding_blocks_06/widget/globals.dart';

//////////////////////////////////////////////////////////////
// The MovableBlock item is a rectangle with a position, i.e.
// [left, top] coordinates, that dynamically changes position
// by being dragged.
//
// When dragging ends the item is moved to the nearest
// valid raster position; i.e. to the raster point nearest to
// the final [left, top] value that corresponds to a possible move.
//
// Position arguments 'left' and 'top' are raster units, i.e. index of the tile of the
// upper left hand corner.
// Size arguments 'width' and 'height' are integers giving the width
// and height as multiples of the base unit.
// Argument base unit is the side length of the base tile. This length
// is given as a real but should have no fractional part to avoid rounding
// errors.
//
class MovableBlock extends StatefulWidget {
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

  MovableBlock({
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
    this.blockWidthPix = this.widthTiles * this.sideLength;
    this.blockHeightPix = this.heightTiles * this.sideLength;
  }

  @override
  _MovableBlockState createState() {
    return _MovableBlockState(x: this.leftPix, y: this.topPix);
  }
}

class _MovableBlockState extends State<MovableBlock> {
  double x; // displayed Block x-coordinate in Pixels
  double y; // displayed Block y-coordinate in Pixels
  double x0 = 0; // initial x-coordinate in Pixels
  double y0 = 0; // initial y-coordinate in Pixels
  double xOffset = 0; // cumulative x-offset being tracked
  double yOffset = 0; // cumulative y-offset being tracked
  double dx = 0; // x-increment detected by PanUpdate
  double dy = 0; // y-increment detected by PanUpdate
  List<int> validMoves = [0, 0, 0, 0];
  List<double> limitOffset = [0, 0];
  Color color = Colors.lightBlue;

  _MovableBlockState({required this.x, required this.y}) {
    x0 = x;
    y0 = y;
  }

  @override
  void initState() {
    super.initState();
    validMoves = getBlockMoves(widget.gameIx, widget.blockIx);
    //print("validMoves = $validMoves");
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onPanStart: (dragStartDetails) {
          validMoves = getBlockMoves(widget.gameIx, widget.blockIx);
          xOffset = 0; // cumulatively updated offset
          yOffset = 0; // cumulative offset
          x0 = x; // saving the initial values
          y0 = y; // saving the initial values
        },
        onPanUpdate: (tapInfo) {
          setState(() {
            dx = tapInfo.delta.dx;
            dy = tapInfo.delta.dy;
            limitOffset = limitTileOffset(xOffset, dx, yOffset, dy, widget.sideLength, validMoves);
            xOffset += limitOffset[0];
            yOffset += limitOffset[1];
            x = x0 + xOffset;
            y = y0 + yOffset;
          });
        },
        onPanEnd: (tapInfo) {
          setState(() {
            List<int> nearestVertex = getNearestVertex(x, y);
            List<int> validMove = getValidMove(nearestVertex, widget.gameIx, widget.blockIx);
            int ixNew =
                Status.currentPosition[widget.gameIx][widget.blockIx][0] + validMove[0] - validMove[1];
            int iyNew =
                Status.currentPosition[widget.gameIx][widget.blockIx][1] - validMove[2] + validMove[3];
            x = ixNew * widget.sideLength;
            y = iyNew * widget.sideLength;
            //Status.dumpStatus(widget.gameIx, "onPanEnd-End-1");
            Status.updateCurrentPosition(widget.gameIx, widget.blockIx, ixNew, iyNew);
            //Status.dumpStatus(widget.gameIx, "onPanEnd-End-2");
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: color,
            border: Border(
              left: BorderSide(color: Colors.white, width: 2),
              top: BorderSide(color: Colors.white, width: 2),
              right: BorderSide(color: Colors.black, width: 2),
              bottom: BorderSide(color: Colors.black, width: 2),
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
      ),
    );
  }

  //Returns [i,j] tile indices
  List<int> getNearestVertex(double x, double y) {
    //print("getNearestVertex: x = $x, y = $y");
    List<int> v = [];
    double d = 0.0;
    int xMin = 0;
    int yMin = 0;
    double dMin = widget.sideLength * 100.0;
    for (int i = 0; i < Data.nbrTilesWidth[widget.gameIx]; i++) {
      for (int j = 0; j < Data.nbrTilesHeight[widget.gameIx]; j++) {
        d = sqrt(pow(i.toDouble() * widget.sideLength - x, 2).toDouble() +
            pow(j.toDouble() * widget.sideLength - y, 2).toDouble());
        if (d < dMin) {
          dMin = d;
          xMin = i;
          yMin = j;
        }
      }
    }
    v = [xMin, yMin];
    return v;
  }
}
