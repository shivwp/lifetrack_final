import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/controller/get_profile_controller.dart';
import 'package:life_track/tutorial/tutorial.dart';

import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';
import '../components/login_tf.dart';
import '../models/update_profile_response.dart';
import '../network/api_base_helper.dart';
import '../network/api_response.dart';

enum ImageSourceType { gallery, camera }

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GetProfileController profileController = Get.put(GetProfileController());

  var userName = Get.arguments[0];
  var userImage = Get.arguments[1];
  var userEmail = Get.arguments[2];

  final ImagePicker _imagePicker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  var _image;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  @override
  void initState() {
    super.initState();
    nameController.text = userName.toString();
    emailController.text = userEmail.toString();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: BackgroundGradientContainer(
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
                              'Edit Profile',
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
                                        ? Image.network(
                                            userImage.toString(),
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
                              child: Column(
                                children: [
                                  LoginTF(
                                    hintText: 'Your Name',
                                    controller: nameController,
                                    validator: MultiValidator(
                                        [RequiredValidator(errorText: '* Required')]),
                                  ),

                              Container(
                                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                  enabled: false,
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'Email Id',
                                    floatingLabelAlignment: FloatingLabelAlignment.start,
                                    errorStyle: const TextStyle(color: Colors.white, fontSize: 8),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                                ],
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
                                // Get.back();
                              },
                              child: const Text(
                                'Update',
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
            Icons.photo,
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
    if (formKey.currentState?.validate() ?? false) {
      EasyLoading.show();
      Map<String, String> param = {
        "name": nameController.text.trim(),
      };
      ApiResponse<dynamic>? response;
      if (_image == null){
        print('notworking');
        response = await ApiBaseHelper.getInstance()
            .post('update_profile', param);
      } else {
        print('working');
        response = await ApiBaseHelper.getInstance()
            .postApiCallMultipart('update_profile', param, 'user_image', _image);
      }

      try {
        final model = UpdateProfileResponseModel.fromJson(response?.data);
        EasyLoading.dismiss();
        if (model.status ?? false) {
         profileController.getData();
          Get.back();

          // _moveToTutorialScreen(context);
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
}
