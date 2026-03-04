import 'package:carousel_slider/carousel_controller.dart';
import 'package:ecommerce_app/data/repositories/banner/banner_repository.dart';
import 'package:ecommerce_app/features/shop/models/banners_model.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.find();

  //Variables
  final _repository = Get.put(BannerRepository());
  RxList<BannerModel> banners = <BannerModel>[].obs;
  RxBool isLoading = false.obs;

  final carouselController = CarouselSliderController();
  RxInt currentIndex = 0.obs;
  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  //Fetch All Banners
  Future<void> fetchBanners() async {
    try {
      //start lading
      isLoading.value = true;
      List<BannerModel> activeBanners = await _repository.fetchActiveBanner();
      banners.assignAll(activeBanners);
      isLoading.value = false;
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: "Failed", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
