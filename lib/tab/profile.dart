import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_track/profile/edit_profile.dart';
import 'package:life_track/tab/privacy_settings.dart';
import 'package:life_track/tab/user_settings.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';
import '../controller/get_profile_controller.dart';
import '../loginsignup/login.dart';
import '../models/login_response.dart';
import '../network/shared_pref/shared_preference_helper.dart';
import 'inapp_payment_screen.dart';
import 'notification_settings.dart';
import 'show_planes.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final GetProfileController profileController = Get.put(
      GetProfileController());

  LoginResponseModel? profileModel;

  void _moveToPrivacySettings(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrivacySettings(),
      ),
    );
  }

  void _moveToNotificationsSettings(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationSettings(),
      ),
    );
  }

  void _moveToUserSettings(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserSettings(),
      ),
    );
  }

  _moveToBuyPlanes(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(),
      ),
    );
  }

  @override
  void initState() {
    initProfile();
    super.initState();

    profileController.getData();
  }

  initProfile() async {
    String? profileString = await SharedPreferenceHelper
        .getInstance()
        .userInfo;
    setState(() {
      profileModel =
          LoginResponseModel.fromJson(jsonDecode(profileString ?? ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
        title: Image.asset(
          'assets/images/splash_logo.png',
          width: 159,
          height: 50,
        ),
        centerTitle: true,
      ),
      body: BackgroundGradientContainer(
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 0),
          child: Obx(() {
            return profileController.isDataLoading.value
                ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: profileController.model.value.data!.image != null
                        ? NetworkImage(profileController.model.value.data!.image.toString())
                        : null,
                    //backgroundImage: AssetImage('assets/images/defaultuser.png'),
                    child: profileController.model.value.data!.image.toString() == null
                        ? Image.asset(
                      'assets/images/man1.png',
                      fit: BoxFit.contain,
                      height: 120,
                      width: 120,
                    )
                        : null,
                    radius: 62.0,
                  ),
                ),
                Text(
                  profileController.model.value.data!.name ?? 'Name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: fontFamilyName,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  profileController.model.value.data!.email ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: fontFamilyName,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  height: 47,
                  width: 167,
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
                      onTap: logout,
                      child: const Text(
                        'Sign Out',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: fontFamilyName,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        String title = 'Edit Profile';
                        if (index == 1) {
                          title = 'Privacy Settings';
                        }
                        if (index == 2) {
                          title = 'User Settings';
                        }
                        if (index == 3) {
                          title = 'free user';
                        }
                        return Column(
                          children: [
                            ListTile(
                              minVerticalPadding: 16,
                              onTap: () {
                                if (index == 0) {
                                  // _moveToNotificationsSettings(context);
                                  _moveToEditProfileScreen(context);
                                }
                                if (index == 1) {
                                  _moveToPrivacySettings(context);
                                }
                                if (index == 2) {
                                  _moveToUserSettings(context);
                                }
                                if (index == 4) {
                                  // _moveToUserSettings(context);
                                }
                              },
                              title: Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontFamily: fontFamilyName,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              trailing: index == 3 ?
                              GestureDetector(
                                onTap: () {
                                  _moveToBuyPlanes(context);
                                },
                                child: Container(
                                  height: 44,
                                  width: 100,
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
                                    child: const Text(
                                      'upgrade',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: fontFamilyName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        letterSpacing: 0.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ) : IconButton(
                                color: Colors.white,
                                icon: const Icon(Icons.navigate_next),
                                onPressed: () {},
                              ),
                            ),
                            if (index == 3) // add divider below last row
                              const Divider(
                                height: 4,
                                thickness: 0,
                                color: Colors.white,
                              )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 4,
                          thickness: 0,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
                : Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }

  void _moveToEditProfileScreen(context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const EditProfile(),
    //   ),
    // );

    Get.to(EditProfile(),arguments: [
      profileController.model.value.data!.name.toString(),
      profileController.model.value.data!.image.toString(),
      profileController.model.value.data!.email.toString(),

    ]);
  }

  logout() {
    SharedPreferenceHelper.getInstance().clearPreference();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ));
  }
}
