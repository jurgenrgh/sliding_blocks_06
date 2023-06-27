import 'package:flutter/material.dart';
import 'package:sliding_blocks_06/widget/movable_block.dart';
import 'package:sliding_blocks_06/widget/globals.dart';
import 'package:sliding_blocks_06/widget/state.dart';

class SlidingBlockGame{
  int ixGame;   // index
  String code;  // from Hordern Book
  String name;  // as marketed, source Hordern
  int width;    // nbr of tiles
  int height;   // nbr of tiles
  int minMoves; // moves for best play
  int rating;   // difficulty 1 easiest
  List<List<int>> blocks;           // List of [w,h] items, for each tile width and height
  List<List<int>> initialPosition;  // List of [x,y] coordinates of ulh corner, tile units
  List<List<int>> finalPosition;    // dito for final position

  SlidingBlockGame({
    required this.ixGame,
    required this.code,
    required this.name,
    required this.width,
    required this.height,
    required this.minMoves,
    required this.rating,
    required this.blocks,
    required this.initialPosition,
    required this.finalPosition,

})
  { initializeGame();
    blockList = makeMovableBlockList(this.ixGame);
  }

  List<MovableBlock> blockList = [];

  void initializeGame(){

  }


  List<MovableBlock> makeMovableBlockList(int ixGame) {
    //int boardWidthTiles = Data.nbrTilesWidth[ixGame];

    double tilePixWidth = (Globals.screenWidth - 2 * Globals.boardMargin) / width;

    //print("Make Movable Block List: $ixGame");
    List<MovableBlock> blockList = [];

    for (int i = 0; i < blocks.length; i++) {
      blockList.add(MovableBlock(
          key: UniqueKey(),
          gameIx: ixGame,
          blockIx: i,
          leftIx: Status.currentPosition[ixGame][i][0],
          topIx: Status.currentPosition[ixGame][i][1],
          widthTiles: blocks[i][0],
          heightTiles: blocks[i][1],
          sideLength: tilePixWidth));
    }

    return blockList;
  }
}