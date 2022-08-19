import 'package:flutter/material.dart';

import '../Contants/constant.dart';

class OTP_TF extends StatelessWidget {
  const OTP_TF({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [
        //TextInputFormatter(),
      ],
      textAlign: TextAlign.center,
      // obscureText: isHideOTP,
      enableSuggestions: false,
      autocorrect: false,
      //autofocus: true,
      //focusNode: focusNodeOtp1,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontFamily: fontFamilyName,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
