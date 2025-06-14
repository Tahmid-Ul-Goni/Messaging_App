import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:untitled12/Bussiness%20logic/Auth.dart';
import 'package:untitled12/Bussiness%20logic/Custom_button.dart';
import 'package:untitled12/Route.dart';
import 'Bussiness logic/Auth.dart';
import 'Bussiness logic/CutomField.dart';

class SingIn extends StatelessWidget {
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
                "Login To Your Account",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: Colors.lightGreen,
                ),
              ),
              const SizedBox(height: 50),
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
              hint: "Password",
                obscureText: true,
                prefixIcon: Icons.remove_red_eye_outlined,
              ),
              const SizedBox(height: 40),
              authButton(
                "Login",
                () => login(
                  _emailController.text,
                  _passwordController.text,
                  context,
                ),
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.center, //
                child: Text(
                  "--OR--",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: "Don’t have an account?  ",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "SignUp",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.lightGreen,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () => Get.toNamed(Singup),
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
}
