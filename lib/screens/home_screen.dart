import 'package:flutter/material.dart';
import 'package:gms_user/screens/collection_screen.dart';
import 'package:gms_user/screens/schedule_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int curIndex = 0;
  List<Widget> screens = [CollectionScreen(), ScheduleScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GMS Udupi"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (val) {
          curIndex = val;
          setState(() {});
        },
        currentIndex: curIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.truck),
            label: 'Collection',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.table),
            label: 'Schedule',
          ),
        ],
      ),
      body: screens[curIndex],
    );
  }
}
