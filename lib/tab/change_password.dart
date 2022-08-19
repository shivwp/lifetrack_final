import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:life_track/components/login_tf.dart';
import 'package:life_track/repo/change_password_repository.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldpassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
        title: const Text(
          'Change password',
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
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  LoginTF(
                    hintText: 'Old Password',
                    icon: const Icon(
                      Icons.lock_outlined,
                      color: Colors.grey,
                    ),
                    controller: oldpassword,
                    isPasswordField: true,
                      validator: MultiValidator([
                        RequiredValidator(errorText: '* Required'),
                        MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
                        PatternValidator(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}$',
                            errorText: 'Password must have special character, digit, lower case and upper case')
                      ])
                      // validator: (val){
                      //   if(val.isEmpty)
                      //     return 'should not be Empty';
                      //   return null;
                      // }
                  ),
                  LoginTF(
                    hintText: 'New Password',
                    icon: const Icon(
                      Icons.lock_outlined,
                      color: Colors.grey,
                    ),
                    controller: newPassword,
                    isPasswordField: true,
                    validator: MultiValidator([
                      RequiredValidator(errorText: '* Required'),
                      MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
                      PatternValidator(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}$',
                          errorText: 'Password must have special character, digit, lower case and upper case')
                    ]),
                      // validator: (val){
                      //   if(val.isEmpty)
                      //     return 'should not be Empty';
                      //   return null;
                      // }
                  ),
                  LoginTF(
                    hintText: 'Confirm New Password',
                    icon: const Icon(
                      Icons.lock_outlined,
                      color: Colors.grey,
                    ),
                    controller: confirmNewPassword,
                      isPasswordField: true,
                    validator: (val){
                      if(val.isEmpty)
                        return 'should not be Empty';
                      if(val != newPassword.text)
                        return 'New password & Confirm password Not Match';
                      return null;
                    }

                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.50,),
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
                      onPressed: () {
                        //_moveToOtpVerficationScreen(context);
                        if(_form.currentState!.validate()){
                          changePassword(oldpassword.text.toString(),confirmNewPassword.text.toString()).then((value) {
                            if(value.status==true){
                              Fluttertoast.showToast(
                                  msg:value.message,
                                  backgroundColor: AppColors.PRIMARY_COLOR);
                              Navigator.pop(context);
                            }else if(value.status==false){
                              Fluttertoast.showToast(
                                  msg:value.message,
                                  backgroundColor: AppColors.PRIMARY_COLOR);
                            }
                            return null;
                          });
                        }
                      },
                      child: Text(
                        'Update',
                        style: const TextStyle(
                          fontFamily: fontFamilyName,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

