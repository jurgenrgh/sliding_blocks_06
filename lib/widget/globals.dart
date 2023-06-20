import 'package:flutter/material.dart';
import 'dart:math';

class Globals {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double boardMargin = 6;
  static double screenMargin = 0.8;
  static double smallBoardMargin = 2;

  static int lastUsedSlidingBlocksGameIx = 0;
  static int lastUsedToroidGameIx = 0;

  static void setScreenParameters(BuildContext context) {
    screenWidth = screenMargin * MediaQuery.of(context).size.width;
    screenHeight = screenMargin * MediaQuery.of(context).size.height;
    screenWidth = min(screenWidth, screenHeight);
  }
  static bool showNumbers = false; //Label blocks with index numbers
}
