// ignore_for_file: dead_code_on_catch_subtype
import 'package:ecommerce_app/data/repositories/user/user_repositry.dart';
import 'package:ecommerce_app/features/authentication/screens/login/login.dart';
import 'package:ecommerce_app/features/authentication/screens/onbording/onbording.dart';
import 'package:ecommerce_app/features/authentication/screens/signup/verify_email.dart';
import 'package:ecommerce_app/features/personalization/controllers/user_controller.dart';
import 'package:ecommerce_app/navigation_menu.dart';
import 'package:ecommerce_app/utlis/exceptions/firebase_auth_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/firebase_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/format_exceptions.dart';
import 'package:ecommerce_app/utlis/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepositry extends GetxController {
  static AuthenticationRepositry get instance => Get.find();

  final localStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  @override
  void onReady() {
    // remove the splash screen
    FlutterNativeSplash.remove();
    // redirect to the right screen
    screenRedirect();
  }

  Future<void> screenRedirect() async {
    final user = _auth.currentUser;
    //check if user verify
    if (user != null) {
      if (user.emailVerified) {
        //if verify go to navigation menu
        Get.offAll(() => NavigationMenu());
        //initialize user specific box
        await GetStorage.init(user.uid);
      } else {
        //if not verify go to verigu screen
        Get.offAll(() => VerifyEmailScreen(email: user.email));
      }
    } else {
      //write isFirstTime If null
      localStorage.writeIfNull("isFirstTime", true);
      //check if user first time
      localStorage.read("isFirstTime") != true
          ? Get.offAll(
              () => LoginScreen(),
            ) //if not first time go to login secrren
          : Get.offAll(
              () => OnbordingScreen(),
            ); //if first time go onbording secrren
    }
  }

  //[Authentication] with Email and Password
  Future<UserCredential> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }

  //[Authentication] SignIn
  Future<UserCredential> loginWithEmailAndPAssword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }

  //[Google_Authentication] Google_SignIn
  Future<UserCredential> signInWithGoogle() async {
    try {
      //show popup to select google account
      final GoogleSignInAccount? googleAccount = await GoogleSignIn().signIn();

      //get the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleAccount?.authentication;
      //create Credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );
      //Sign in using google credential
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }

  //[Email Verification]- Send Mail

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw UFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UFormatException();
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }
  //[Forget Password]- Send Mail To Rest Password

  Future<void> sendPasswordRestEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw UFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UFormatException();
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }
  //[Forget Password]- Send Mail To Rest Password

  Future<void> reAuthintcationUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw UFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UFormatException();
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Get.offAll(() => LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw UFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }

  Future<void> deleteAccount() async {
    try {
      final uid = currentUser!.uid;

      // 1) خذ publicId قبل أي حذف
      final publicId = UserController.instance.user.value.publicId;

      // 2) احذف الصورة من Cloudinary أولاً (مع await)
      if (publicId.isNotEmpty) {
        await UserRepositry.instance.deleteProfilePicture(publicId);
      }

      // 3) احذف سجل Firestore
      await UserRepositry.instance.removeUserRecord(uid);

      // 4) احذف حساب FirebaseAuth (مع await)
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      throw UFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw UFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UFormatException();
    } on PlatformException catch (e) {
      throw UPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong ,Please try again ';
    }
  }

  // //[Delete User]delete user account
  // Future<void> deleteAccount() async {
  //   try {
  //     await UserRepositry.instance.removeUserRecord(currentUser!.uid);
  //     //remove profile from cloudinary
  //     String publicId = UserController.instance.user.value.publicId;
  //     if (publicId.isNotEmpty) {
  //       await UserRepositry.instance.deleteProfilePicture(publicId);
  //     }
  //     await _auth.currentUser?.delete();
  //   } on FirebaseAuthException catch (e) {
  //     throw UFirebaseAuthException(e.code).message;
  //   } on FirebaseException catch (e) {
  //     throw UFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw UFormatException();
  //   } on PlatformException catch (e) {
  //     throw UPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong ,Please try again ';
  //   }
  // }
}
