import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';
import '../components/login_tf.dart';
import '../models/reset_password_response.dart';
import '../network/api_base_helper.dart';
import '../network/api_response.dart';
import 'login.dart';

class NewPassword extends StatefulWidget {
  String? email;
  NewPassword({required this.email});

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

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
                            'Forgot Password',
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
                          Text(
                            'Set up your new password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: fontFamilyName,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    ),
                    Form(
                        key: formkey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Expanded(
                          child: Column(
                            children: [
                              LoginTF(
                                hintText: 'Password',
                                icon: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Colors.grey,
                                ),
                                controller: passwordController,
                                validator: MultiValidator([
                                  RequiredValidator(errorText: '* Required'),
                                  MinLengthValidator(6,
                                      errorText:
                                          'Password must be at least 6 digits long'),
                                  PatternValidator(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}$',
                                      errorText:
                                          'Password must have special character, digit, lower case and upper case')
                                ]),
                                isPasswordField: true,
                              ),
                              LoginTF(
                                hintText: 'Re-Enter Password',
                                icon: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Colors.grey,
                                ),
                                controller: rePasswordController,
                                validator: (text) {
                                  if (text?.isEmpty ?? true) {
                                    return '* Required';
                                  } else {
                                    return null;
                                  }
                                },
                                isPasswordField: true,
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => AppColors
                                                    .SUBMIT_BUTTON_BACKGROUND),
                                        minimumSize:
                                            MaterialStateProperty.resolveWith(
                                          (states) => const Size.fromHeight(50),
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        _callResetPasswordApi();
                                      },
                                      child: const Text(
                                        'Save',
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
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _callResetPasswordApi() async {
    if (formkey.currentState?.validate() ?? false) {
      if (passwordController.text != rePasswordController.text) {
        Fluttertoast.showToast(
            msg: 'Password and re enter password not match!',
            backgroundColor: AppColors.PRIMARY_COLOR);
        return;
      }
      EasyLoading.show();
      Map<String, dynamic> param = {
        "email": widget.email,
        "password": passwordController.text.trim(),
        "confirm_password": rePasswordController.text.trim(),
      };
      ApiResponse<dynamic>? response =
          await ApiBaseHelper.getInstance().post('reset_password', param);
      try {
        final model = ResetPasswordResponseModel.fromJson(response?.data);
        EasyLoading.dismiss();
        if (model.status) {
          _moveToLogin();
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

  void _moveToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }
}
