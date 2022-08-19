import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_track/Utils.dart';
import 'package:life_track/controller/show_privacy_settings_controller.dart';
import 'package:life_track/repo/update_privacy_settings_repository.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({Key? key}) : super(key: key);

  @override
  _PrivacySettingsState createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  final PrivacySettingsController privacySettingsController = Get.put(
      PrivacySettingsController());


  List<PrivacySettingsModel> lstSettings = [
    PrivacySettingsModel(title: 'Profile Photo', isSelected: true),
    PrivacySettingsModel(title: 'Mood Updates', isSelected: false),
    PrivacySettingsModel(title: 'Charts (Group Access)', isSelected: false),
    PrivacySettingsModel(title: 'Budget vs. Actual', isSelected: false),
    PrivacySettingsModel(title: 'Chart Name', isSelected: false),
    PrivacySettingsModel(title: 'Chart Name', isSelected: false),
  ];


  @override
  void initState() {
    super.initState();
    privacySettingsController.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
        title: const Text(
          'Privacy Settings',
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
          child: Obx(() {
            return privacySettingsController.isDataLoading.value
                ? Column(
              children: [
                const Padding(
                  padding:
                  EdgeInsets.only(left: 24, top: 16, right: 24, bottom: 16),
                  child: Text(
                    'You can use the toggles below to select what you want to show other Users',
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
                      itemCount: privacySettingsController.model.value.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          minVerticalPadding: 16,
                          onTap: () {},
                          title: Text(
                            privacySettingsController.model.value.data![index].name.toString(),
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
                                privacySettingsController.model.value.data![index].status = value;
                                print("value::::::"+value.toString());
                                updatePrivacySettings(
                                    privacySettingsController.model.value.data![index].key,
                                    privacySettingsController.model.value.data![index].status).then((value) {
                                      showToast(value.message);
                                      return null;
                                    });
                              });
                            },
                            value: privacySettingsController.model.value.data![index].status,
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
            )
                : Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }
}

class PrivacySettingsModel {
  final String title;
  bool isSelected;

  PrivacySettingsModel({required this.title, required this.isSelected});
}
