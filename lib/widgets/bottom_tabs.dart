import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  final int? selectedTab;
  final Function(int)? tabPressed;

  BottomTabs({this.selectedTab, this.tabPressed});

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    _selectedTab = widget.selectedTab ?? 0;

    return Container(
      height: 70.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1.0,
              blurRadius: 30.0,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: BottomTabBtn(
              imagePath: "assets/images/tab_home.png",
              selected: _selectedTab == 0 ? true : false,
              onPressed: () {
                widget.tabPressed!(0);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: BottomTabBtn(
              imagePath: "assets/images/tab_search.png",
              selected: _selectedTab == 1 ? true : false,
              onPressed: () {
                print("pressed search");
                widget.tabPressed!(1);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: BottomTabBtn(
              imagePath: "assets/images/tab_saved.png",
              selected: _selectedTab == 2 ? true : false,
              onPressed: () {
                widget.tabPressed!(2);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: BottomTabBtn(
              imagePath: "assets/images/tab_logout.png",
              selected: _selectedTab == 3 ? true : false,
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          )
        ],
      ),
    );
  }
}

class BottomTabBtn extends StatelessWidget {
  final String? imagePath;
  final bool? selected;
  final Function? onPressed;

  BottomTabBtn({this.imagePath, this.selected, this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;

    return GestureDetector(
      onTap: () {
        onPressed!();
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
          color: _selected ? Theme.of(context).accentColor : Colors.transparent,
          width: 2.0,
        ))),
        child: Center(
          child: Image(
            image: AssetImage(imagePath ?? "assets/images/tab_home.png"),
            width: 22.0,
            height: 22.0,
            color: _selected ? Theme.of(context).accentColor : Colors.black,
          ),
        ),
      ),
    );
  }
}
