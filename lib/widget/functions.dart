import 'package:flutter/material.dart';
import 'dart:math';
import 'package:sliding_blocks_06/widget/state.dart';
import 'package:sliding_blocks_06/widget/data.dart';
import 'package:sliding_blocks_06/widget/globals.dart';
import 'package:sliding_blocks_06/widget/movable_block.dart';
import 'package:sliding_blocks_06/widget/fixed_block.dart';

/////////////////////////////////
// Get game index from game code
/////////////////////////////////
int getGameIndex(String code) {
  int ix = Data.gameCode.indexOf(code);
  return ix;
}

/////////////////////////////////
// Get game code from game index
/////////////////////////////////
String getGameCode(int ix) {
  String code = Data.gameCode[ix];
  return code;
}

//////////////////////////////////
// Get game name from game index
/////////////////////////////////
String getGameName(int ix) {
  String name = Data.gameName[ix];
  return name;
}

// Make the Block List to display the end position
List<FixedBlock> makeFinalBlockList(int ixGame) {
  int boardWidthTiles = Data.nbrTilesWidth[ixGame];
  double tilePixWidth = (Globals.screenWidth - 2 * Globals.boardMargin) / boardWidthTiles;
  tilePixWidth = tilePixWidth / 4;

  List<FixedBlock> blockList = [];

  for (int i = 0; i < Data.finalPosition[ixGame].length; i++) {
    blockList.add(FixedBlock(
        key: UniqueKey(),
        gameIx: ixGame,
        blockIx: i,
        leftIx: Data.finalPosition[ixGame][i][0],
        topIx: Data.finalPosition[ixGame][i][1],
        widthTiles: Data.listBlocks[ixGame][i][0],
        heightTiles: Data.listBlocks[ixGame][i][1],
        sideLength: tilePixWidth));
  }
  return blockList;
}

List<MovableBlock> makeMovableBlockList(int ixGame) {
  int boardWidthTiles = Data.nbrTilesWidth[ixGame];
  double tilePixWidth = (Globals.screenWidth - 2 * Globals.boardMargin) / boardWidthTiles;

  //print("Make Movable Block List: $ixGame");
  List<MovableBlock> blockList = [];

  for (int i = 0; i < Data.listBlocks[ixGame].length; i++) {
    blockList.add(MovableBlock(
        key: UniqueKey(),
        gameIx: ixGame,
        blockIx: i,
        leftIx: Status.currentPosition[ixGame][i][0],
        topIx: Status.currentPosition[ixGame][i][1],
        widthTiles: Data.listBlocks[ixGame][i][0],
        heightTiles: Data.listBlocks[ixGame][i][1],
        sideLength: tilePixWidth));
  }

  return blockList;
}

void dumpMovableBlockList(List<MovableBlock> list) {
  print("Dump MovableBlockList");
  for (int i = 0; i < list.length; i++) {
    print("$i ${list[i].leftIx} ${list[i].topIx} ${list[i].leftPix.round()} ${list[i].topPix.round()}");
  }
}

void dumpFixedBlockList(List<FixedBlock> list) {
  print("Dump FixedBlockList");
  for (int i = 0; i < list.length; i++) {
    print("$i ${list[i].leftIx} ${list[i].topIx} ${list[i].leftPix.round()} ${list[i].topPix.round()}");
  }
}

// Called when the corresponding IconButton is pressed
// Displays the final position of the current game.
void displayFinalPosition(int gIx) {
  List<FixedBlock> blockList = makeFinalBlockList(gIx);
  dumpFixedBlockList(blockList);
}

