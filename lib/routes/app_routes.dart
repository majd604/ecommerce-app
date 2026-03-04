import 'package:ecommerce_app/features/authentication/screens/onbording/onbording.dart';
import 'package:ecommerce_app/features/authentication/screens/signup/sign_up.dart';
import 'package:ecommerce_app/features/personalization/screens/address/address.dart';
import 'package:ecommerce_app/features/personalization/screens/edit_profile/edit_profile.dart';
import 'package:ecommerce_app/features/personalization/screens/profile/profile.dart';
import 'package:ecommerce_app/features/shop/secreens/cart/cart.dart';
import 'package:ecommerce_app/features/shop/secreens/check_out/check_out.dart';
import 'package:ecommerce_app/features/shop/secreens/order/order.dart';
import 'package:ecommerce_app/features/shop/secreens/store/store.dart';
import 'package:ecommerce_app/features/shop/secreens/whishList/wish_list.dart';
import 'package:ecommerce_app/navigation_menu.dart';
import 'package:ecommerce_app/routes/routes.dart';
import 'package:get/get.dart';
import '../features/authentication/screens/forget_password/forget_password.dart';
import '../features/authentication/screens/login/login.dart';
import '../features/authentication/screens/signup/verify_email.dart';

class UAppRoutes {
  static final screens = [
    GetPage(name: URoutes.home, page: () => const NavigationMenu()),
    GetPage(name: URoutes.store, page: () => const StoreScreen()),
    GetPage(name: URoutes.wishlist, page: () => const WishListScreen()),
    GetPage(name: URoutes.profile, page: () => const ProfileScreen()),
    GetPage(name: URoutes.order, page: () => const OrderScreen()),
    GetPage(name: URoutes.checkout, page: () => const CheckOutScreen()),
    GetPage(name: URoutes.cart, page: () => const CartScreen()),
    GetPage(name: URoutes.editProfile, page: () => const EditProfileScreen()),
    GetPage(name: URoutes.userAddress, page: () => const AddressSecreen()),
    GetPage(name: URoutes.signup, page: () => const SignUpScreen()),
    GetPage(name: URoutes.verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(name: URoutes.login, page: () => const LoginScreen()),
    // GetPage(
    //   name: URoutes.productDetail,
    //   page: () => const ProdectDetailsScreen(),
    // ),
    GetPage(
      name: URoutes.forgetPassword,
      page: () => const ForgetPasswordScreen(),
    ),
    GetPage(name: URoutes.onBoarding, page: () => const OnbordingScreen()),
  ];
}
