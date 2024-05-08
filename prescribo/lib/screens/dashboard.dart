import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescribo/controller/dashboard_controller.dart';
import 'package:prescribo/services/remote_services.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultButton.dart';
import 'package:prescribo/utils/defaultGesture.dart';
import 'package:prescribo/utils/defaultText.dart';
import 'package:prescribo/utils/defaultTextFormField.dart';

class Dashboard extends StatelessWidget {
  final controller = Get.put(DashboardController());
  viewDetail() async {}
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        title: const DefaultText(
          text: "Dashboard",
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (controller.userType.value == 'patient') {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        DefaultText(
                            text:
                                "Welcome, \n    ${controller.patient.value.user!.username}")
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const DefaultText(
                        text: "Below cards is your medical history")
                  ],
                ),
              ),
            );
          } else if (controller.userType.value == 'pharmacist') {
            return Column();
          } else if (controller.userType.value == 'doctor') {
            return DoctorWidget();
          } else {
            return Container();
          }
        }
      }),
    );
  }
}

class DoctorWidget extends StatelessWidget {
  DoctorWidget({
    Key? key,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(DashboardController());

  _viewDetail() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();

    controller.getUserDetailsWithUsername(controller.username.value);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // DefaultGesture(
                //   svgAsset: "assets/images/illness.svg",
                //   tag: "Patients",
                //   func: () {
                //     Get.toNamed('/patients');
                //   },
                // ),
                DefaultGesture(
                  svgAsset: "assets/images/pill.svg",
                  tag: "Drugs",
                  func: () {
                    Get.toNamed('/drugs',
                        arguments: {'userType': controller.userType.value});
                  },
                ),
                DefaultGesture(
                  svgAsset: "assets/images/pills_1.svg",
                  tag: "Prescription",
                  func: () {
                    Constants.dialogBox(context,
                        barrier: true,
                        content: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              PatientTextField(),
                              const SizedBox(height: 20.0),
                              DefaultButton(
                                  onPressed: () {
                                    _viewDetail();
                                  },
                                  child:
                                      const DefaultText(text: "View Detail")),
                              DefaultText(text: controller.noUser.value)
                            ],
                          ),
                        ));
                    // Get.toNamed('/prescription');)
                  },
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DefaultGesture(
                  svgAsset: "assets/images/treatment_list.svg",
                  tag: "Reports",
                  func: () {
                    Get.toNamed('/report');
                  },
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15.0)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: const BorderSide(color: Constants.primaryColor),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    Get.toNamed('/scan');
                  },
                  child: const DefaultText(
                    color: Constants.primaryColor,
                    text: "Scan Prescription",
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientTextField extends StatelessWidget {
  PatientTextField({
    Key? key,
  }) : super(key: key);
  final controller = Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: Constants.validator,
      onSaved: (newValue) => controller.username.value = newValue!,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        border: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.white)),
        enabledBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.white)),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: "Enter patient's username",
      ),
      style: const TextStyle(
        fontFamily: 'Montserrat',
      ),
    );
  }
}
