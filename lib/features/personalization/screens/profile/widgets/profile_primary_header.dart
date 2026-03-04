import 'package:ecommerce_app/common/widgets/custom_shapes/primary_header_container.dart';
import 'package:ecommerce_app/common/widgets/images/user_profile_logo.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';

class UProfilePimaryHeader extends StatelessWidget {
  const UProfilePimaryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //total height
        SizedBox(height: USizes.profilePrimaryHeaderHeight + 60),
        UPrimaryHeaderContainer(
          height: USizes.profilePrimaryHeaderHeight,
          child: Container(),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Center(child: UserProfileLogo()),
        ),
      ],
    );
  }
}
