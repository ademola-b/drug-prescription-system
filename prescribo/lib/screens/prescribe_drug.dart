import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescribo/controller/prescribe_controller.dart';
import 'package:prescribo/utils/defaultText.dart';

class PrescribeDrug extends StatelessWidget {
  PrescribeDrug({super.key});

  final controller = Get.put(PrescribeController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: DefaultText(text: "Prescribe Drug ${controller.data}"),
      ),
    );
  }
}
