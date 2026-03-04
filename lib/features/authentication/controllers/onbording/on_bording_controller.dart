import 'package:ecommerce_app/features/authentication/screens/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnBordingController extends GetxController {
  static OnBordingController get instance => Get.find();

  final storage = GetStorage();

  /// Variables
  final pageController = PageController();
  RxInt currentIndex = 0.obs;

  /// Update current index when page scroll
  void updatePageIndicator(index) {
    currentIndex.value = index;
  }

  /// Jump to specific dot selected page
  void dotNavicationClick(index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  /// Update current index and jump to the next page
  void nextPage() {
    if (currentIndex.value == 2) {
      storage.write('isFirstTime', false);
      Get.offAll(() => LoginScreen());
      return;
    }
    currentIndex++;
    pageController.jumpToPage(currentIndex.value);
  }

  ///  Update current index and jump to the last page

  void skipPage() {
    currentIndex.value = 2;
    pageController.jumpToPage(currentIndex.value);
  }
}
