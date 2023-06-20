import 'package:flutter/material.dart';
import 'package:sliding_blocks_06/widget/grid_view_item.dart';
import 'package:sliding_blocks_06/widget/functions.dart';

//This class contains not only the tab bars
//But also the entire Scaffold with AppBar and
//thePopupMenu
//
class TabBarWidget extends StatefulWidget {
  final String title;
  final List<Tab> tabs;
  final List<Widget> children;

  TabBarWidget({
    Key? key,
    required this.title,
    required this.tabs,
    required this.children,
  }) : super(key: key);

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  List<Map<String, dynamic>> items = <Map<String, dynamic>>[
    <String, dynamic>{'title': 'Red', 'color': Colors.red},
    <String, dynamic>{'title': 'Purple', 'color': Colors.purple},
    <String, dynamic>{'title': 'Orange', 'color': Colors.deepOrange},
    <String, dynamic>{'title': 'Teal', 'color': Colors.teal},
    <String, dynamic>{'title': 'Indigo', 'color': Colors.indigo},
    <String, dynamic>{'title': 'Yellow', 'color': Colors.yellow},
  ];

  int optionSelected = 0;

  void checkOption(int index) {
    setState(
      () {
        optionSelected = index;
      },
    );
  }

  Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: widget.tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              tabs: widget.tabs,
            ),
            elevation: 20,
            titleSpacing: 20,
          ),
          body: TabBarView(
            children: widget.children,
            physics: NeverScrollableScrollPhysics(),
          ),
          drawer: Container(
            width: MediaQuery.of(context).size.width,
            /////////////////////////////////////////////////
            ////// Drawer
            child: Drawer(
              child: Scaffold(
                backgroundColor: backgroundColor.withOpacity(0.4),
                appBar: AppBar(
                  title: const Text('Choose the Game'),
                  centerTitle: true,
                  elevation: 0,
                ),
                body: CustomScrollView(
                  //padding: EdgeInsets.all(12.0),
                  //child: GridView.count(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      sliver: SliverGrid.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 4 / 5,
                        children: [
                          for (int i = 0; i < items.length; i++)
                            GridViewItem(
                              title: items[i]['title'] as String,
                              color: items[i]['color'] as Color,
                              onTap: () {
                                checkOption(i + 1);
                                setState(() {
                                  backgroundColor = items[i]['color'] as Color;
                                });
                              },
                              selected: i + 1 == optionSelected,
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
