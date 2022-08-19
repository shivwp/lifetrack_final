import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';
import '../components/login_tf.dart';
import '../models/forgot_otp_response.dart';
import '../network/api_base_helper.dart';
import '../network/api_response.dart';
import 'otp_verification.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
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
                            'Enter email associated with your account',
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
                      child: LoginTF(
                          hintText: 'Email',
                          icon: const Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                          ),
                          controller: emailController,
                          validator: MultiValidator([
                            RequiredValidator(errorText: '* Required'),
                            EmailValidator(errorText: 'Enter valid email')
                          ])),
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
                              _callOtpApi();
                            },
                            child: const Text(
                              'Send Verification code',
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

  void _callOtpApi() async {
    if (formkey.currentState?.validate() ?? false) {
      if (emailController.text.isEmpty) {
        Fluttertoast.showToast(
            msg: 'Enter email!', backgroundColor: AppColors.PRIMARY_COLOR);
        return;
      }
      EasyLoading.show();
      Map<String, dynamic> param = {
        "email": emailController.text.trim(),
      };
      ApiResponse<dynamic>? response =
          await ApiBaseHelper.getInstance().post('forget_password_otp', param);
      try {
        final model = ForgotPasswordOtpResponseModel.fromJson(response?.data);
        EasyLoading.dismiss();
        if (model.status) {
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

  void _moveToOtpVerficationScreen(
      context, ForgotPasswordOtpResponseModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerification(
            email: emailController.text.trim(),
            verificationFor: VerificationFor.forgotPassword),
      ),
    );
  }
}
