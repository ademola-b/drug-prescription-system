import 'package:flutter/material.dart';
import 'package:prescribo/utils/defaultText.dart';


class Constants{
  static const Color primaryColor = Color(0xFF5A81FA);
  static const Color altColor = Color(0xFFCDDEFF);
  static const Color backgroundColor = Color(0xFFF2F5FF);
  static const Color secondaryColor = Color(0xFF2C3D8F);
  static const Color containerColor = Color.fromARGB(255, 189, 162, 122);

  static Widget loadingCirc(String action, bool isClicked) {
    if (isClicked) {
      print(isClicked);
      return const CircularProgressIndicator(color: Constants.altColor);
    } else {
      print(isClicked);

      return DefaultText(text: action, color: Colors.white, size: 18.0);
    }
  }

  static String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Field is required";
    }
    return null;
  }

}