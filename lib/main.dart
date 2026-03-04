import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';
import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/my_app.dart';
import 'package:ecommerce_app/utlis/constants/keys.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await GetStorage.init();
  Stripe.publishableKey = UKeys.stripePublishableKey;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) async {
    Get.put(AuthenticationRepositry());

    // ✅ INIT USER BOX (IMPORTANT)
    final user = AuthenticationRepositry.instance.currentUser;
    if (user != null) {
      await GetStorage.init(user.uid);
    }
  });

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}
