import 'package:covidcenters/screens/Info_page.dart';
import 'package:covidcenters/screens/text_view.dart';
import 'package:covidcenters/screens/maps.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int selectedIndex = 0;
  List<Widget> _pages = [MapsMarkers(), TextView(),InfoPage()];

  onSelect(int index) {
    setState(
      () {
        selectedIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type:BottomNavigationBarType.fixed,
          onTap: onSelect,
          currentIndex: selectedIndex,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.red[400],
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.navigation_rounded),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business_outlined),
              title: Text("Centers"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              title: Text("Info"),
            )
          ],
        ),
      ),
    );
  }
}
