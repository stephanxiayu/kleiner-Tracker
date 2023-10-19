import 'package:flutter/material.dart';

import 'package:kleiner_tracker/provider/tracker_provider.dart';
import 'package:kleiner_tracker/screens/tracker.dart';
import 'package:kleiner_tracker/screens/tracker_list.dart';
import 'package:kleiner_tracker/widget/globalvariables.dart';
import 'package:provider/provider.dart';

class TrackerBottonBar extends StatefulWidget {
  const TrackerBottonBar({super.key});

  @override
  State<TrackerBottonBar> createState() => _TrackerBottonBarState();
}

class _TrackerBottonBarState extends State<TrackerBottonBar> {
  int _selectedIndex = 0;

  List<Widget> getWidgetOptions() {
    return <Widget>[const Tracker(), const TrackerList()];
  }

void _onItemTapped(int index) {
  Future.microtask(() {
    setState(() {
      _selectedIndex = index;
    });
  });
}


  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TrackerProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Toilettengänge heute: ${provider.countTodayVisits()}',
          style: const TextStyle(color: Colors.grey),
        ),
        backgroundColor: GlobalVariables.backgroundColor,
      ),
      body: Center(
        child: getWidgetOptions().elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(elevation: 9,
        backgroundColor: GlobalVariables.backgroundColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_sharp),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Liste',
          ),
        ],
        currentIndex: _selectedIndex,
        iconSize: 35,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.yellow,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.yellow,
              onPressed: 
              
              provider.addTimestamp,
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            )
          : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
