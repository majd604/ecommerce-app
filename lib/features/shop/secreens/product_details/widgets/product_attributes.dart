import 'package:ecommerce_app/common/widgets/chips/choice_chip.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/texts/prodect_title_text.dart';
import 'package:ecommerce_app/common/widgets/texts/product_price_text.dart';
import 'package:ecommerce_app/common/widgets/texts/section_header.dart';
import 'package:ecommerce_app/features/shop/controllers/product/variation_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:ecommerce_app/utlis/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UProductAttributes extends StatelessWidget {
  const UProductAttributes({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    final controller = Get.put(VariationController());
    return Obx(
      () => Column(
        children: [
          //Selected Attributes Pricing & Description
          if (controller.selectedVariation.value.id.isNotEmpty)
            URoundedContainer(
              padding: EdgeInsets.all(USizes.sm),
              backgroundColor: dark ? UColors.darkGrey : UColors.grey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Title , Price And Stock
                  Row(
                    children: [
                      USectinHeading(
                        title: "Varidation",
                        showActionButton: false,
                      ),
                      SizedBox(width: USizes.spaceBtwItems),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              //price
                              UProdectTitle(title: "Price : ", smallSize: true),
                              // Actual Price
                              if (controller.selectedVariation.value.salePrice >
                                  0)
                                Text(
                                  "${UItext.currency}${controller.selectedVariation.value.price.toStringAsFixed(0)}",
                                  style: Theme.of(context).textTheme.titleSmall!
                                      .apply(
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                ),
                              SizedBox(width: USizes.spaceBtwItems),
                              //sale price
                              UProductPriceText(
                                price: controller.getVariationPrice(),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              UProdectTitle(title: "Stock : ", smallSize: true),
                              Text(
                                controller.variationStockStaus.value,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: USizes.spaceBtwItems),

                  UProdectTitle(
                    smallSize: true,
                    title: controller.selectedVariation.value.description ?? "",
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          SizedBox(height: USizes.spaceBtwItems),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: product.productAttributes!.map((attributes) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  USectinHeading(
                    title: attributes.name ?? '',
                    showActionButton: false,
                  ),
                  SizedBox(height: USizes.spaceBtwItems / 2),
                  Obx(
                    () => Wrap(
                      spacing: USizes.sm,
                      children: attributes.values!.map((attributesValue) {
                        bool isSelected =
                            controller.selectedAttributes[attributes.name] ==
                            attributesValue;
                        bool available = controller
                            .getAttributesAvilabilityInVariation(
                              product.productVariations!,
                              attributes.name!,
                            )
                            .contains(attributesValue);
                        return UChoiceChip(
                          text: attributesValue,
                          selected: isSelected,
                          onSelected: available
                              ? (selected) {
                                  if (available && selected) {
                                    controller.onAttributesSelected(
                                      product,
                                      attributes.name,
                                      attributesValue,
                                    );
                                  }
                                }
                              : null,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
