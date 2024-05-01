import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultButton.dart';
import 'package:prescribo/utils/defaultText.dart';

class ViewPatientDetail extends StatelessWidget {
  ViewPatientDetail({super.key});

  final data = Get.arguments;
  // final controller = Get.put(PrescribeController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        title:
            DefaultText(text: "Prescribe Drug for ${data['user'].firstName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                  child: Image.memory(
                base64Decode(data['user'].imageMem!),
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DefaultButton(
                      onPressed: () {
                        Get.toNamed("/prescribeDrug", arguments: {
                          'username': data['user'].username,
                          'pk': data['user'].pk
                        });
                      },
                      child: const DefaultText(text: "Prescribe Drug"))
                ],
              ),
              Row(
                children: [
                  const DefaultText(
                    text: "NAME: ",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                  DefaultText(
                    text: "${data['user'].firstName} ${data['user'].lastName}",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const DefaultText(
                    text: "EMAIL: ",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                  DefaultText(
                    text: "${data['user'].email}",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const DefaultText(
                    text: "PHONE: ",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                  DefaultText(
                    text: "${data['user'].phone}",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const DefaultText(
                    text: "GENDER: ",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                  DefaultText(
                    text: "${data['user'].gender}",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const DefaultText(
                    text: "DATE OF BIRTH: ",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                  DefaultText(
                    text: "${data['user'].dob}",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const DefaultText(
                    text: "ADDRESS: ",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                  DefaultText(
                    text: "${data['user'].address}",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
