import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:life_track/network/shared_pref/shared_preference_helper.dart';
import 'package:pinput/pinput.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';
import '../models/resent_otp_response.dart';
import '../network/api_base_helper.dart';
import '../network/api_response.dart';
import '../profile/create_profile.dart';
import 'newpassword.dart';

enum VerificationFor {
  signup,
  forgotPassword,
}

class OtpVerification extends StatefulWidget {
  String? email;
  VerificationFor verificationFor = VerificationFor.signup;

  OtpVerification({required this.email, required this.verificationFor});
  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final formKey = GlobalKey<FormState>();
  final pinController = TextEditingController();
  late Timer? _timer;
  int _start = 0;
  String otpInput = '';
  void startTimer() {
    _start = 30;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    SharedPreferenceHelper.getInstance().saveUserEmail(widget.email ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double otpWidthHeight = (deviceWidth - 80) / 6;
    final defaultPinTheme = PinTheme(
      width: otpWidthHeight,
      height: otpWidthHeight,
      textStyle: const TextStyle(
        fontFamily: fontFamilyName,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
    );
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '2 Step Verification',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontFamily: fontFamilyName,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'A 6-digit verification code was just sent ${widget.email}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: fontFamilyName,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Form(
                        key: formKey,
                        child: Pinput(
                          controller: pinController,
                          length: 6,
                          defaultPinTheme: defaultPinTheme,
                          errorTextStyle: const TextStyle(
                            fontFamily: fontFamilyName,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          /*validator: (s) {
                            return s == '2222' ? null : 'Pin is incorrect';
                          },*/
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          onCompleted: (pin) {
                            otpInput = pin;
                            print(pin);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Resend OTP again in ${_start}s',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: fontFamilyName,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Didn`t receive a code?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextButton(
                                  onPressed: _start == 0
                                      ? () {
                                          resendOTP();
                                        }
                                      : null,
                                  child: const Text(
                                    'Resend Code',
                                    style: TextStyle(
                                      fontFamily: fontFamilyName,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          AppColors.SUBMIT_BUTTON_BACKGROUND),
                                  minimumSize:
                                      MaterialStateProperty.resolveWith(
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
                                  verifyOTP();
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
                          ],
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

  resendOTP() async {
    EasyLoading.show();
    Map<String, dynamic> param = {
      "email": widget.email,
    };
    ApiResponse<dynamic>? response = await ApiBaseHelper.getInstance().post(
        widget.verificationFor == VerificationFor.signup
            ? 'resendotpusers'
            : 'resend_otp',
        param);
    final model = ResendOTPResponseModel.fromJson(response?.data);
    EasyLoading.dismiss();
    pinController.clear();
    startTimer();
    Fluttertoast.showToast(
        msg: model.message ?? 'Something went wrong!',
        backgroundColor: AppColors.PRIMARY_COLOR);
  }

  void verifyOTP() async {
    //if (formKey.currentState?.validate() ?? false) {}
    EasyLoading.show();
    Map<String, dynamic> param = {
      "email": widget.email,
      "otp": otpInput,
    };
    ApiResponse<dynamic>? response =
        await ApiBaseHelper.getInstance().post('veryotp', param);
    try {
      final model = ResendOTPResponseModel.fromJson(response?.data);
      EasyLoading.dismiss();
      if (model.status) {
        if (widget.verificationFor == VerificationFor.forgotPassword) {
          _moveToNewPasswordScreen(context);
        }
        if (widget.verificationFor == VerificationFor.signup) {
          SharedPreferenceHelper.getInstance().saveIsVerified(true);
          _moveToCreateProfileScreen(context);
        }
      } else {
        Fluttertoast.showToast(
            msg: model.message ?? 'Something went wrong!',
            backgroundColor: AppColors.PRIMARY_COLOR);
      }
    } on Exception catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: 'Decoding failed! $e', backgroundColor: AppColors.PRIMARY_COLOR);
    }
  }

  void _moveToNewPasswordScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPassword(
          email: widget.email,
        ),
      ),
    );
  }

  void _moveToCreateProfileScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateProfile(),
      ),
    );
  }
}
