import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/controller/get_feeling_controller.dart';
import 'package:life_track/controller/get_friends_controller.dart';
import 'package:life_track/tab/friend_detail.dart';
import 'package:life_track/tab/friends/all_friends.dart';
import 'package:life_track/tab/friends/friend_request.dart';

import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  // final GetFriendsController controller = Get.put(GetFriendsController());
  // final GetFillingController getFillingController = Get.put(
  //     GetFillingController());


  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradientContainer(
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 8),
          child:  Column(
                  children: [
                    TabBar(
                      unselectedLabelColor: Colors.black,
                      labelColor: Colors.white,
                      tabs: [
                        Tab(
                          child: Text('friend List'),
                        ),
                        Tab(
                          child: Text('Friend Request'),
                        )
                      ],
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          AllFriendsList(),
                          FriendRequest()
                        ],
                        controller: _tabController,
                      ),
                    ),
                  ],
                )
        ),
      ),
    );
  }
}
