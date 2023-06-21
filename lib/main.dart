import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_blocks_06/page/board_page.dart';
import 'package:sliding_blocks_06/page/toroid_page.dart';
import 'package:sliding_blocks_06/page/grid_page.dart';
import 'package:sliding_blocks_06/widget/tabbar_widget.dart';
import 'package:sliding_blocks_06/widget/globals.dart';
//import 'package:sliding_blocks_06/widget/functions.dart';
//import 'package:sliding_blocks_06/widget/state.dart';

// See Readme.md for explanations
// A nominal change to test git reaction
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  if (Globals.lastUsedSlidingBlocksGameIx < 0) {
    //int ix = 0;
    Globals.lastUsedSlidingBlocksGameIx = 0;

  }
  runApp(ThisApp());
}

class ThisApp extends StatelessWidget {
  static final String _title = 'Sliding Blocks v06';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: _title,
    theme: ThemeData(
      // primarySwatch: Colors.green,
      // primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.blue[100]),
    home: MainPage(),
  );
}

//This is all there is to setting up the tab data
//The text can be preceded by an icon
//Processed by TabBarWidget
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TabBarWidget(
    title: ThisApp._title,
    tabs: [
      Tab(icon: Icon(Icons.dashboard), text: '4x5 Rectangles'),
      Tab(icon: Icon(Icons.grid_view), text: 'Toroid'),
      Tab(icon: Icon(Icons.apps), text: 'Grid'),
    ],
    children: [
      BoardPage(),
      ToroidPage(),
      GridPage(),
    ],
  );
}
