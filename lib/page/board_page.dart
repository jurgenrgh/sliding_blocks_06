import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:sliding_blocks_06/widget/globals.dart';
import 'package:sliding_blocks_06/widget/data.dart';
import 'package:sliding_blocks_06/widget/functions.dart';
import 'package:sliding_blocks_06/widget/movable_block.dart';
import 'package:sliding_blocks_06/widget/fixed_block.dart';
import 'package:sliding_blocks_06/widget/popupMenu.dart';
import 'package:sliding_blocks_06/widget/state.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  static int ixGame = Globals.lastUsedSlidingBlocksGameIx;
  Color? backC = Colors.blue[200];
  bool showGoal = true;
  bool showNumbers = Globals.showNumbers;

  //This function is passed as an argument to the popupMenu
  //Called when the menu selection changes
  void handleGameChange(dynamic ix) {
    //Status.dumpInitialPosition(ix, "in handleGameChange");
    setState(() {
      backC = Colors.blue[200];
      Globals.lastUsedSlidingBlocksGameIx = ix;
      ixGame = ix;
      Status.initializeCurrentGame(ixGame, ">>>>>>>>>>>>>>>>>>>>>>>>handleGameChange");
      //Status.dumpStatus(ixGame, "in handleGameChange");
    });
  }

  @override
  Widget build(BuildContext context) {
    Globals.setScreenParameters(context);
    int boardNbrTilesHeight = Data.nbrTilesHeight[ixGame];
    int boardNbrTilesWidth = Data.nbrTilesWidth[ixGame];
    double tilePixWidth =
        (Globals.screenWidth - 2 * Globals.boardMargin) / boardNbrTilesWidth;
    double boardPixWidth =
        tilePixWidth * boardNbrTilesWidth + 2 * Globals.boardMargin;
    double boardPixHeight =
        tilePixWidth * boardNbrTilesHeight + 2 * Globals.boardMargin;

    //print("BoardPageState build called");
    //Status.testInitialStatusRoutines(ixGame, "testInit01");
    Status.initializeCurrentGame(ixGame, "build BoardPage");
    //Status.dumpStatus(ixGame, "re-init");
    List<MovableBlock> movableBlockList = makeMovableBlockList(ixGame);
    List<FixedBlock> finalBlockList = makeFinalBlockList(ixGame);

    return Scaffold(
      backgroundColor: backC,
      body: Center(
        child: Column(
          children: [
            popupMenu(
              handleGameChange,
            ),
            Container(
              width: boardPixWidth,
              height: boardPixHeight,
              decoration: BoxDecoration(
                color: Colors.blue[800],
                border: Border.all(
                  color: Colors.blue[800]!,
                  width: Globals.boardMargin,
                ),
              ),
              child: Stack(
                children: movableBlockList,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  iconSize: 36,
                  icon: const Icon(
                    Icons.onetwothree_sharp,
                  ),
                  tooltip: 'Show Numbers',
                  onPressed: () => {
                    setState(
                        () => {Globals.showNumbers = !Globals.showNumbers}),
                  },
                ),
                IconButton(
                  iconSize: 36,
                  icon: const Icon(
                    Icons.keyboard_double_arrow_left,
                  ),
                  tooltip: 'Restart',
                  onPressed: () {handleGameChange(ixGame);},
                ),
                IconButton(
                  iconSize: 36,
                  icon: const Icon(
                    Icons.keyboard_arrow_left,
                  ),
                  tooltip: 'Undo',
                  color: Colors.blue[800],
                  onPressed: null,
                ),
                IconButton(
                  iconSize: 36,
                  icon: const Icon(
                    Icons.keyboard_arrow_right,
                  ),
                  tooltip: 'Redo',
                  onPressed: null,
                ),
                IconButton(
                  iconSize: 36,
                  icon: const Icon(
                    Icons.keyboard_double_arrow_right,
                  ),
                  tooltip: 'Return',
                  onPressed: null,
                ),
                IconButton(
                  iconSize: 36,
                  icon: const Icon(
                    Icons.check_circle_outline,
                  ),
                  tooltip: 'Goal',
                  onPressed: () => {
                    setState(() => {showGoal = !showGoal}),
                  },
                ),
              ],
            ),
            if (showGoal)
              Container(
                width: boardPixWidth / 4,
                height: boardPixHeight / 4,
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                  border: Border.all(
                      color: Colors.blue[800]!,
                      width: Globals.smallBoardMargin),
                ),
                child: Stack(
                  children: finalBlockList,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
