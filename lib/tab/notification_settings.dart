import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  List<NotificationSettingsModel> lstSettings = [
    NotificationSettingsModel(title: 'Notification 1', isSelected: true),
    NotificationSettingsModel(title: 'Notification 2', isSelected: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
        title: const Text(
          'Notification Settings',
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
              const Padding(
                padding:
                    EdgeInsets.only(left: 24, top: 16, right: 24, bottom: 16),
                child: Text(
                  'You can toggle the charts on/off based on what you want to show',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: fontFamilyName,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
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
                        onTap: () {},
                        title: Text(
                          lstSettings[index].title,
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
                              lstSettings[index].isSelected = value;
                            });
                          },
                          value: lstSettings[index].isSelected,
                          trackColor: Colors.white,
                          thumbColor: AppColors.PRIMARY_COLOR,
                          activeColor: Colors.white,
                        ),
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