//////////////////////////////////////////////////////////////////////////
// Given tile coordinates and a block, derives matching move.
// Returns the valid move, if there is one, that is closest
// to the given coordinates.
// The move will be either horizontal or vertical - no diagonal moves.
// The routine returns only moves that are consistent with getBlockMoves()
// Returns a list [r,l,u,d] with at most one non-zero value.
//////////////////////////////////////////////////////////////////////////
List<int> getValidMove(List<int> tileCoord, int ixGame, int ixBlock) {
  //print("getValidMove: ixGame = $ixGame, ixBlock = $ixBlock, nearest = ${tileCoord}");
  int x0 = Status.currentPosition[ixGame][ixBlock][0]; //left
  int y0 = Status.currentPosition[ixGame][ixBlock][1]; //top
  //print("currentPosition: x0 = $x0, y0 = $y0");
  int horOffset = tileCoord[0] - x0; //horizontal offset (new - old)
  int verOffset = tileCoord[1] - y0; //vertical offset (new - old)
  if (horOffset != 0) verOffset = 0;
  // Possible offsets [right,left,top,bottom]
  //List<int> potMoves = getBlockMoves(ixGame, ixBlock);
  List<int> potMoves = Status.currentMoves[ixGame][ixBlock];
  //print("potMoves = ${potMoves}");
  // Determine actual offset
  ////// To the right
  if (horOffset > 0) {
    //print("right: horOffset = $horOffset, potMoves = ${potMoves}");
    potMoves[0] = min(potMoves[0], horOffset);
    potMoves[1] = 0;
    potMoves[2] = 0;
    potMoves[3] = 0;
    //print("Min: potMoves = $potMoves");
  }
  // To the left
  if (horOffset < 0) {
    //print("left: horOffset  = $horOffset, potMoves = ${potMoves}");
    potMoves[0] = 0;
    potMoves[1] = min(potMoves[1], -horOffset);
    potMoves[2] = 0;
    potMoves[3] = 0;
    //print("Min: potMoves = $potMoves");
  }
  if (horOffset == 0) {
    //print("horzOffset = 0");
    potMoves[0] = 0;
    potMoves[1] = 0;
  }
  // Up
  if (verOffset < 0) {
    //print("up: verOffset  = $verOffset, potMoves = ${potMoves}");
    potMoves[0] = 0;
    potMoves[1] = 0;
    potMoves[2] = min(potMoves[2], -verOffset);
    potMoves[3] = 0;
   // print("Min: potMoves = $potMoves");
  }
  // Down
  if (verOffset > 0) {
    //print("down: verOffset  = $verOffset, potMoves = ${potMoves}");
    potMoves[0] = 0;
    potMoves[1] = 0;
    potMoves[2] = 0;
    potMoves[3] = min(potMoves[3], verOffset);
    //print("Min: potMoves = $potMoves");
  }
  if (verOffset == 0) {
    //print("verOffset = 0");
    potMoves[2] = 0;
    potMoves[3] = 0;
  }
  //print("potMoves = ${potMoves}");
  return potMoves;
}

