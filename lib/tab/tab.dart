import 'package:flutter/material.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/tab/profile.dart';

import 'chart_friend_tab.dart';
import 'home.dart';
import 'journal_list.dart';
import 'notification_screen.dart';

class AppTabController extends StatefulWidget {
  const AppTabController({Key? key}) : super(key: key);

  @override
  _AppTabControllerState createState() => _AppTabControllerState();
}

class _AppTabControllerState extends State<AppTabController>
    with SingleTickerProviderStateMixin {
  final List<Widget> pages = [
    const Home(),
    const ChartFriendTabController(),
    const JournalList(),
    const NotificationScreen(),
    const Profile()
  ];
  late TabController _controller;
  int selectedPageIndex = 0;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: pages.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
      _controller.animateTo(selectedPageIndex, duration: null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: pages.length,
      child: Scaffold(
        /* appBar: AppBar(
          title: Text('Flutter Tabs Demo'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.contacts), text: "Tab 1"),
              Tab(icon: Icon(Icons.camera_alt), text: "Tab 2")
            ],
          ),
        ),*/
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: pages,
        ),
        //pages[selectedPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: selectPage,
          backgroundColor: AppColors.TAB_BAR_BG,
          unselectedItemColor: AppColors.UNSELECTED_TAB_BG,
          selectedItemColor: AppColors.SELECTED_TAB_BG,
          currentIndex: selectedPageIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              backgroundColor: AppColors.PRIMARY_COLOR,
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: AppColors.PRIMARY_COLOR,
              icon: Icon(Icons.pie_chart),
              label: 'Chart',
            ),
            BottomNavigationBarItem(
              backgroundColor: AppColors.PRIMARY_COLOR,
              icon: ImageIcon(
                AssetImage('assets/images/journal_tab.png'),
                size: 20,
              ),
              label: 'Journal',
            ),
            BottomNavigationBarItem(
              backgroundColor: AppColors.PRIMARY_COLOR,
              icon: Icon(Icons.notifications),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              backgroundColor: AppColors.PRIMARY_COLOR,
              icon: Icon(Icons.account_circle_sharp),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
