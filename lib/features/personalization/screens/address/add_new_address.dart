import 'package:ecommerce_app/common/style/padding.dart';
import 'package:ecommerce_app/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app/common/widgets/button/elevated_button.dart';
import 'package:ecommerce_app/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    return Scaffold(
      appBar: UAppBar(
        showBackArrow: true,
        title: Text(
          "Add new Address",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Form(
            key: controller.addressFormKey,
            child: Column(
              children: [
                //Name
                TextFormField(
                  validator: (value) =>
                      UValidator.validateEmptyText('Name', value),
                  controller: controller.name,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    labelText: "Name",
                  ),
                ),
                SizedBox(height: USizes.spaceBtwInputFields),
                //Phone Number
                TextFormField(
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      UValidator.validateEmptyText('Phone Number', value),
                  controller: controller.phoneNumber,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.mobile),
                    labelText: "Phone Number",
                  ),
                ),
                SizedBox(height: USizes.spaceBtwInputFields),

                //Street & Postal Code
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) =>
                            UValidator.validateEmptyText('Street', value),
                        controller: controller.street,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.building_31),
                          labelText: "Street",
                        ),
                      ),
                    ),
                    SizedBox(width: USizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        validator: (value) =>
                            UValidator.validateEmptyText('Postal Code', value),
                        controller: controller.postalCode,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.code),
                          labelText: "Postal Code",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: USizes.spaceBtwItems),
                //City & State
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) =>
                            UValidator.validateEmptyText('City', value),
                        controller: controller.city,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.building),
                          labelText: "City",
                        ),
                      ),
                    ),
                    SizedBox(width: USizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        validator: (value) =>
                            UValidator.validateEmptyText('State', value),
                        controller: controller.state,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.activity),
                          labelText: "State",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: USizes.spaceBtwInputFields),
                //Country
                TextFormField(
                  validator: (value) =>
                      UValidator.validateEmptyText('Country', value),
                  controller: controller.country,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.global),
                    labelText: "Country",
                  ),
                ),
                SizedBox(height: USizes.spaceBtwSections),
                UElevatedButton(
                  onPress: controller.addNewAddress,
                  child: Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
