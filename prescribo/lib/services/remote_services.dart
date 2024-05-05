import 'dart:convert';

import 'package:get/get.dart';
import 'package:prescribo/controller/login_controller.dart';
import 'package:prescribo/controller/registration_controller.dart';
import 'package:prescribo/main.dart';
import 'package:prescribo/models/drugs_response.dart';
import 'package:prescribo/models/login_response.dart';
import 'package:prescribo/models/register_response.dart';
import 'package:http/http.dart' as http;
import 'package:prescribo/models/user_details.dart';
import 'package:prescribo/models/user_update.dart';
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
      var responseData = jsonDecode(response.body);
      print(responseData);
      if (response.statusCode == 201) {
        Get.showSnackbar(Constants.customSnackBar(
            tag: true, message: "Account Successfully Created"));

        Get.toNamed("/updateProf");
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

  static Future<UserUpdateResponse?> updateDetails(
      String? firstName,
      String? lastName,
      String? phone,
      String? gender,
      String? address,
      String? dob) async {
    try {
      http.Response response = await http.put(userUpdateUri,
          body: jsonEncode({
            "first_name": firstName,
            "last_name": lastName,
            "phone": phone,
            "gender": gender,
            "address": address,
            "dob": dob
          }),
          headers: {
            'content-type': 'application/json; charset=UTF-8',
            'Authorization': "Token ${sharedPreferences.getString('token')}"
          });
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.showSnackbar(Constants.customSnackBar(
            tag: true, message: "Bio updated, Login now"));
        Get.offAllNamed("/login");
      } else {
        Get.put(RegistrationController()).isClicked.value = false;
        Constants.printValues(responseData);
      }
    } catch (e) {
      print(e);
      Get.put(RegistrationController()).isClicked.value = false;
      Get.showSnackbar(Constants.customSnackBar(tag: false, message: "$e"));
    }
    return null;
  }

  static Future<UserDetailResponse?> userDetails({String? username}) async {
    try {
      http.Response response;
      if (username != null) {
        response = await http.get(Uri.parse("$baseUrl/auth/user/$username/"),
            headers: {
              'Authorization': "Token ${sharedPreferences.getString('token')}"
            });
      } else {
        response = await http.get(userUri, headers: {
          'Authorization': "Token ${sharedPreferences.getString('token')}"
        });
      }
      if (response.statusCode == 200) {
        print(response.body);
        return userDetailResponseFromJson(response.body);
      } else {
        print(response.reasonPhrase);
        throw Exception("${response.reasonPhrase}");
      }
    } catch (e) {
      Get.showSnackbar(Constants.customSnackBar(
          message: "An error occurred: $e", tag: false));
    }
    return null;
  }

  static Future<LoginResponse?> login(
      String? username, String? password) async {
    try {
      http.Response response = await http
          .post(loginUri, body: {"username": username, "password": password});
      var responseData = jsonDecode(response.body);
      if (responseData != null) {
        if (responseData['key'] != null) {
          sharedPreferences.setString('token', responseData['key']);

          Get.offAllNamed('/dashboard');
        } else if (responseData['non_field_errors'] != null) {
          Get.put(LoginController()).isClicked.value = false;
          Constants.printValues(responseData);
        }
      }
    } catch (e) {
      Get.put(LoginController()).isClicked.value = false;
      Get.showSnackbar(Constants.customSnackBar(
          message: "An error occurred: $e", tag: false));
    }

    return null;
  }

  static Future<List<DrugsResponse>?>? drugList() async {
    try {
      http.Response response = await http.get(drugsUri, headers: {
        'Authorization': "Token ${sharedPreferences.getString('token')}"
      });
      if (response.statusCode == 200) {
        return drugsResponseFromJson(response.body);
      } else {
        throw Exception("Failed to get medicine");
      }
    } catch (e) {
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }
}
