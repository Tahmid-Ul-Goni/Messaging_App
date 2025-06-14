import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:untitled12/Route.dart';
import 'package:untitled12/Sing_in.dart';


import 'Bussiness logic/Auth.dart';
import 'Bussiness logic/Custom_button.dart';
import 'Bussiness logic/CutomField.dart';

class SingUp extends StatelessWidget {
  TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 80),
      child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      const Text(
      "Create Account",
      style: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w500,
      color: Colors.lightGreen,
      ),
      ),
      const SizedBox(height: 12),
      Text(
      "Create your account and start your journey......",
      style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w300,
      ),
      ),
      SizedBox(
      height: 50,
      ),
      customTextField(
      _nameController,
      TextInputType.text,
        (value){},
        hint: "name",
      prefixIcon: Icons.person_2_outlined,
      ),
        customTextField(
          _emailController,

          TextInputType.emailAddress,
              (value) {
            if (value.isEmpty) {
              return 'this feild can\'t empty';
            }
            if (!value.contains(RegExp(r'@'))) {
              return 'enter a valid email adress';
            }
            return null;},
          obscureText: false,
          hint:  "email",

          prefixIcon: Icons.email_outlined,
        ),
        customTextField(
          _passwordController,
          TextInputType.text,
              (value) {
            if (value.isEmpty) {
              return 'this feild can\'t empty';
            }
            else if (value.length<6) {
              return 'password must be at least 6 characters';
            }
            return null;},
          hint: "password",
          obscureText: true,
          prefixIcon: Icons.remove_red_eye_outlined,
        ),
      const SizedBox(height: 40),
      authButton(
      "Create Account",
      () => registration(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
      context,
      ),
      ),
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            "--OR--",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        RichText(
          text: TextSpan(
            text: "Already an user?  ",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: "Log In",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.lightGreen,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Get.toNamed(Singin),
              )
            ],
          ),
        ),
        ],
      ),
      ),
          ),
      );
    }
}
