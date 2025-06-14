
import 'package:flutter/material.dart';

Widget authButton(String title, final Function onAction) {
  return InkWell(
    onTap: () {
      onAction();
    },
    child: Container(
      height: 48,
      decoration: BoxDecoration(
        color:Colors.lightGreen,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}