
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/Contants/constant.dart';
import 'package:life_track/components/background_gradient_container.dart';
import 'package:life_track/controller/get_feeling_controller.dart';
import 'package:life_track/controller/get_friends_controller.dart';
import 'package:life_track/tab/friend_detail.dart';

class AllFriendsList extends StatefulWidget {
  const AllFriendsList({Key? key}) : super(key: key);

  @override
  _AllFriendsListState createState() => _AllFriendsListState();
}

class _AllFriendsListState extends State<AllFriendsList> {
  final GetFriendsController controller = Get.put(GetFriendsController());
  // final GetFillingController getFillingController = Get.put(GetFillingController());


  @override
  void initState() {
    super.initState();
    controller.getFriendsdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradientContainer(
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 8),
          child: Obx(() {
            return controller.isDataLoading.value
                ? controller.model.value.data!.length==0?Center(child: Text('No friend Found',style: TextStyle(color: Colors.white),)): ListView.separated(
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
                          child:  controller.model.value.data![index].privacySetting.profilePhoto==true
                              ? Image.network(
                            controller.model.value.data![index].userImage.toString(),
                            fit: BoxFit.contain,
                          ) : SizedBox.shrink(),
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
                      controller.model.value.data![index].privacySetting.moodUpdate==true
                          ? IconButton(
                        color: Colors.white,
                        icon: controller.model.value.data![index].reviewMassge=='Very Sad' ? FaIcon(FontAwesomeIcons.faceFrown)
                            : controller.model.value.data![index].reviewMassge=='Sad' ? FaIcon(FontAwesomeIcons.faceFrownOpen)
                            : controller.model.value.data![index].reviewMassge=='Ok' ? Icon(Icons.add_reaction_outlined)
                            : controller.model.value.data![index].reviewMassge=='Happy' ? FaIcon(FontAwesomeIcons.faceSmile)
                            : controller.model.value.data![index].reviewMassge=='Very Happy'  ? FaIcon(FontAwesomeIcons.faceSmileBeam)
                            : Icon(Icons.add_reaction_outlined),
                        onPressed: () {},
                      ) : SizedBox.shrink(),
                      IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.navigate_next),
                        onPressed: () {
                        Get.to(FriendsDetail(),arguments: [controller.model.value.data![index].userId]);

                          // Navigator.push(
                          //   context, MaterialPageRoute(
                          //   builder: (context) => const FriendsDetail(),
                          // ),
                          // );
                        },
                      )
                    ],
                  ),
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
