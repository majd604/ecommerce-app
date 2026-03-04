import 'package:ecommerce_app/common/widgets/custom_shapes/circular_container.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/rounded_edges_container.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';

class UPrimaryHeaderContainer extends StatelessWidget {
  const UPrimaryHeaderContainer({
    super.key,
    required this.child,
    required this.height,
  });
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return URoundedEdgesContainer(
      child: Container(
        color: UColors.primary,
        height: height,
        child: Stack(
          children: [
            //Circular Container
            Positioned(
              top: -150,
              right: -160,
              child: UCircularContainer(
                width: USizes.homePrimaryHeaderHeight,
                height: USizes.homePrimaryHeaderHeight,
                backgroundColor: UColors.white.withValues(alpha: 0.1),
              ),
            ),
            //Circular Container
            Positioned(
              top: 50,
              right: -250,
              child: UCircularContainer(
                width: USizes.homePrimaryHeaderHeight,
                height: USizes.homePrimaryHeaderHeight,
                backgroundColor: UColors.white.withValues(alpha: 0.1),
              ),
            ),
            //child
            child,
          ],
        ),
      ),
    );
  }
}
