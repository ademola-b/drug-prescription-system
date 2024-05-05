import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescribo/models/drug_list.dart';
import 'package:prescribo/models/drugs_response.dart';
import 'package:prescribo/services/remote_services.dart';

class PrescribeController extends GetxController {
  RxString diagnosis = ''.obs;
  RxString? dosage = ''.obs;
  RxString? qty = ''.obs;
  RxString? drug = ''.obs;
  RxString? selectedDrug = ''.obs;
  RxDouble? price = 0.0.obs;
  RxString? drugId = ''.obs;
  RxList<DrugList> drugList = <DrugList>[].obs;
  RxBool isClicked = false.obs;
  Rx<TextEditingController> qtyTxt = TextEditingController().obs;
  Rx<TextEditingController> dosageTxt = TextEditingController().obs;

  RxList<DrugsResponse> drugs = <DrugsResponse>[].obs;

  RxList<Map<String, dynamic>> drugPrescribed = <Map<String, dynamic>>[].obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await drugListRem();
  }

  drugListRem() async {
    print("called");
    List<DrugsResponse>? drugList = await RemoteServices.drugList();
    if (drugList!.isNotEmpty) {
      drugs.value = drugList;
    }
  }

  populateTable() {
    drugList.add(DrugList(
        drugId: drugId!.value,
        name: drug!.value,
        price: price!.value,
        total: double.parse(qtyTxt.value.text) * price!.value,
        qty: qtyTxt.value.text,
        dosage: dosageTxt.value.text));

    print(drugList[0].drugId);
    selectedDrug!.value = drug!.value;

    // initialize drugPrescribed
    Map<String, dynamic> item = {
      "drug": drugId!.value,
      "qty": qtyTxt.value.text,
      "dosage": dosageTxt.value.text,
      "price": price!.value,
      "total": int.parse(qtyTxt.value.text) * price!.value,
    };

    // add to dict
    drugPrescribed.add(item);
    // print(drugPrescribed);
  }

  double calculateTotal(RxList drugList) {
    double total = 0.0;
    for (var drug in drugPrescribed) {
      total += drug['total'];
    }

    return total;
  }
}
