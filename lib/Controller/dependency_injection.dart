import 'package:get/get.dart';
import 'Internet_Controller.dart';

class DependencyInjection {

  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true);
  }
}