//
////////////////////////////////////////////////////////////
// New version of the move finder
// Replaces getMoves()
/////////////////////////////////////////////////////////////
// Returns all possible moves for block ixBlock of game ixGame
// returned list: [right, left, top, bottom], where each entry
// is a positive integer, the number of possible steps in the
// corresponding direction.
/////////////////////////////////////////////////////////////
List<int> getBlockMoves(int ixGame, int ixBlock) {
  //print("getBlockMoves( game = $ixGame,  block = $ixBlock )");
  //
  // List moves [r,l,t,b]
  List<int> moves = [0, 0, 0, 0];
  //
  // Get origin
  int x0 = Status.currentPosition[ixGame][ixBlock][0];
  int y0 = Status.currentPosition[ixGame][ixBlock][1];
  // print("x0 = $x0, y0 = $y0");
  //
  // Get width and height
  int wBlock = Data.listBlocks[ixGame][ixBlock][0];
  int hBlock = Data.listBlocks[ixGame][ixBlock][1];
  //print("wBlock = $wBlock, hBlock = $hBlock");
  //
  // Get moves to the right //////////////////////////////////
  int nbrSteps = 0;
  bool bEmpty = true;
  //
  while (bEmpty) {
    //print(
    //  "Right Edge: x0 = $x0, wBlock = $wBlock, nSteps = $nbrSteps, wGame = ${Data.nbrTilesWidth[ixGame]}");
    if ((x0 + wBlock + nbrSteps) >= Data.nbrTilesWidth[ixGame]) {
      bEmpty = false;
    } else {
      for (var j = 0; j < hBlock; j++) {
        //print("curOcc = ${Status.currentOccupant[ixGame]}");
        if (Status.currentOccupant[ixGame][x0 + wBlock + nbrSteps][y0 + j] != -1) {
          bEmpty = false;
        }
      }
    }
    if (bEmpty) nbrSteps += 1;
    //print("right Steps = $nbrSteps");
  }
  moves[0] = nbrSteps;
  //print("right moves = $moves");
  //
  // Get moves to the left //////////////////////////////
  nbrSteps = 0;
  bEmpty = true;

  while (bEmpty) {
    //print(
    //  "Left Edge: x0 = $x0, wBlock = $wBlock, nSteps = $nbrSteps, wGame = ${Data.nbrTilesWidth[ixGame]}");
    if ((x0 - nbrSteps) <= 0) {
      bEmpty = false;
    } else {
      for (var j = 0; j < hBlock; j++) {
        //print(
        //  "status: ${Status.currentOccupant[ixGame][x0 - 1 - nbrSteps][y0 + j]}");
        if (Status.currentOccupant[ixGame][x0 - 1 - nbrSteps][y0 + j] != -1) {
          bEmpty = false;
        }
      }
    }
    if (bEmpty) nbrSteps += 1;
    //print("left Steps = $nbrSteps");
  }
  moves[1] = nbrSteps;
  //print("left moves = $moves");
  //
  // Get moves up //////////////////////////////
  nbrSteps = 0;
  bEmpty = true;

  while (bEmpty) {
    //print(
    //  "Top Edge: y0 = $y0, hB = $hBlock, nS = $nbrSteps, hG = ${Data.nbrTilesHeight[ixGame]}");
    if ((y0 - nbrSteps) <= 0) {
      bEmpty = false;
    } else {
      for (var i = 0; i < wBlock; i++) {
        // print(
        //   "curOcc: x0 = $x0, i = $i, y0 = $y0, status = ${Status.currentOccupant[ixGame][x0 + i][y0 - 1 - nbrSteps]}");
        if (Status.currentOccupant[ixGame][x0 + i][y0 - 1 - nbrSteps] != -1) {
          bEmpty = false;
        }
      }
    }
    if (bEmpty) nbrSteps += 1;
  }
  moves[2] = nbrSteps;
  //print("up moves = $moves");
  //
  // Get moves down //////////////////////////////
  nbrSteps = 0;
  bEmpty = true;

  while (bEmpty) {
    //print(
    //  "Bottom edge: y0 = $y0, hB = $hBlock, nS = $nbrSteps, hG = ${Data.nbrTilesHeight[ixGame]}");
    if ((y0 + hBlock + nbrSteps) >= Data.nbrTilesHeight[ixGame]) {
      bEmpty = false;
    } else {
      for (var i = 0; i < wBlock; i++) {
        if (Status.currentOccupant[ixGame][x0 + i][y0 + hBlock + nbrSteps] != -1) {
          bEmpty = false;
        }
      }
    }
    if (bEmpty) nbrSteps += 1;
  }
  moves[3] = nbrSteps;
  //
  //print("getBlockMoves: game = $ixGame, block = $ixBlock, moves: $moves");
  return moves;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////// Not called //////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
// Third version of the move check. Given upper left corner
// coordinates of the new position, check if the proposed move is valid
// The argument nearest contains the coordinates of the nearest lattice
// point in tile coordinates
/////////////////////////////////////////////////////////////////////////
bool checkMove(List<int> nearest, int ixGame, int ixBlock) {
 // print("checkMove: ixGame = $ixGame, ixBlock = $ixBlock, nearest = ${nearest}");
  bool bCheck = false;
  List<int> validMove = getValidMove(nearest, ixGame, ixBlock);
  int m = validMove.reduce(max);
  // print("validMove = ${validMove}, reduced = $m, nearest = ${nearest}, gameIx = $ixGame, blockIx = $ixBlock");

  if (m > 0) bCheck = true;
  // print("bCheck = $bCheck");
  return bCheck;
}

///////////////////////////////////////////////////////////////////
// Limit the tile offset to the maximal possible motion,
// as given by validMoves.
// Returns a list [r,l,u,d] where each entry is 0 or 1 and
// corresponds to a direction.
// 0 means truncate, 1 means increment
//////////////////////////////////////////////////////////////////
List<double> limitTileOffset(double xOffset, double dx, double yOffset, double dy, double blockSideLength, List<int> validMoves) {
  //print("limitTileOffset: xOffset = ${fix(xOffset)}, dx = ${fix(dx)}, yOffset = ${fix(yOffset)}, dy = ${fix(dy)}");
  List<int> limits = [1, 1, 1, 1];
  List<double> limOffset = [dx, dy];

  if ((((xOffset + dx) > 0) && (validMoves[0] == 0)) || ((xOffset + dx) > (validMoves[0] * blockSideLength))) {
    limits[0] = 0;
  }
  if ((((xOffset + dx) < 0) && (validMoves[1] == 0)) || ((xOffset + dx) < -(validMoves[1] * blockSideLength))) {
    limits[1] = 0;
  }
  if ((((yOffset + dy) < 0) && (validMoves[2] == 0)) || ((yOffset + dy) < -(validMoves[2] * blockSideLength))) {
    limits[2] = 0;
  }
  if ((((yOffset + dy) > 0) && (validMoves[3] == 0)) || ((yOffset + dy) >  (validMoves[3] * blockSideLength))) {
    limits[3] = 0;
  }
  //print("limits = $limits");
  if ((xOffset + dx) > 0) {
    limOffset[0] = dx * limits[0];
  }
  if ((xOffset + dx) < 0) {
    limOffset[0] = dx * limits[1];
  }
  if ((yOffset + dy) < 0) {
    limOffset[1] = dy * limits[2];
  }
  if ((yOffset + dy) > 0) {
    limOffset[1] = dy * limits[3];
  }

  //print("limOffset: dx = ${fix(limOffset[0])}, dy = ${fix(limOffset[1])}");
  return limOffset;
}

/////////////////////////////////////////////////////////////////////
// Round a double to the given number of decimals, which will
// then display truncated as 'fixed'.
// Defaults to 2
////////////////////////////////////////////////////////////////////
double fix(double val, [int fractionDigits = 2]) {
  var mod = pow(10.0, fractionDigits).toDouble();
  return ((val * mod).round().toDouble() / mod);
}

class PositionHistory {
  int ixGame = 0;
  int ixMove = 0;

  PositionHistory({
    required this.ixGame,
    required this.ixMove,
  }) {}
}
