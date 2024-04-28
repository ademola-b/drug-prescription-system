import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main(List<String> args) async {
  runApp(const Prescribo());
}

class Prescribo extends StatelessWidget {
  const Prescribo({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PRESCRIBO',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: "/",
      getPages: [],
    );
  }
}
