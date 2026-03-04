import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';

class UGridLayot extends StatelessWidget {
  const UGridLayot({
    super.key,
    required this.iteamCount,
    this.mainAxisExten = 290,
    required this.itemBuilder,
  });
  final int iteamCount;
  final double? mainAxisExten;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: iteamCount,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: USizes.gridViewSpacing,
        crossAxisSpacing: USizes.gridViewSpacing,
        mainAxisExtent: mainAxisExten,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
