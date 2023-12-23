import 'package:get/get.dart';
import 'package:mycalender/model/in_app_calender_model_class.dart';
import 'package:mycalender/utils/static_data.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppCalenderController extends GetxController{

  RxList<InAppCalenderModelClass> inAppEventList = <InAppCalenderModelClass>[].obs ;


  setInAppEventList(DateTime date){

    // Sorting the list based on priority (High > Medium > Low)
    inAppCalendarItems.sort((a, b) {
      // Custom comparison function
      Map<String, int> priorityOrder = {"High": 1, "Medium": 2, "Low": 3};
      return priorityOrder[a.prioritySatus]! - priorityOrder[b.prioritySatus]!;
    });

    inAppEventList.assignAll(inAppCalendarItems);
  }


  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
