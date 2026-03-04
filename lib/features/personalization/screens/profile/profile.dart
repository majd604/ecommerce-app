import 'package:ecommerce_app/common/widgets/texts/section_header.dart';
import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';
import 'package:ecommerce_app/features/personalization/screens/address/address.dart';
import 'package:ecommerce_app/features/personalization/screens/profile/widgets/profile_primary_header.dart';
import 'package:ecommerce_app/features/personalization/screens/profile/widgets/setting_menu_tile.dart';
import 'package:ecommerce_app/features/personalization/screens/profile/widgets/user_profile_tile.dart';
import 'package:ecommerce_app/features/shop/secreens/cart/cart.dart';
import 'package:ecommerce_app/features/shop/secreens/order/order.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Primary Header
            UProfilePimaryHeader(),
            // Details
            Padding(
              padding: const EdgeInsets.all(USizes.defaultSpace),
              child: Column(
                children: [
                  //User Profile Details
                  UserProfileTile(),
                  SizedBox(height: USizes.spaceBtwItems),
                  //Account Settings Header
                  USectinHeading(
                    title: "Account Settings",
                    showActionButton: false,
                  ),
                  //Setting Menu
                  SettingMenuTile(
                    onTap: () => Get.to(() => AddressSecreen()),
                    icon: Iconsax.safe_home,
                    title: " My Addresses",
                    subTitle: "Set shopping delivery addresses",
                  ),
                  SettingMenuTile(
                    onTap: () => Get.to(() => CartScreen()),
                    icon: Iconsax.shopping_cart,
                    title: " My Cart",
                    subTitle: "Add, remove products and move to checkout",
                  ),
                  SettingMenuTile(
                    onTap: () => Get.to(() => OrderScreen()),
                    icon: Iconsax.bag_tick,
                    title: " My Orders",
                    subTitle: "In-progress and Completed Orders",
                  ),
                  SizedBox(height: USizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: AuthenticationRepositry.instance.logout,
                      child: Text("Logout"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
