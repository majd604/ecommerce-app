// ignore_for_file: empty_catches, unnecessary_string_interpolations

import 'dart:async';

import 'package:ecommerce_app/common/widgets/screens/success_screen.dart';
import 'package:ecommerce_app/data/repositories/authentication_repositry.dart';
import 'package:ecommerce_app/utlis/constants/images.dart';
import 'package:ecommerce_app/utlis/constants/text.dart';
import 'package:ecommerce_app/utlis/popups/snackbar_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  Timer? _verifyTimer;
  Timer? _cooldownTimer;

  final RxBool isSending = false.obs;
  final RxInt cooldown = 0.obs;

  bool _sentOnceOnEnter = false;

  @override
  void onInit() {
    super.onInit();
    _startAutoRedirectTimer();

    // إرسال مرة واحدة فقط عند دخول الشاشة
    if (!_sentOnceOnEnter) {
      _sentOnceOnEnter = true;
      sendEmailVerification();
    }
  }

  @override
  void onClose() {
    _verifyTimer?.cancel();
    _cooldownTimer?.cancel();
    super.onClose();
  }

  void _startCooldown(int seconds) {
    cooldown.value = seconds;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (cooldown.value <= 1) {
        cooldown.value = 0;
        t.cancel();
      } else {
        cooldown.value--;
      }
    });
  }

  Future<void> sendEmailVerification() async {
    if (isSending.value) return;

    if (cooldown.value > 0) {
      USnackBarHelpers.warningSnackBar(
        title: 'Wait',
        message: 'Please wait ${cooldown.value}s before resending.',
      );
      return;
    }

    try {
      isSending.value = true;

      await AuthenticationRepositry.instance.sendEmailVerification();

      USnackBarHelpers.successSnackBar(
        title: 'Email Sent',
        message: 'Check Inbox / Spam / Promotions',
        duration: 5,
      );

      _startCooldown(60);
    } on FirebaseAuthException catch (e) {
      // في حال صار too-many-requests فعلاً (نادر بعد هالتعديل)
      if (e.code == 'too-many-requests') {
        USnackBarHelpers.warningSnackBar(
          title: 'Too Many Requests',
          message: 'Please wait a bit and try again.',
        );
        _startCooldown(60);
        return;
      }

      USnackBarHelpers.errorSnackBar(title: 'Error', message: '${e.code}');
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isSending.value = false;
    }
  }

  void _startAutoRedirectTimer() {
    _verifyTimer?.cancel();
    _verifyTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        await user.reload();
        final refreshed = FirebaseAuth.instance.currentUser;

        if (refreshed?.emailVerified == true) {
          timer.cancel();
          _goSuccess();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'network-request-failed') return;
      } catch (_) {}
    });
  }

  Future<void> checkEmailVerificationState() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await user.reload();
      final refreshed = FirebaseAuth.instance.currentUser;

      if (refreshed?.emailVerified == true) {
        _verifyTimer?.cancel();
        _goSuccess();
      } else {
        USnackBarHelpers.warningSnackBar(
          title: 'Not Verified Yet',
          message:
              'Open the email, click the link, then come back and press Continue.',
        );
      }
    } catch (e) {}
  }

  void _goSuccess() {
    Get.offAll(
      () => SuccessScreen(
        title: UItext.accountCreatedTitle,
        image: UImages.successfulPaymentIcon,
        subTitle: UItext.accountCreatedSubTitle,
        ontap: AuthenticationRepositry.instance.screenRedirect,
      ),
    );
  }
}
