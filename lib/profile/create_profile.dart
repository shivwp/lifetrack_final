import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/loginsignup/login.dart';
import 'package:life_track/tutorial/tutorial.dart';

import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';
import '../components/login_tf.dart';
import '../models/update_profile_response.dart';
import '../network/api_base_helper.dart';
import '../network/api_response.dart';

enum ImageSourceType { gallery, camera }

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final ImagePicker _imagePicker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  var _image;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BackgroundGradientContainer(
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 16),
          child: Stack(
            children: [
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                width: deviceWidth,
                margin: const EdgeInsets.only(top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: const [
                          Text(
                            'Create Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontFamily: fontFamilyName,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 54,
                                backgroundColor: Colors.grey,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: _image == null
                                      ? Image.asset(
                                          'assets/images/defaultuser.png',
                                          fit: BoxFit.contain,
                                          height: 40,
                                          width: 40,
                                        ).image
                                      : Image.file(
                                          _image,
                                          fit: BoxFit.cover,
                                        ).image,
                                  radius: 50.0,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  child: buildEditIcon(Colors.white),
                                  onTap: showImageOptions,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Upload Profile Photo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: fontFamilyName,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          Form(
                            key: formKey,
                            autovalidateMode: AutovalidateMode.always,
                            child: LoginTF(
                              hintText: 'Your Name',
                              controller: nameController,
                              validator: MultiValidator(
                                  [RequiredValidator(errorText: '* Required')]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      AppColors.SUBMIT_BUTTON_BACKGROUND),
                              minimumSize: MaterialStateProperty.resolveWith(
                                (states) => const Size.fromHeight(50),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              _callProfileApi();
                            },
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontFamily: fontFamilyName,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.blue,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.add,
            color: Colors.blue,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  showImageOptions() {
    showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Type",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal),
                    ),
                    TextButton(
                      onPressed: () {
                        _handleURLButtonPress(context, ImageSourceType.camera);
                      },
                      child: const Text(
                        'Camera',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: fontFamilyName,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _handleURLButtonPress(context, ImageSourceType.gallery);
                      },
                      child: const Text(
                        'Gallery',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: fontFamilyName,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  void _handleURLButtonPress(BuildContext context, var type) async {
    var source = type == ImageSourceType.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    setState(() {
      _image = File(image?.path ?? "");
      Navigator.of(context).pop();
    });
  }

  void _callProfileApi() async {
    if (_image == null) {
      Fluttertoast.showToast(
          msg: 'Select profile photo!',
          backgroundColor: AppColors.PRIMARY_COLOR);
      return;
    }
    if (formKey.currentState?.validate() ?? false) {
      EasyLoading.show();
      Map<String, String> param = {
        "name": nameController.text.trim(),
      };
      ApiResponse<dynamic>? response = await ApiBaseHelper.getInstance()
          .postApiCallMultipart('update_profile', param, 'user_image', _image);
      try {
        final model = UpdateProfileResponseModel.fromJson(response?.data);
        EasyLoading.dismiss();
        if (model.status ?? false) {
           // _moveToTutorialScreen(context);
          _moveToLoginScreen(context);

        } else {
          Fluttertoast.showToast(
              msg: model.message ?? 'Something went wrong!',
              backgroundColor: AppColors.PRIMARY_COLOR);
        }
      } on Exception catch (e) {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: 'Decoding failed! $e',
            backgroundColor: AppColors.PRIMARY_COLOR);
      }
    }
  }

  void _moveToTutorialScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TutorialScreen(),
      ),
    );
  }
  void _moveToLoginScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }
}
