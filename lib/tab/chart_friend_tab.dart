import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/controller/get_feeling_controller.dart';
import 'package:life_track/models/login_response.dart';
import 'package:life_track/network/shared_pref/shared_preference_helper.dart';
import 'package:life_track/tab/add_group.dart';
import 'package:life_track/tab/show_group_list.dart';

import '../Contants/constant.dart';
import 'add_friend.dart';
import 'chart.dart';
import 'friend_list.dart';
import 'show_planes.dart';

class ChartFriendTabController extends StatefulWidget {
  const ChartFriendTabController({Key? key}) : super(key: key);

  @override
  _ChartFriendTabControllerState createState() => _ChartFriendTabControllerState();
}

class _ChartFriendTabControllerState extends State<ChartFriendTabController> {
  final GetFillingController getFillingController = Get.put(GetFillingController());

  String? isSubscribed;

  void _moveToAddFriendScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddFriend(),
      ),
    );
  }

  void _moveToAddGroupScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddGroup(),
      ),
    );
  }

  _moveToBuyPlanes(context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShowPlanes(),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Add friends':
        // if(isSubscribed==1){
          _moveToAddFriendScreen(context);
        // }else{
        //   Get.defaultDialog(
        //     backgroundColor: AppColors.PRIMARY_COLOR,
        //       title: "oops!", titleStyle: const TextStyle(
        //       color: Colors.white,
        //       fontWeight: FontWeight.bold,
        //       fontSize: 25),
        //       content: Column(
        //     children: [
        //       IconButton(
        //   icon: FaIcon(FontAwesomeIcons.faceFrown,color: Colors.white,),
        //       onPressed:(){}),
        //       Text('You don\'t have any Subscription plan.',style:TextStyle(
        //           color: Colors.white,
        //           fontWeight: FontWeight.w500,
        //           fontSize: 18),),
        //       SizedBox(
        //         height: 14.0,
        //       ),
        //       GestureDetector(
        //         onTap: (){
        //           _moveToBuyPlanes(context);
        //         },
        //         child: Container(
        //           height: 47,
        //           width: 100,
        //           decoration: BoxDecoration(
        //               color: AppColors.PRIMARY_COLOR,
        //               borderRadius: const BorderRadius.all(
        //                 Radius.circular(25.0),
        //               ),
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: Colors.black.withOpacity(0.2),
        //                   spreadRadius: 4,
        //                   blurRadius: 10,
        //                   offset: const Offset(0, 3),
        //                 )
        //               ]),
        //           child: Center(
        //             child: const Text(
        //               'UPGRADE',
        //               textAlign: TextAlign.left,
        //               style: TextStyle(
        //                 fontFamily: fontFamilyName,
        //                 fontWeight: FontWeight.w600,
        //                 fontSize: 16,
        //                 letterSpacing: 0.0,
        //                 color: Colors.white,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ));
        // }
        break;
      case 'Add Groups':
        // if(isSubscribed==1){
          _moveToAddGroupScreen(context);
        // }else{
        //   Get.defaultDialog(
        //       backgroundColor: AppColors.PRIMARY_COLOR,
        //       title: "oops!", titleStyle: const TextStyle(
        //       color: Colors.white,
        //       fontWeight: FontWeight.bold,
        //       fontSize: 25),
        //       content: Column(
        //         children: [
        //           IconButton(
        //               icon: FaIcon(FontAwesomeIcons.faceFrown,color: Colors.white,),
        //               onPressed:(){}),
        //           Text('You don\'t have any Subscription plan.',style:TextStyle(
        //               color: Colors.white,
        //               fontWeight: FontWeight.w500,
        //               fontSize: 18),),
        //           SizedBox(
        //             height: 14.0,
        //           ),
        //           GestureDetector(
        //             onTap: (){
        //               _moveToBuyPlanes(context);
        //             },
        //             child: Container(
        //               height: 47,
        //               width: 100,
        //               decoration: BoxDecoration(
        //                   color: AppColors.PRIMARY_COLOR,
        //                   borderRadius: const BorderRadius.all(
        //                     Radius.circular(25.0),
        //                   ),
        //                   boxShadow: [
        //                     BoxShadow(
        //                       color: Colors.black.withOpacity(0.2),
        //                       spreadRadius: 4,
        //                       blurRadius: 10,
        //                       offset: const Offset(0, 3),
        //                     )
        //                   ]),
        //               child: Center(
        //                 child: const Text(
        //                   'UPGRADE',
        //                   textAlign: TextAlign.left,
        //                   style: TextStyle(
        //                     fontFamily: fontFamilyName,
        //                     fontWeight: FontWeight.w600,
        //                     fontSize: 16,
        //                     letterSpacing: 0.0,
        //                     color: Colors.white,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ));
        // }
        break;
    }
  }

  getSubStatus() async{
    String userInfoString = await SharedPreferenceHelper.getInstance().userInfo ?? '';
    final userInfoModel = LoginResponseModel.fromJson(jsonDecode(userInfoString));

    setState((){
      isSubscribed = userInfoModel.user?.subsStatus.toString();
    });
    print("jdhnfjhgjhf11 "+isSubscribed.toString());
  }


  @override
  void initState() {
    super.initState();
    getSubStatus();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    print("isSubscribed::::==>"+isSubscribed.toString());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                color: Colors.white,
                icon: Obx(() {
                  return getFillingController.isDataloading.value
                      ? getFillingController.model.value.data!.reviewMassge=='Very Sad' ? FaIcon(FontAwesomeIcons.faceFrown)
                      : getFillingController.model.value.data!.reviewMassge=='Sad' ? FaIcon(FontAwesomeIcons.faceFrownOpen)
                      : getFillingController.model.value.data!.reviewMassge=='Ok' ? Icon(Icons.add_reaction_outlined)
                      : getFillingController.model.value.data!.reviewMassge=='Happy' ? FaIcon(FontAwesomeIcons.faceSmile)
                      : getFillingController.model.value.data!.reviewMassge=='Very Happy'  ? FaIcon(FontAwesomeIcons.faceSmileBeam)
                      :Icon(Icons.add_reaction_outlined)
                      : Icon(Icons.add_reaction_outlined);
                }),
                onPressed: () {
                  print('Emoji clicked');
                },
              ),
              Image.asset(
                'assets/images/splash_logo.png',
                 width: 159,
                 height: 50,
              ),
              Visibility(
                visible: false,
                child: IconButton(
                  color: Colors.white,
                  icon: Obx(() {
                    return getFillingController.isDataloading.value
                        ? getFillingController.model.value.data!.reviewMassge=='Very Sad' ? FaIcon(FontAwesomeIcons.faceFrown)
                        : getFillingController.model.value.data!.reviewMassge=='Sad' ? FaIcon(FontAwesomeIcons.faceFrownOpen)
                        : getFillingController.model.value.data!.reviewMassge=='Ok' ? Icon(Icons.add_reaction_outlined)
                        : getFillingController.model.value.data!.reviewMassge=='Happy' ? FaIcon(FontAwesomeIcons.faceSmile)
                        : getFillingController.model.value.data!.reviewMassge=='Very Happy'  ? FaIcon(FontAwesomeIcons.faceSmileBeam)
                        :Icon(Icons.add_reaction_outlined)
                        : Icon(Icons.add_reaction_outlined);
                  }),
                  onPressed: () {
                    print('Emoji clicked');
                  },
                ),
              ),
              // IconButton(
              //   color: Colors.white,
              //   icon: const Icon(Icons.add_outlined),
              //   onPressed: () {
              //     _moveToAddFriendScreen(context);
              //   },
              // ),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              color: AppColors.PRIMARY_COLOR,
              icon: Icon(Icons.person_add_alt_1_outlined),
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Add friends', 'Add Groups'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice,style: TextStyle(color: Colors.white),),
                  );
                }).toList();
              },
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Your Charts"),
              Tab(text: "Friends"),
              Tab(text: "Groups"),
            ],
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: fontFamilyName,
              fontWeight: FontWeight.w500,
            ),
            indicatorColor: Colors.white,
          ),
        ),
        body: const TabBarView(
          children: [
            Chart(),
            FriendsList(),
            GroupsList()
          ],
        ),
      ),
    );
  }
}
