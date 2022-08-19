import 'package:flutter/material.dart';

import '../Contants/constant.dart';

class LoginTF extends StatefulWidget {
  String hintText;
  Icon? icon;
  TextEditingController controller;
  FormFieldValidator? validator;
  bool? isPasswordField = false;
  LoginTF(
      {required this.hintText,
      this.icon,
      required this.controller,
      this.validator,
      this.isPasswordField});

  @override
  State<LoginTF> createState() => _LoginTFState();
}

class _LoginTFState extends State<LoginTF> {
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: TextFormField(
        obscureText: (widget.isPasswordField ?? false)
            ? !_passwordVisible
            : _passwordVisible,
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: widget.icon,
          suffixIcon: widget.isPasswordField ?? false
              ? IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  })
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: widget.hintText,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          errorStyle: const TextStyle(color: Colors.white, fontSize: 8),
        ),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: fontFamilyName,
          fontWeight: FontWeight.w500,
        ),
        validator: widget.validator,
      ),
    );
  }
}
