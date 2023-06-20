import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

////////////////////////////////////////////////////////////////////
// There will be an instance of this class for every game
// It contains all of the functions for manipulating
// persistent storage and for initializing the state.
//
class Storage {
  int ixGame;

  Storage({
    required this.ixGame,
  }) {}
  int moveCount = 0;
  int currentMove = 0;

  ///////////////////////////////////////////////////////////////////////////////////////
  // Save a move in the "key-value store"
  // ixN is a move number
  // listMove is a move specified as a list [r,l,u,d]
  // The move is the value to be stored
  // The indices are combined to form the key: '$ixG + '.' + $ixN
  Future<void> putMove(int ixN, List<int> move) async {
    String key = this.ixGame.toString() + '.' + ixN.toString();
    String val = json.encode(move);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, val);
  }

  ///////////////////////////////////////////////////////////////////////////////////////
  // Save a move in the "key-value store" by appending to the list
  // Increments moveCount
  // move is a list of form [r,l,u,d]
  // The stoage key is: '$ixGame + '.' + $moveCount
  Future<void> appendMove(List<int> move) async {
    String key = this.ixGame.toString() + '.' + moveCount.toString();
    String val = json.encode(move);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, val);
    moveCount += 1;
  }

  ///////////////////////////////////////////////////////////////////////////////////////
  // Retrieve the specified move from the "key-value-store"
  // ixN = move index
  // returns a move as a list of form [r,l,u,d]
  Future<List<int>> getMove(int ixN) async {
    List<int> move = [0, 0, 0, 0];
    String key = this.ixGame.toString() + '.' + ixN.toString();
    final prefs = await SharedPreferences.getInstance();
    String val = await prefs.getString(key) ?? "";
    if (val == "") {
      move = [0, 0, 0, 0];
    } else {
      move = jsonDecode(val);
    }
    return move;
  }

  ///////////////////////////////////////////////////////////////////////////////////////
  // Retrieve the current move from the "key-value-store"
  // returns a move as a list of form [r,l,u,d]
  Future<List<int>> getCurrentMove() async {
    int ix = currentMove;
    List<int> move = await getMove(ix);
    return move;
  }

  ///////////////////////////////////////////////////////////////////////////////////////
  // Retrieve the last move from the "key-value-store"
  // returns a move as a list of form [r,l,u,d]
  Future<List<int>> getLastMove() async {
    int ix = moveCount - 1;
    List<int> move = await getMove(ix);
    return move;
  }

  /////////////////////////////////////////////////////////////////////////////////////
  // Delete the move specified
  // Move index ixN
  // returns false if no such move, else true
  Future<bool> deleteMove(int ixN) async {
    bool done = true;
    String key = this.ixGame.toString() + '.' + ixN.toString();
    final prefs = await SharedPreferences.getInstance();
    String val = await prefs.getString(key) ?? "";
    if (val != "") {
      done = false;
    } else {
      await prefs.remove(key);
    }
    return done;
  }

  /////////////////////////////////////////////////////////////////////////////////////
  // Delete the move specified
  // Move index ixN
  // returns false if no such move, else true
  Future<bool> deleteLastMove() async {
    int ixN = moveCount - 1;
    bool done = true;
    String key = this.ixGame.toString() + '.' + ixN.toString();
    final prefs = await SharedPreferences.getInstance();
    String val = await prefs.getString(key) ?? "";
    if (val != "") {
      done = false;
    } else {
      await prefs.remove(key);
      moveCount = moveCount - 1;
    }
    return done;
  }

  ///////////////////////////////////////////////////////////////////////////////////////
  // Removes all moves beyond the current move
  // returns false if any of the expected moves were missing
  Future<bool> truncateMoveList() async {
    bool done = true;
    while (moveCount > (currentMove + 1)) {
      int ixN = moveCount - 1;
      String key = this.ixGame.toString() + '.' + ixN.toString();
      final prefs = await SharedPreferences.getInstance();
      String val = await prefs.getString(key) ?? "";
      if (val != "") {
        done = false;
      } else {
        await prefs.remove(key);
      }
      moveCount = moveCount - 1;
    }
    return done;
  }

  /////////////////////////////////////////////////////////////////////////////////
  // General initialization
  // The storage contains all the information necessary to reinitialize
  // the state of each game.
  // This routine performs this initialization and is called when the class
  // is instantiated.
  // If there is no stored information for this game then an initialization accorting
  // to the starting data is done.
  Future<void> generalInitialization() async {}
}
