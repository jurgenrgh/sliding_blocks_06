import 'package:flutter/material.dart';

PopupMenuButton popupMenu(void Function(dynamic) handler) {
  return PopupMenuButton(
    color: Colors.blue[700],
    elevation: 20,
    enabled: true,
    onSelected: handler,
    itemBuilder: (context) => [
      PopupMenuItem(
        textStyle: TextStyle(color: Colors.black, fontSize: 16),
        child: Text("C15: NoName"),
        value: 0,
      ),
      PopupMenuItem(
        textStyle: TextStyle(color: Colors.black, fontSize: 16),
        child: Text("C16: NoName"),
        value: 1,
      ),
      PopupMenuItem(
        textStyle: TextStyle(color: Colors.black, fontSize: 16),
        child: Text("C17: Traffic Cop Tangle"),
        value: 2,
      ),
      PopupMenuItem(
        textStyle: TextStyle(color: Colors.black, fontSize: 16),
        child: Text("C18: NoName"),
        value: 3,
      ),
      PopupMenuItem(
        textStyle: TextStyle(color: Colors.black, fontSize: 16),
        child: Text("C19: Dad's Puzzle"),
        value: 4,
      ),
    ],
  );
}
