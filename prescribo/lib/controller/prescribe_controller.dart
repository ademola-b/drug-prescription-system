import 'package:get/get.dart';

class PrescribeController extends GetxController {
  final data = Get.arguments;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("data:${data}");
  }
}
