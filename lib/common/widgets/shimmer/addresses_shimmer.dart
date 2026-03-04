import 'package:ecommerce_app/common/widgets/shimmer/shimmer_effect.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';

class UAddressesShimmer extends StatelessWidget {
  const UAddressesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) =>
          UShimmerEffect(width: double.infinity, height: 120),
      separatorBuilder: (context, index) =>
          SizedBox(height: USizes.spaceBtwItems),
      itemCount: 5,
    );
  }
}
