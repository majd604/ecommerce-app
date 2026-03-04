import 'package:ecommerce_app/common/widgets/button/elevated_button.dart';
import 'package:ecommerce_app/common/widgets/loader/circular_loader.dart';
import 'package:ecommerce_app/common/widgets/texts/section_header.dart';
import 'package:ecommerce_app/data/repositories/address/address_repository.dart';
import 'package:ecommerce_app/features/personalization/models/address_model.dart';
import 'package:ecommerce_app/features/personalization/screens/address/add_new_address.dart';
import 'package:ecommerce_app/features/personalization/screens/address/widgets/single_address.dart';
import 'package:ecommerce_app/utlis/constants/sizes.dart';
import 'package:ecommerce_app/utlis/helper/cloud_helper_functions.dart';
import 'package:ecommerce_app/utlis/helper/network_manager.dart';
import 'package:ecommerce_app/utlis/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  //Variables
  final _repositry = Get.put(AddressRepository());

  Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  RxBool refreshData = false.obs;
  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final postalCode = TextEditingController();
  final street = TextEditingController();
  final state = TextEditingController();
  final city = TextEditingController();
  final country = TextEditingController();

  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
  //Funcation to add new address to the user
  Future<void> addNewAddress() async {
    try {
      //Start Loadind
      UFullScreenLoader.openLoadingDialog('Storing Address...');
      //Check Intenet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UFullScreenLoader.stopLoading();
        return;
      }
      //Form Validation
      if (!addressFormKey.currentState!.validate()) {
        UFullScreenLoader.stopLoading();
        return;
      }
      //Create Address Model
      AddressModel address = AddressModel(
        id: '',
        name: name.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        street: street.text.trim(),
        city: city.text.trim(),
        state: state.text.trim(),
        postalCode: postalCode.text.trim(),
        country: country.text.trim(),
        dateTime: DateTime.now(),
      );
      //save address
      String addressId = await _repositry.addAddress(address);
      //update address id
      address.id = addressId;

      //update address id
      selectAddress(address);

      //stop loading
      UFullScreenLoader.stopLoading();

      //go back
      Navigator.pop(Get.context!);
      Navigator.pop(Get.context!);
      //show success message
      USnackBarHelpers.successSnackBar(
        title: 'Congratulation',
        message: 'your Address has been save Successfully',
      );
      //refresh address data
      refreshData.toggle();
      //reset fields
      resetFormField();
    } catch (e) {
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
    }
  }

  //fucation to get all addresses of specific user
  Future<List<AddressModel>> getAllAddress() async {
    try {
      List<AddressModel> addresses = await _repositry.fetchUserAddress();
      selectedAddress.value = addresses.firstWhere(
        (address) => address.selectedAddress,
        orElse: () => AddressModel.empty(),
      );
      return addresses;
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
      return [];
    }
  }

  //Funcation to select address
  Future<void> selectAddress(AddressModel newSelecteedAddress) async {
    try {
      //start dialog
      Get.defaultDialog(
        title: '',
        onWillPop: () async => false,
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: UCircularLoader(),
      );
      //un-select the already selected address
      if (selectedAddress.value.id.isNotEmpty) {
        await _repositry.upadteSelectedField(selectedAddress.value.id, false);
      }
      //assign selected address
      newSelecteedAddress.selectedAddress = true;
      selectedAddress.value = newSelecteedAddress;
      //set the selected address to true in firebase
      await _repositry.upadteSelectedField(selectedAddress.value.id, true);
      //go back
      Get.back();
    } catch (e) {
      Get.back();
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
    }
  }

  //Funcation to show Bottom sheet to select address
  Future<void> selectNewAddressBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(USizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  USectinHeading(
                    title: 'Select Address :',
                    showActionButton: false,
                  ),
                  const SizedBox(height: USizes.spaceBtwItems),
                  Obx(
                    () => FutureBuilder(
                      key: Key(refreshData.value.toString()),
                      future: getAllAddress(),
                      builder: (context, snapshot) {
                        //Handle Error ,Loading ,Empty States
                        final widget =
                            UCloudHelperFunctions.checkMultiRecordState(
                              snapshot: snapshot,
                            );
                        if (widget != null) return widget;
                        return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: USizes.spaceBtwItems),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => USingleAddress(
                            address: snapshot.data![index],
                            onTap: () {
                              selectAddress(snapshot.data![index]);
                              Get.back();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: USizes.spaceBtwSections * 2),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: USizes.defaultSpace,
            left: USizes.defaultSpace * 2,
            right: USizes.defaultSpace * 2,
            child: UElevatedButton(
              onPress: () => Get.to(AddNewAddressScreen()),
              child: Text("Add New Address"),
            ),
          ),
        ],
      ),
    );
  }

  /// Delete an address and keep the "only one selected address" rule consistent.
  Future<void> deleteAddress(AddressModel address) async {
    try {
      // 1) Show a blocking loader dialog
      Get.defaultDialog(
        title: '',
        onWillPop: () async => false,
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const UCircularLoader(),
      );

      // 2) Snapshot: Was this address the currently selected one?
      // We must store this BEFORE deleting, because after delete we lose that context.
      final bool wasSelected = address.id == selectedAddress.value.id;

      // 3) Delete the address document from Firestore.
      await _repositry.deleteAddress(address.id);

      // 4) If the deleted address was selected, we must pick a new selected address
      // to avoid leaving the app and database in an invalid state.
      if (wasSelected) {
        // 4.a) Fetch the remaining addresses AFTER deletion (source of truth).
        final List<AddressModel> addresses = await _repositry
            .fetchUserAddress();

        // 4.b) If there are no addresses left, reset selection locally.
        if (addresses.isEmpty) {
          selectedAddress.value = AddressModel.empty();
        } else {
          // 4.c) Choose a fallback selected address (first remaining item).
          final AddressModel newSelected = addresses.first;

          // 4.d) Enforce invariant: only ONE address is selected in Firestore.
          // Unselect any other address that is currently marked selected.
          // (We exclude newSelected to avoid unnecessary updates.)
          for (final a in addresses) {
            if (a.selectedAddress == true && a.id != newSelected.id) {
              await _repositry.upadteSelectedField(a.id, false);
            }
          }

          // 4.e) Update local state first (so UI is consistent immediately).
          newSelected.selectedAddress = true;
          selectedAddress.value = newSelected;

          // 4.f) Persist the new selection in Firestore.
          await _repositry.upadteSelectedField(newSelected.id, true);
        }
      }

      // 5) Close the loader dialog.
      Get.back();

      // 6) Trigger UI refresh (your UI listens to refreshData).
      refreshData.toggle();

      // 7) Show success feedback to the user.
      USnackBarHelpers.successSnackBar(
        title: 'Deleted',
        message: 'Address deleted successfully.',
      );
    } catch (e) {
      // 8) Always close the loader if it's still open (avoid stuck UI).
      if (Get.isDialogOpen ?? false) Get.back();

      // 9) Show error feedback.
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
    }
  }

  //funcation to reset all fields of the form
  void resetFormField() {
    name.clear();
    phoneNumber.clear();
    street.clear();
    postalCode.clear();
    city.clear();
    state.clear();
    country.clear();
    addressFormKey.currentState!.reset();
  }
}
