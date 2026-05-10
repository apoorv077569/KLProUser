import 'dart:convert';
import 'dart:developer';

import 'package:klpro_user/config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RegisterProvider extends ChangeNotifier {
  bool isNewPassword = true, isConfirmPassword = true, isCheck = false;
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  String dialCode = "+${appSettingModel?.general?.countryCode ?? 1}";
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  TextEditingController refCode = TextEditingController();
  TextEditingController txtConfirmPass = TextEditingController();
  bool isEmailVerified = false;
  String? verifiedOtp;

  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();
  final FocusNode referCodeFocus = FocusNode();

  //new password see tap
  newPasswordSeenTap() {
    isNewPassword = !isNewPassword;
    notifyListeners();
  }

  //confirm password see tap
  confirmPasswordSeenTap() {
    isConfirmPassword = !isConfirmPassword;
    notifyListeners();
  }

  // signUp(context) async {
  //   FocusManager.instance.primaryFocus?.unfocus();
  //   if (isCheck == false) {
  //     Fluttertoast.showToast(
  //         msg: language(context, translations!.pleaseCheckTerms));
  //   } else if (!isEmailVerified) {
  //     Fluttertoast.showToast(msg: language(context, "Please verify your email"));
  //   } else if (registerFormKey.currentState!.validate() && isCheck == true) {
  //     showLoading(context);
  //     notifyListeners();
  //     String token = await getFcmToken();
  //     var body = {
  //       "name": txtName.text,
  //       "email": txtEmail.text,
  //       "phone": txtPhone.text,
  //       "code": dialCode,
  //       "password": txtPass.text,
  //       "password_confirmation": txtPass.text,
  //       "fcm_token": token,
  //       "referral_code": refCode.text,
  //       "otp": verifiedOtp
  //     };

  //     log("body : $body");

  //     try {
  //       await apiServices
  //           .postApi(api.register, jsonEncode(body))
  //           .then((value) async {
  //         hideLoading(context);
  //         notifyListeners();
  //         if (value.isSuccess!) {
  //           final commonApi =
  //               Provider.of<CommonApiProvider>(context, listen: false);
  //           await commonApi.selfApi(context);
  //           txtName.text = "";
  //           txtEmail.text = "";
  //           txtPhone.text = "";
  //           dialCode = "+${appSettingModel?.general?.countryCode ?? 1}";
  //           txtPass.text = "";
  //           txtConfirmPass.text = "";
  //           isEmailVerified = false;
  //           verifiedOtp = null;
  //           notifyListeners();

  //           Fluttertoast.showToast(
  //               msg: "You Are Register Successfully",
  //               backgroundColor: appColor(context).primary);
  //           /*   final commonApiProvider =
  //               Provider.of<CommonApiProvider>(context, listen: false);
  //           commonApiProvider.selfApi(context); */
  //           route.pushReplacementNamed(context, routeName.login);
  //           /*  route.pop(context); */
  //         } else {
  //           Fluttertoast.showToast(
  //               msg: value.message, backgroundColor: appColor(context).red);
  //         }
  //       });
  //     } catch (e) {
  //       hideLoading(context);
  //       Fluttertoast.showToast(
  //           msg: e.toString(), backgroundColor: appColor(context).red);
  //       notifyListeners();
  //       log("CATCH signUp: $e");
  //     }
  //   }
  // }

  signUp(context) async {
  FocusManager.instance.primaryFocus?.unfocus();

  if (isCheck == false) {
    Fluttertoast.showToast(
      msg: language(
        context,
        translations!.pleaseCheckTerms,
      ),
    );
    return;
  }

  if (!isEmailVerified) {
    Fluttertoast.showToast(
      msg: "Please verify your email",
    );
    return;
  }

  if (!registerFormKey.currentState!.validate()) {
    return;
  }

  showLoading(context);
  notifyListeners();

  try {
    String token = await getFcmToken();

    var body = {
      "name": txtName.text.trim(),
      "email": txtEmail.text.trim(),
      "phone": txtPhone.text.trim(),
      "code": dialCode,
      "password": txtPass.text.trim(),
      "password_confirmation": txtPass.text.trim(),
      "fcm_token": token,
      "referral_code": refCode.text.trim(),
      "otp": verifiedOtp
    };

    /// REQUEST PRINT
    print("========== SIGNUP REQUEST ==========");
    print(jsonEncode(body));
    print("===================================");

    final value = await apiServices.postApi(
      api.register,
      jsonEncode(body),
    );

    /// RESPONSE PRINT
    print("========== SIGNUP RESPONSE ==========");
    print(value.toString());
    print("isSuccess : ${value.isSuccess}");
    print("message : ${value.message}");
    print("====================================");

    hideLoading(context);
    notifyListeners();

    if (value.isSuccess!) {
      final commonApi =
          Provider.of<CommonApiProvider>(
        context,
        listen: false,
      );

      await commonApi.selfApi(context);

      txtName.clear();
      txtEmail.clear();
      txtPhone.clear();
      txtPass.clear();
      txtConfirmPass.clear();
      refCode.clear();

      dialCode =
          "+${appSettingModel?.general?.countryCode ?? 1}";

      isEmailVerified = false;
      verifiedOtp = null;

      notifyListeners();

      Fluttertoast.showToast(
        msg: "You Are Register Successfully",
        backgroundColor:
            appColor(context).primary,
      );

      route.pushReplacementNamed(
        context,
        routeName.login,
      );
    } else {
      Fluttertoast.showToast(
        msg: value.message ?? "Registration Failed",
        backgroundColor:
            appColor(context).red,
      );
    }
  } catch (e) {
    hideLoading(context);
    notifyListeners();

    print("========== SIGNUP ERROR ==========");
    print(e.toString());
    print("=================================");

    Fluttertoast.showToast(
      msg: e.toString(),
      backgroundColor: appColor(context).red,
    );
  }
}

  isCheckBoxCheck(value) {
    isCheck = value;
    notifyListeners();
  }

  onBack() {
    txtName.text = "";
    txtEmail.text = "";
    txtPhone.text = "";
    dialCode = "+${appSettingModel?.general?.countryCode ?? 1}";
    txtPass.text = "";
    txtConfirmPass.text = "";
    isEmailVerified = false;
    verifiedOtp = null;
    notifyListeners();
  }

  changeDialCode(CountryCodeCustom country) {
    dialCode = country.dialCode!;
    notifyListeners();
  }

  // sendOtp(context) async {
  //   if (txtEmail.text.isNotEmpty &&
  //       validation.emailValidation(context, txtEmail.text) == null) {
  //     showLoading(context);
  //     notifyListeners();
  //     try {
  //       var body = {"email": txtEmail.text};
  //       await apiServices
  //           .postApi(api.sendRegisterOtp, jsonEncode(body))
  //           .then((value) {
  //         hideLoading(context);
  //         if (value.isSuccess!) {
  //           route.pushNamed(context, routeName.verifyOtp, arg: {
  //             "email": txtEmail.text,
  //             "type": "register",
  //           });
  //         } else {
  //           Fluttertoast.showToast(
  //               msg: value.message, backgroundColor: appColor(context).red);
  //         }
  //       });
  //     } catch (e) {
  //       hideLoading(context);
  //       log("CATCH sendOtp: $e");
  //     }
  //   } else {
  //     Fluttertoast.showToast(msg: "Please enter a valid email");
  //   }
  // }

  sendOtp(context) async {
  if (txtEmail.text.isNotEmpty &&
      validation.emailValidation(
            context,
            txtEmail.text,
          ) ==
          null) {
    showLoading(context);
    notifyListeners();

    try {
      var body = {
        "email": txtEmail.text.trim(),
      };

      /// REQUEST PRINT
       log("========== SEND OTP REQUEST ==========", name: "SEND_OTP");
      log("API URL => ${api.sendRegisterOtp}", name: "SEND_OTP");
      log("REQUEST BODY => ${jsonEncode(body)}", name: "SEND_OTP");
      log("=====================================", name: "SEND_OTP");

      final value = await apiServices.postApi(
        api.sendRegisterOtp,
        jsonEncode(body),
      );

      /// RESPONSE PRINT
       log("========== SEND OTP RESPONSE ==========", name: "SEND_OTP");
      log("RESPONSE => ${value.toString()}", name: "SEND_OTP");
      log("STATUS => ${value.isSuccess}", name: "SEND_OTP");
      log("MESSAGE => ${value.message}", name: "SEND_OTP");
      log("======================================", name: "SEND_OTP");

      hideLoading(context);

      if (value.isSuccess!) {
        route.pushNamed(
          context,
          routeName.verifyOtp,
          arg: {
            "email": txtEmail.text,
            "type": "register",
          },
        );
      } else {
        Fluttertoast.showToast(
          msg: value.message,
          backgroundColor: appColor(context).red,
        );
      }
    } catch (e) {
      hideLoading(context);

      /// ERROR PRINT
      log("========== SEND OTP ERROR ==========", name: "SEND_OTP");
      log("ERROR => ${e.toString()}", name: "SEND_OTP");
      log("===================================", name: "SEND_OTP");

      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: appColor(context).red,
      );
    }
  } else {
    Fluttertoast.showToast(
      msg: "Please enter a valid email",
    );
  }
}

  setEmailVerified(bool value, {String? otp}) {
    isEmailVerified = value;
    verifiedOtp = otp;
    notifyListeners();
  }
}
