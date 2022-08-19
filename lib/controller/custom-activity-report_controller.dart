import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:life_track/models/custom-activity-report_response.dart';
import 'package:life_track/repo/custom-activity-report_repository.dart';

import '../tab/chart.dart';

class CustomActivityController extends GetxController {
  Rx<ModelCustomActivityReportResponse> model = ModelCustomActivityReportResponse().obs;
  RxBool isDataLoading = false.obs;
  RxString ids = ''.obs;
    RxList<dynamic> multipleActivity = [].obs;
  RxString apgSelectedActivity = ''.obs;

  var dataEntriesBarlineActual = RxList<SalesData>.empty(growable: true);
  var dataEntriesBarLineVariance = RxList<SalesData>.empty(growable: true);


  @override
  void onInit() {
    super.onInit();
    getCustomActivityReport('', '', '', '');
    getCustomActivityReportAPG('', '', '', '');
  }

  getCustomActivityReport(userId, activities, startDate, endDate) {
    EasyLoading.show();
    customActivityReport(userId, activities, startDate, endDate).then((value) {
      EasyLoading.dismiss();
      isDataLoading.value = true;
      updateChart01(value);

      return model.value = value;
    });
  }

  getCustomActivityReportAPG(userId, activities, startDate, endDate) {
    EasyLoading.show();
    customActivityReportAPG(userId, activities, startDate, endDate).then((value) {
      EasyLoading.dismiss();
      isDataLoading.value = true;
      updateChart02(value);
      return model.value = value;
    });
  }


  void updateChart01(ModelCustomActivityReportResponse value) {
    dataEntriesBarlineActual.clear();
    for (var l = 0; l < value.data!.barChat.length; l++) {
      dataEntriesBarlineActual.add(SalesData(
        l,
        value.data!.barChat[l].title.toString(),
        double.parse(value.data!.barChat[l].actualTime.toString()),
        value.data!.barChat[l].getColor(),
      ));
    }
  }
  void updateChart02(ModelCustomActivityReportResponse value) {
    dataEntriesBarLineVariance.clear();
    for (var k = 0; k < value.data!.barChat.length; k++) {
      dataEntriesBarLineVariance.add(SalesData(
        k,
        value.data!.barChat[k].title.toString(),
        double.parse(value.data!.barChat[k].actualTime.toString()),
        value.data!.barChat[k].getColor(),
      ));
    }
  }
}
