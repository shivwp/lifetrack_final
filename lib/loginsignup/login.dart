import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:life_track/network/shared_pref/shared_preference_helper.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';
import '../components/login_tf.dart';
import '../models/login_response.dart';
import '../models/signup_response.dart';
import '../network/api_base_helper.dart';
import '../network/api_response.dart';
import '../tab/tab.dart';
import 'forgot_password.dart';
import 'otp_verification.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isLoginClicked = true;
  int valPrivacyPolicy = -1;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  var fcmToken;

  @override
  void initState() {
    // emailController.text = 'testing8@gmail.com';
    // passwordController.text = "Testing8@123";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: BackgroundGradientContainer(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.1),
              child: Column(
//mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/splash_logo.png',
                    width: 250,
                    height: 81,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLoginClicked = true;
                          });
                          emailController.clear();
                          passwordController.clear();
                          repasswordController.clear();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 3.0,
                                  color: isLoginClicked
                                      ? Colors.white
                                      : Colors.transparent),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: fontFamilyName,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLoginClicked = false;
                          });
                          emailController.clear();
                          passwordController.clear();
                          repasswordController.clear();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 3.0,
                                  color: !isLoginClicked
                                      ? Colors.white
                                      : Colors.transparent),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: fontFamilyName,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: formkey,
                    child: Expanded(
                      child: Column(
                        children: [
                          LoginTF(
                            hintText: 'Email',
                            icon: const Icon(
                              Icons.email_outlined,
                              color: Colors.grey,
                            ),
                            controller: emailController,
                            validator: MultiValidator([
                              RequiredValidator(errorText: '* Required'),
                              EmailValidator(errorText: 'Enter valid email')
                            ]),
                          ),
                          LoginTF(
                            hintText: 'Password',
                            icon: const Icon(
                              Icons.lock_outline_rounded,
                              color: Colors.grey,
                            ),
                            controller: passwordController,
                            validator: MultiValidator([
                              RequiredValidator(errorText: '* Required'),
                              MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
                              PatternValidator(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}$',
                                  errorText: 'Password must have special character, digit, lower case and upper case')
                            ]),
                            isPasswordField: true,
                          ),
                          if (!isLoginClicked) ...[
                            LoginTF(
                              hintText: 'Re-Enter Password',
                              icon: const Icon(
                                Icons.lock_outline_rounded,
                                color: Colors.grey,
                              ),
                              controller: repasswordController,
                              validator: (text) {
                                if (text?.isEmpty ?? true) {
                                  return '* Required';
                                } else {
                                  return null;
                                }
                              },
                              isPasswordField: true,
                            ),
                            ListTile(
                              onTap: () {
                                setState(() {
                                  valPrivacyPolicy =
                                      valPrivacyPolicy == 0 ? 1 : 0;
                                });
                              },
                              title: const Align(
                                child: Text(
                                  "I agree with Privacy Policy",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                alignment: Alignment(-1.4, 0),
                              ),
                              leading: Radio<int>(
                                value: 1,
                                groupValue: valPrivacyPolicy,
                                onChanged: (value) {
                                  setState(() {
                                    valPrivacyPolicy = value ?? 0;
                                  });
                                },
                                activeColor: Colors.blueAccent,
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white),
                                toggleable: true,
                              ),
                            )
                          ],
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (isLoginClicked)
                                  TextButton(
                                    onPressed: () {
                                      _moveToForgotPassword(context);
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        fontFamily: fontFamilyName,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 16),
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
                                    onPressed: () async {
                                      //_moveToOtpVerficationScreen(context);
                                      fcmToken = await FirebaseMessaging.instance.getToken();
                                      print("fcm token::::"+fcmToken.toString());

                                      if (isLoginClicked) {
                                        _callLoginApi();
                                      } else {
                                        _callSignupApi();
                                      }
                                    },
                                    child: Text(
                                      isLoginClicked ? 'Login' : 'Sign up',
                                      style: const TextStyle(
                                        fontFamily: fontFamilyName,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                /*
                                if (!isLoginClicked)
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Skip',
                                      style: TextStyle(
                                        fontFamily: fontFamilyName,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                */
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void validate() {
    if (formkey.currentState?.validate() ?? false) {
      print('Validated inputs');
    } else {
      print('Invalidated inputs');
    }
  }

  void _callLoginApi() async {
    validate();
    if (formkey.currentState?.validate() ?? false) {
      EasyLoading.show();
      Map<String, dynamic> param = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "fcm_token": fcmToken.toString()
      };

      print("fcm token"+param.toString());
      ApiResponse<dynamic>? response =
          await ApiBaseHelper.getInstance().post('login', param);
      try {
        final model = LoginResponseModel.fromJson(response?.data);
        EasyLoading.dismiss();
        if (model.status) {
          SharedPreferenceHelper.getInstance().saveApiToken(model.data?.token ?? '');
          SharedPreferenceHelper.getInstance().saveUserInfo(jsonEncode(model));
          SharedPreferenceHelper.getInstance().saveIsLoggedIn(true);
          _moveToTab(context);
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

  void _moveToTab(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AppTabController(),
      ),
    );
  }

  void _callSignupApi() async {
    validate();
    if (formkey.currentState?.validate() ?? false) {
      if (passwordController.text != repasswordController.text) {
        Fluttertoast.showToast(
            msg: 'Password and re enter password not match!',
            backgroundColor: AppColors.PRIMARY_COLOR);
        return;
      }
      if (valPrivacyPolicy != 1) {
        Fluttertoast.showToast(
            msg: 'Please accept privacy policy',
            backgroundColor: AppColors.PRIMARY_COLOR);
        return;
      }
      EasyLoading.show();
      Map<String, dynamic> param = {
        "first_name": '',
        "last_name": '',
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };
      ApiResponse<dynamic>? response =
          await ApiBaseHelper.getInstance().post('signup', param);
      try {
        final model = SignupResponseModel.fromJson(response?.data);
        EasyLoading.dismiss();
        if (model.status ?? false) {
          SharedPreferenceHelper.getInstance().saveApiToken(model.token ?? '');
          SharedPreferenceHelper.getInstance().saveIsVerified(false);
          _moveToOtpVerficationScreen(context, model);
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

  void _moveToOtpVerficationScreen(context, SignupResponseModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerification(
            email: model.data?.email, verificationFor: VerificationFor.signup),
      ),
    );
  }

  void _moveToForgotPassword(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPassword(),
      ),
    );
  }
}
