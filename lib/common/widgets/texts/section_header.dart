import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:flutter/material.dart';

class USectinHeading extends StatelessWidget {
  const USectinHeading({
    super.key,
    this.textColor,
    required this.title,
    this.buttonTitle = "View All",
    this.onPressed,
    this.showActionButton = true,
  });
  final Color? textColor;
  final String title, buttonTitle;
  final VoidCallback? onPressed;
  final bool showActionButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showActionButton)
          TextButton(
            onPressed: onPressed,
            child: Text(buttonTitle, style: TextStyle(color: UColors.primary)),
          ),
      ],
    );
  }
}
