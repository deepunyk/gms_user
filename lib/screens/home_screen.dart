import 'package:flutter/material.dart';
import 'package:gms_user/screens/collection_screen.dart';
import 'package:gms_user/screens/schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int curIndex = 0;
  List<Widget> screens = [ScheduleScreen(), CollectionScreen()];

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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Collection',
          ),
        ],
      ),
      body: screens[curIndex],
    );
  }
}
