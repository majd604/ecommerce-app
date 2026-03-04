// ignore_for_file: deprecated_member_use

import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app/common/widgets/shimmer/addresses_shimmer.dart';
import 'package:ecommerce_app/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app/features/personalization/models/address_model.dart';
import 'package:ecommerce_app/features/personalization/screens/address/add_new_address.dart';
import 'package:ecommerce_app/features/personalization/screens/address/widgets/single_address.dart';
import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/helper/cloud_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddressSecreen extends StatelessWidget {
  const AddressSecreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    return Scaffold(
      appBar: UAppBar(
        showBackArrow: true,
        title: Text(
          "Addresses",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: UPadding.screenPadding,
          child: Obx(
            () => FutureBuilder(
              key: Key(controller.refreshData.toString()),
              future: controller.getAllAddress(),
              builder: (context, snapshot) {
                //Handle,Loader,Error,Empty
                const loader = UAddressesShimmer();
                final widget = UCloudHelperFunctions.checkMultiRecordState(
                  snapshot: snapshot,
                  loader: loader,
                );
                if (widget != null) return widget;
                //Data found - Addresses found
                List<AddressModel> addresses = snapshot.data!;
                return ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final address = addresses[index];

                    return Dismissible(
                      key: ValueKey(address.id),
                      direction: DismissDirection.endToStart,

                      // الخلفية اللي بتظهر أثناء السحب (Delete)
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: UColors.error,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete),
                      ),

                      // تأكيد قبل الحذف
                      confirmDismiss: (_) async {
                        return await Get.dialog<bool>(
                              Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      // 🗑️ Icon
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red.withOpacity(0.1),
                                        ),
                                        child: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      // Title
                                      Text(
                                        "Delete Address",
                                        style: Theme.of(Get.context!)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),

                                      const SizedBox(height: 25),

                                      // Message
                                      Text(
                                        "Are you sure you want to delete this address?",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(
                                          Get.context!,
                                        ).textTheme.bodyMedium,
                                      ),

                                      const SizedBox(height: 35),

                                      // Buttons Row
                                      Row(
                                        children: [
                                          // Cancel Button
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () =>
                                                  Get.back(result: false),
                                              child: const Text("Cancel"),
                                            ),
                                          ),

                                          const SizedBox(width: 22),

                                          // Delete Button (Red)
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                              ),
                                              onPressed: () =>
                                                  Get.back(result: true),
                                              child: const Text("Delete"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ) ??
                            false;
                      },

                      // التنفيذ بعد الموافقة
                      onDismissed: (_) async {
                        await controller.deleteAddress(address);
                      },

                      child: USingleAddress(
                        onTap: () => controller.selectAddress(address),
                        address: address,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      SizedBox(height: USizes.spaceBtwItems),
                  itemCount: addresses.length,
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddNewAddressScreen()),
        backgroundColor: UColors.primary,
        child: Icon(Iconsax.add),
      ),
    );
  }
}
