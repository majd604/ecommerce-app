import 'package:ecommerce_app/utlis/helper/device_helper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnBordingPage extends StatelessWidget {
  const OnBordingPage({
    super.key,
    required this.animation,
    required this.title,
    required this.subTitle,
  });
  final String animation;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: UDeviceHelper.getAppBarHeight()),
      child: Column(
        children: [
          //Animation
          Lottie.asset(animation),
          //Title
          Text(
            title,
            // textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 20),
          //sub_Title
          Text(subTitle, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
