import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:life_track/repo/user-notification-status_repository.dart';
import 'package:life_track/tab/change_password.dart';
import 'package:life_track/tab/terms_conditions.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';
import 'about_us.dart';
import 'notification_screen.dart';
import 'privacy_policy.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  List<NotificationSettingsModel> ntfSettings = [
    NotificationSettingsModel(title: 'Notification', isSelected: true),
  ];
  List lstSettings = [
    'Change Password',
    'About us',
    'Privacy Policy',
    'Terms & Condition',
  ];

  void _moveToNotifications(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationScreen(),
      ),
    );
  }
  void _moveToChangePassword(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePassword(),
      ),
    );
  }
  void _moveToAboutUs(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutUs(),
      ),
    );
  }
  void _moveToPrivacyPolicy(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicy(),
      ),
    );
  }
  void _moveToTermsConditions(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TermsConditions(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontFamily: fontFamilyName,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: BackgroundGradientContainer(
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ListTile(
                  minVerticalPadding: 16,
                  onTap: () {
                    // _moveToNotifications(context);
                  },
                  title: Text(
                    ntfSettings.elementAt(0).title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontFamily: fontFamilyName,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  trailing: CupertinoSwitch(
                    onChanged: (bool value) {
                      setState(() {
                        ntfSettings.elementAt(0).isSelected = value;
                        userNotificationStatus(ntfSettings.elementAt(0).isSelected).then((value) {
                          if(value.status){
                            Fluttertoast.showToast(
                                msg: value.message,
                                backgroundColor: AppColors.PRIMARY_COLOR);
                          }
                          return null;
                        });
                      });
                    },
                    value: ntfSettings.elementAt(0).isSelected,
                    trackColor: Colors.white,
                    thumbColor: AppColors.PRIMARY_COLOR,
                    activeColor: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: lstSettings.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        minVerticalPadding: 16,
                        onTap: () {
                          if (index == 0) {
                            _moveToChangePassword(context);
                          }
                          if (index == 1) {
                            _moveToAboutUs(context);
                          }
                          if (index == 2) {
                            _moveToPrivacyPolicy(context);
                          }
                          if (index == 3) {
                            _moveToTermsConditions(context);
                          }
                        },
                        title: Text(
                          lstSettings[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontFamily: fontFamilyName,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        // trailing: CupertinoSwitch(
                        //   onChanged: (bool value) {
                        //     setState(() {
                        //       lstSettings[index].isSelected = value;
                        //     });
                        //   },
                        //   value: lstSettings[index].isSelected,
                        //   trackColor: Colors.white,
                        //   thumbColor: AppColors.PRIMARY_COLOR,
                        //   activeColor: Colors.white,
                        // ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationSettingsModel {
  final String title;
  bool isSelected;
  NotificationSettingsModel({required this.title, required this.isSelected});
}