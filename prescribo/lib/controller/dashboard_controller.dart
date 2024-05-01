import 'package:get/get.dart';
import 'package:prescribo/models/user_details.dart';
import 'package:prescribo/services/remote_services.dart';

class DashboardController extends GetxController {
  var isClicked = false.obs;

  RxString userType = ''.obs;
  RxString username = ''.obs;
  RxString noUser = ''.obs;
  RxBool isLoading = false.obs;

  getUserDetails() async {
    try {
      isLoading.value = true; // Set isLoading to true when fetching data
      UserDetailResponse? user = await RemoteServices.userDetails();

      if (user != null) {
        userType.value = user.userType!;
      }
    } finally {
      isLoading.value = false; // Set isLoading to false after data is fetched
    }
  }

  getUserDetailsWithUsername(String? username) async {
    UserDetailResponse? user =
        await RemoteServices.userDetails(username: username);

    if (user != null) {
      Get.close(1);
      Get.toNamed("/viewPatientDetail", arguments: {'user': user});
    } else {
      noUser.value = "User Not Found";
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserDetails();
  }
}
