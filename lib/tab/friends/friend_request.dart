import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/Contants/constant.dart';
import 'package:life_track/components/background_gradient_container.dart';
import 'package:life_track/controller/friend_request_controller.dart';
import 'package:life_track/controller/get_feeling_controller.dart';
import 'package:life_track/repo/accept_friend_request_repository.dart';
import 'package:life_track/repo/reject_friend_request_repository.dart';
import 'package:life_track/tab/friend_detail.dart';

class FriendRequest extends StatefulWidget {
  const FriendRequest({Key? key}) : super(key: key);

  @override
  _FriendRequestState createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  final FriendRequestController controller = Get.put(FriendRequestController());
  final GetFillingController getFillingController = Get.put(
      GetFillingController());


  @override
  void initState() {
    super.initState();
    controller.getFriendsRequsetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradientContainer(
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 8),
          child: Obx(() {
            return controller.isDataLoading.value
                ? controller.model.value.data!.isEmpty? Center(child: Text('No friends Found',style: TextStyle(color: Colors.white),)): ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: controller.model.value.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  minVerticalPadding: 16,
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        //backgroundImage: AssetImage('assets/images/defaultuser.png'),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: Image.network(
                            controller.model.value.data![index].userImage.toString(),
                            fit: BoxFit.contain,
                          ),
                        ),
                        radius: 30.0,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text(
                          controller.model.value.data![index].firstName.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: fontFamilyName,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      // IconButton(
                      //   color: Colors.white,
                      //   icon: controller.model.value.data![index].reviewMassge=='Very Sad' ? FaIcon(FontAwesomeIcons.faceFrown)
                      //       : controller.model.value.data![index].reviewMassge=='Sad' ? FaIcon(FontAwesomeIcons.faceFrownOpen)
                      //       : controller.model.value.data![index].reviewMassge=='Ok' ? Icon(Icons.add_reaction_outlined)
                      //       : controller.model.value.data![index].reviewMassge=='Happy' ? FaIcon(FontAwesomeIcons.faceSmile)
                      //       : controller.model.value.data![index].reviewMassge=='Very happy'  ? FaIcon(FontAwesomeIcons.faceSmileBeam)
                      //       : Icon(Icons.add_reaction_outlined),
                      //   onPressed: () {
                      //     print('Emoji clicked');
                      //   },
                      // ),
                      // IconButton(
                      //   color: Colors.white,
                      //   icon: const Icon(Icons.navigate_next),
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context, MaterialPageRoute(
                      //       builder: (context) => const FriendsDetail(),
                      //     ),
                      //     );
                      //   },
                      // )
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 47,
                        width: 87,
                        decoration: BoxDecoration(
                            color: AppColors.PRIMARY_COLOR,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 4,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              )
                            ]),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              EasyLoading.show();
                              acceptFriendRequest(controller.model.value.data![index].userId).then((value) {
                                if(value.status){
                                  EasyLoading.dismiss();
                                  Fluttertoast.showToast(
                                      msg:value.message,
                                      backgroundColor: AppColors.PRIMARY_COLOR);
                                  controller.getFriendsRequsetData();
                                }
                                return null;
                              });
                            },
                            child: Text(
                              'Accept',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: fontFamilyName,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                letterSpacing: 0.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 47,
                        width: 87,
                        decoration: BoxDecoration(
                            color: AppColors.PRIMARY_COLOR,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 4,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              )
                            ]),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              EasyLoading.show();
                              rejectFriendRequest(controller.model.value.data![index].userId).then((value) {
                                if(value.status){
                                  EasyLoading.dismiss();
                                  Fluttertoast.showToast(
                                      msg:value.message,
                                      backgroundColor: AppColors.PRIMARY_COLOR);
                                  controller.getFriendsRequsetData();
                                }
                                return null;
                              });
                            },
                            child: Text(
                              'Decline',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: fontFamilyName,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                letterSpacing: 0.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 8,
                  thickness: 4,
                  color: AppColors.PRIMARY_COLOR,
                );
              },
            )
                : Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }
}
