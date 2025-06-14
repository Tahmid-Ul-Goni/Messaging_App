import 'package:flutter/material.dart';
Widget customTextField(
    controller,
    keyboardType,

    validator,{ hint,
      prefixIcon,
      obscureText = false,
      suffixIcon
    }) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    validator: validator,
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 15,
      ),
      prefixIcon: Icon(prefixIcon,size: 18,),

    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(12),),
    focusedBorder:OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green,width: 2),
    ), ),


     );
}