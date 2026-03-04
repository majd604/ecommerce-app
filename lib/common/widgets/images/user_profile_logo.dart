import 'package:ecommerce_app/common/widgets/images/circular_image.dart';
import 'package:ecommerce_app/common/widgets/shimmer/shimmer_effect.dart';
import 'package:ecommerce_app/features/personalization/controllers/user_controller.dart';
import 'package:ecommerce_app/utlis/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class UserProfileLogo extends StatelessWidget {
  const UserProfileLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Obx(() {
      bool isUserHavePic = controller.user.value.profilePicture.isNotEmpty;
      if (controller.isProfileUploading.value) {
        return UShimmerEffect(width: 120.0, height: 120.0, radius: 120.0);
      }

      return UCircularImage(
        image: isUserHavePic
            ? controller.user.value.profilePicture
            : UImages.profileLogo,
        width: 120,
        height: 120,
        borderWidth: 5.0,
        padding: 0,
        isNetworkImage: isUserHavePic ? true : false,
      );
    });
  }
}
