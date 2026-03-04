import 'package:flutter/material.dart';

class UProductPriceText extends StatelessWidget {
  const UProductPriceText({
    super.key,
    this.currentSign = '\$',
    required this.price,
    this.maxLines = 1,
    this.isLarg = false,
    this.lineThrough = false,
  });
  final String currentSign, price;
  final int maxLines;
  final bool isLarg, lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      currentSign + price,
      style: isLarg
          ? Theme.of(context).textTheme.headlineMedium!.apply(
              decoration: lineThrough ? TextDecoration.lineThrough : null,
            )
          : Theme.of(context).textTheme.titleLarge!.apply(
              decoration: lineThrough ? TextDecoration.lineThrough : null,
            ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
