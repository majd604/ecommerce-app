import 'package:ecommerce_app/common/widgets/custom_shapes/clipper/custom_rounded_shape.dart';
import 'package:flutter/material.dart';

class URoundedEdgesContainer extends StatelessWidget {
  const URoundedEdgesContainer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: UCustomRoundedEdge(), child: child);
  }
}
