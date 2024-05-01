import 'dart:convert';

import 'package:get/get.dart';
import 'package:prescribo/controller/registration_controller.dart';
import 'package:prescribo/main.dart';
import 'package:prescribo/models/register_response.dart';
import 'package:http/http.dart' as http;
import 'package:prescribo/services/urls.dart';
import 'package:prescribo/utils/constants.dart';

class RemoteServices {
  static Future<RegisterResponse?> registration(
    context,
    String? username,
    String? email,
    String? password1,
    String? password2,
  ) async {
    try {
      http.Response response = await http.post(
        registerUri,
        body: jsonEncode({
          "username": username,
          "email": email,
          "password1": password1,
          "password2": password2,
        }),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
        },
      );
      Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      if (response.statusCode == 201) {
        Get.showSnackbar(Constants.customSnackBar(
            tag: true, message: "Account Successfully Created"));

        Get.toNamed("/login");
      } else {
        Get.put(RegistrationController()).isClicked.value = false;
        Constants.printValues(responseData);
        // throw Exception("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print(e);
      Get.put(RegistrationController()).isClicked.value = false;
      Get.showSnackbar(Constants.customSnackBar(tag: false, message: "$e"));
    }
    return null;
  }
}
