import 'package:flutter/material.dart';
import 'package:sliding_blocks_06/widget/globals.dart';
import 'package:sliding_blocks_06/widget/data.dart';
import 'package:sliding_blocks_06/widget/functions.dart';
import 'package:sliding_blocks_06/widget/movable_block.dart';
import 'package:sliding_blocks_06/widget/popupMenu.dart';

//
class ToroidPage extends StatefulWidget {
  ToroidPage({Key? key}) : super(key: key);

  @override
  State<ToroidPage> createState() => _ToroidPageState();
}

class _ToroidPageState extends State<ToroidPage> {
  static int ixToroidGame = Globals.lastUsedToroidGameIx;
  Color? backC = Colors.blue[200];

  // This function is passed as an argument to the popupMenu
  // Called when the menu selection changes
   void handleGameChange(dynamic ix) {

     setState(() {
       backC = Colors.blue[800];
       Globals.lastUsedSlidingBlocksGameIx = ix;
       ixToroidGame = ix;
     });
   }

  @override
  Widget build(BuildContext context) {
    Globals.setScreenParameters(context);
    int boardHeightTiles = Data.nbrTilesHeight[ixToroidGame];
    int boardWidthTiles = Data.nbrTilesWidth[ixToroidGame];
    double tilePixWidth =
        (Globals.screenWidth - 2 * Globals.boardMargin) / boardWidthTiles;
    double boardPixWidth =
        tilePixWidth * boardWidthTiles + 2 * Globals.boardMargin;
    double boardPixHeight =
        tilePixWidth * boardHeightTiles + 2 * Globals.boardMargin;

    List<MovableBlock> movableBlockList = makeMovableBlockList(ixToroidGame);

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
                      color: Colors.blue[800]!, width: Globals.boardMargin)),

              child: Stack(
                children: movableBlockList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

