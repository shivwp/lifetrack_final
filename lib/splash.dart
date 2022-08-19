import 'package:flutter/material.dart';
import 'package:life_track/network/shared_pref/shared_preference_helper.dart';
import 'package:life_track/tab/tab.dart';

import '../Contants/appcolors.dart';
import 'loginsignup/login.dart';
import 'loginsignup/otp_verification.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    if (await SharedPreferenceHelper.getInstance().isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AppTabController(),
        ),
      );
    } else if (await SharedPreferenceHelper.getInstance().isVerified == false &&
        (await SharedPreferenceHelper.getInstance().userEmail ?? '') != '') {
      String email = await SharedPreferenceHelper.getInstance().userEmail ?? '';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerification(
              email: email, verificationFor: VerificationFor.signup),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              AppColors.PRIMARY_COLOR,
              AppColors.PRIMARY_COLOR_LIGHT,
              Colors.black
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash_logo.png',
              width: 300,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
