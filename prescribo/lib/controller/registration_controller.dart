import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultText.dart';

class RegistrationController extends GetxController {
  var passwordHidden = true.obs;
  var isClicked = false.obs;

  RxString username = ''.obs;
  RxString email = ''.obs;
  RxString password1 = ''.obs;
  RxString password2 = ''.obs;
}
