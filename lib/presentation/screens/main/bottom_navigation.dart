import 'package:flutter/material.dart';
import 'package:plantly/presentation/presentation_export.dart';
import '../../../constants/color.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  var currentPageIndex = 0;
  final List<Widget> pages = const [
    HomeScreen(),
    ViewAllPlants(),
    ScanScreen(),
    ViewAllTasks(),
    SettingsScreen(),
  ];

  void selectPage(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: primaryColor,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(100),
            topRight: Radius.circular(100),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: liteGrey,
            onTap: selectPage,
            currentIndex: currentPageIndex,
            selectedItemColor: primaryColor,
            unselectedItemColor: accentColor,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            items: [
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.home,
                  size: currentPageIndex == 0 ? 30 : 25,
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.eco,
                  size: currentPageIndex == 1 ? 30 : 25,
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.document_scanner,
                  size: currentPageIndex == 2 ? 30 : 25,
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.format_list_bulleted,
                  size: currentPageIndex == 3 ? 30 : 25,
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.settings,
                  size: currentPageIndex == 4 ? 30 : 25,
                ),
              ),
            ],
          ),
        ),
      ),
      body: pages[currentPageIndex],
    );
  }
}
