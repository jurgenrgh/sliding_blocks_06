import 'package:sliding_blocks_06/widget/data.dart';
import 'package:sliding_blocks_06/widget/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Status {
  //
  // ************************************************************************
  // ************************* Definition ***********************************
  // ************************************************************************
  ///////////////////////////////////////////////////////////////
  // currentPosition: ULH index for each block
  // Dynamically updated as the block moves
  // Initially same as initialPosition
  // Retained even when the Game is not displayed
  // Initial display is from this List, not InitialPosition List
  ////////////////////////////////////////////////////////////
  static List currentPosition = List.generate(
    Data.nbrGames,
    (i) => List.generate(
      Data.listBlocks[i].length,
      (j) => List.generate(2, (k) => Data.initialPosition[i][j][k]),
    ),
  );

  ///////////////////////////////////////////////////////////////
  // currentOccupant: block index for each tile in each Game
  // A 2D array for each code (nbrGames)
  // The array has an entry for each tile
  // The function setCurrentOccupancy puts the block index currently
  // covering a tile into the corresponding entry.
  // Empty tiles get -1. Initially all are -1
  //////////////////////////////////////////////////////////////////
  static List currentOccupant = List.generate(
    Data.nbrGames,
    (i) => List.generate(
      Data.nbrTilesWidth[i],
      (j) => List.generate(Data.nbrTilesHeight[i], (k) => -1),
    ),
  );

  //////////////////////////////////////////////////////////////////////////////
  // currentMoves: Possible moves for each block of each game.
  // For every block there is an entry with 4 integers [left, right, up, down]
  // 0 means no move in the corresponding direction.
  // Magnitude is nbr of tiles the block can move.
  /////////////////////////////////////////////////////////////////////////////
  static List currentMoves = List.generate(
    Data.nbrGames,
    (i) => List.generate(
      Data.listBlocks[i].length,
      (j) => List.generate(4, (k) => 0), //always 4 because l,r,u,d
    ),
  );

  ////////////////////////////////////////////////////////////////////////////
  // List Move History
  // A move is a list of items of the form [r,l,u.d] where each
  // entry is 0,1 or 2, giving the number of steps right, left, up, down
  ////////////////////////////////////////////////////////////////////////////
  static List moveHistory = List.generate(
    Data.nbrGames,
    (i) => List.generate(1, (j) => List.generate(4, (k) => 0), growable: true),
  );

  ////////////////////////////////////////////////////////////////////////////
  // List Position History
  ////////////////////////////////////////////////////////////////////////////
  static List positionHistory = List.generate(
    Data.nbrGames,
    (i) => List.generate(Data.listBlocks[i].length, (j) => List.generate(2, (k) => Data.initialPosition[i][j][k])),
  );

  ////////////////////////////////////////////////////////////////////////////
  // Index of Current Position and Last Move
  ////////////////////////////////////////////////////////////////////////////

  // ************************************************************************
  // ************************* Initialization *******************************
  // ************************************************************************
  //////////////////////////////////////////////////////////////
  // Transfers all values for the game ix
  // from the initialPosition List to the currentPosition List.
  //////////////////////////////////////////////////////////////
  static void initializeCurrentPosition(int ixGame) {
    // print("initializeCurrentPosition: ixGame = $ixGame");
    for (int ixBlock = 0; ixBlock < Data.initialPosition[ixGame].length; ixBlock++) {
      currentPosition[ixGame][ixBlock][0] = Data.initialPosition[ixGame][ixBlock][0];
      currentPosition[ixGame][ixBlock][1] = Data.initialPosition[ixGame][ixBlock][1];
    }
  }

  //////////////////////////////////////////////////////////////////
  // Initializes a Game: currentPosition, currentOccupancy and currentMoves
  //////////////////////////////////////////////////////////////////
  static void initializeCurrentGame(int ixGame, String locCode) {
    //print("initializeCurrentGame: ixGame = $ixGame, code = $locCode ");
    initializeCurrentPosition(ixGame);
    updateCurrentOccupancy(ixGame);
    updateCurrentMoves(ixGame);
    //  dumpInitialPosition(ixGame, locCode);
    //  dumpStatus(ixGame, "end  of initializeCurrentGame");
  }

  //
  /////////////////////////////////////////////////////////////////
  // Initialize all current games.
  // All games are initialized, not only
  // the one currently displayed.
  // Simply transfers the initial data.
  //////////////////////////////////////////////////////////////////
  static void initializeAllCurrentGames() {
    print("initializeAllCurrentGames");
    for (int ix = 0; ix < Data.gameCode.length; ix++) {
      initializeCurrentGame(ix, "init all");
    }
  }

  //****************************************************************************
  //************************* Update *******************************************
  //****************************************************************************
  ///////////////////////////////////////////////////////////////////////
  // Position [x,y] of block ixBlock in game ixGame changes;
  // Everything else is unchanged
  //////////////////////////////////////////////////////////////////////
  static void updateCurrentPosition(int ixGame, int ixBlock, int horzPos, int vertPos) {
    currentPosition[ixGame][ixBlock][0] = horzPos;
    currentPosition[ixGame][ixBlock][1] = vertPos;
    updateCurrentOccupancy(ixGame);
    updateCurrentMoves(ixGame);
  }

  /////////////////////////////////////////////////////////////////
  // First all entries ae set to -1; this is done so that
  // in the end the empty squares are set -1.
  // Then use currentPosition to each square equal to the
  // index of the occupying tile
  // >>>>>>>>>>>>> Dependency:  currentPosition <<<<<<<<<<<<<<<<<<<<
  // ///////////////////////////////////////////////////////////////
  static void updateCurrentOccupancy(int ixGame) {
    for (int i = 0; i < Data.nbrTilesWidth[ixGame]; i++) {
      for (int j = 0; j < Data.nbrTilesHeight[ixGame]; j++) {
        currentOccupant[ixGame][i][j] = -1;
      }
      // nbr of blocks
      for (int k = 0; k < Data.listBlocks[ixGame].length; k++) {
        // width
        for (int i = 0; i < Data.listBlocks[ixGame][k][0]; i++) {
          // height
          for (int j = 0; j < Data.listBlocks[ixGame][k][1]; j++) {
            num ix = i + currentPosition[ixGame][k][0];
            num iy = j + currentPosition[ixGame][k][1];
            currentOccupant[ixGame][ix][iy] = k;
          }
        }
      }
    }
  }

  ///////////////////////////////////////////////////////////////////
  // Given the currentOccupant matrix, generate all possible moves.
  // The routine calculates the currentMoves list, which has
  // an entry of the form [r,l,u,d] per block.
  // >>>>>>>>>>>>> Dependency: currentPosition <<<<<<<<<<<<<<<<<<<<
  // >>>>>>>>>>>>> Dependency: currentOccupancy <<<<<<<<<<<<<<<<<<<<
  ///////////////////////////////////////////////////////////////////
  static void updateCurrentMoves(int ixGame) {
    int nBlocks = Data.listBlocks[ixGame].length;
    for (int i = 0; i < nBlocks; i++) {
      List<int> moves = getBlockMoves(ixGame, i);
      currentMoves[ixGame][i] = moves;
    }
  }

  //****************************************************************************
  //************************* Dump *********************************************
  //****************************************************************************
  ////////////////////////////////////////////////////////////////////
  // Dump Position, Occupant and Moves matrices
  ////////////////////////////////////////////////////////////////////
  static void dumpInitialPosition(int ixGame, String source) {
    print("Dump Initial Position: Game $ixGame, source: $source");
    for (int i = 0; i < Data.initialPosition[ixGame].length; i++) {
      print("$ixGame ${i + 1} ${Data.initialPosition[ixGame][i]}");
    }
  }

  static void dumpCurrentPosition(int ixGame) {
    print("Dump Current Position: ixGame = $ixGame");
    for (int i = 0; i < Data.initialPosition[ixGame].length; i++) {
      print("Block ${i + 1} = ${currentPosition[ixGame][i]}");
    }
  }

  ////////////////////////////////////////////////////////
  // Outputs one line per row
  // List of id numbers of blocks
  ////////////////////////////////////////////////////////
  static void dumpCurrentOccupantMatrix(int ixGame) {
    int w = Data.nbrTilesWidth[ixGame];
    int h = Data.nbrTilesHeight[ixGame];
    List<int> rowList = [];
    print("Dump Occupant Matrix: Game $ixGame, w = $w, h = $h");
    for (int j = 0; j < h; j++) {
      rowList.clear();
      for (int i = 0; i < w; i++) {
        rowList.add(Status.currentOccupant[ixGame][i][j] + 1);
      }
      print("$ixGame, $j, $rowList");
    }
  }

  static void dumpCurrentMoves(int ixGame) {
    print("dumpCurrentMoves: ixGame = $ixGame");
    int nBlocks = Data.listBlocks[ixGame].length;
    for (int i = 0; i < nBlocks; i++) {
      print("ixBlock = ${i + 1}, moves = ${currentMoves[ixGame][i]}");
    }
  }

  static void dumpStatus(int ixGame, String code) {
    print("dumpStatus: $code");
    dumpInitialPosition(ixGame, code);
    dumpCurrentPosition(ixGame);
    dumpCurrentOccupantMatrix(ixGame);
    dumpCurrentMoves(ixGame);
  }

  static void dumpPositionHistory(int ixGame) {
    print("dumpPositionHistory: ixGame = $ixGame");
    for (int i = 0; i < Data.initialPosition[ixGame].length; i++) {
      print("Block ${i + 1} = ${positionHistory[ixGame][i]}");
    }
  }

  //****************************************************************************
  //************************************* Test *********************************
  //****************************************************************************
  // Dumps everything after initializing
  static void testInitialStatusRoutines(int ixGame, String code) {
    print("testInitialStatusRoutines: $code");
    initializeCurrentPosition(ixGame);
    dumpCurrentPosition(ixGame);
    //
    updateCurrentOccupancy(ixGame);
    dumpCurrentOccupantMatrix(ixGame);
    //
    updateCurrentMoves(ixGame);
    dumpCurrentMoves(ixGame);
  }

  ////////////////////////////////////////////////////////////////////
  // The specified move is added to the history list
  // move is an integer of the form r*64 + l*16 + u*4 + d
  ////////////////////////////////////////////////////////////////////
  int appendMoveHistory(int ixBlock, int move) {
    int moveCount = 0;

    return moveCount;
  }
}
