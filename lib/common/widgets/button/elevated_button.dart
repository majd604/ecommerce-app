import 'package:ecommerce_app/utlis/helper/device_helper.dart';
import 'package:flutter/material.dart';

class UElevatedButton extends StatelessWidget {
  const UElevatedButton({
    super.key,
    required this.onPress,
    required this.child,
  });
  final VoidCallback onPress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: UDeviceHelper.getScreenWidth(context),

      child: ElevatedButton(onPressed: onPress, child: child),
    );
  }
}
