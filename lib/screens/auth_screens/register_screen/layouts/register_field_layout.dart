import 'package:flutter_svg/svg.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/screens/auth_screens/change_password_screen/layouts/terms_layout.dart' hide TermsLayout;
import 'package:klpro_user/screens/auth_screens/register_screen/layouts/register_widget_class.dart';
import 'package:provider/provider.dart';

import '../../../../config.dart';

class RegisterFieldLayout extends StatelessWidget {
  final BuildContext? buildContext;

  const RegisterFieldLayout({super.key, this.buildContext});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
        builder: (registerContext, register, child) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContainerWithTextLayout(title: translations!.userName),
            const VSpace(Sizes.s8),
            TextFieldCommon(
                    controller: register.txtName,
                    hintText: translations!.enterName!,
                    focusNode: register.nameFocus,
                    onFieldSubmitted: (value) => validation.fieldFocusChange(
                        context, register.nameFocus, register.emailFocus),
                    prefixIcon: eSvgAssets.user,
                    validator: (value) =>
                        validation.nameValidation(context, value))
                .paddingSymmetric(horizontal: Insets.i20),
            const VSpace(Sizes.s15),
            ContainerWithTextLayout(
                title: language(context, translations!.email)),
            const VSpace(Sizes.s8),
            TextFieldCommon(
                    isEnable: !register.isEmailVerified,
                    controller: register.txtEmail,
                    hintText: language(context, translations!.enterEmail),
                    focusNode: register.emailFocus,
                    onFieldSubmitted: (value) => validation.fieldFocusChange(
                        context, register.emailFocus, register.phoneFocus),
                    prefixIcon: eSvgAssets.email,
                    suffixIcon: register.isEmailVerified
                        ? Icon(Icons.check_circle,
                                color: appColor(context).greenColor)
                            .paddingAll(Insets.i12)
                        : Container(
                            margin: const EdgeInsets.all(Sizes.s6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: Insets.i12, vertical: Insets.i6),
                            decoration: BoxDecoration(
                                color: appColor(context).primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppRadius.r6),
                                border: Border.all(
                                    color:
                                        appColor(context).primary.withOpacity(0.2))),
                            child: Text(language(context, "Verify"),
                                style: appCss.dmDenseMedium12
                                    .textColor(appColor(context).primary)),
                          ).inkWell(onTap: () => register.sendOtp(context)),
                    validator: (value) =>
                        validation.emailValidation(context, value))
                .paddingSymmetric(horizontal: Insets.i20),
            const VSpace(Sizes.s15),
            ContainerWithTextLayout(
                title: language(context, translations!.phoneNo)),
            const VSpace(Sizes.s10),
            RegisterWidgetClass().phoneTextBox(
                context, register.txtPhone, register.phoneFocus,
                dialCode: "+${appSettingModel?.general?.countryCode ?? 1}",
                onChanged: (CountryCodeCustom? code) =>
                    register.changeDialCode(code!),
                onFieldSubmitted: (value) => validation.fieldFocusChange(
                    context, register.phoneFocus, register.passwordFocus)),
            const VSpace(Sizes.s15),
            ContainerWithTextLayout(
                title: language(context, translations!.password)),
            const VSpace(Sizes.s8),
            TextFieldCommon(
                    obscureText: register.isNewPassword,
                    controller: register.txtPass,
                    hintText: language(context, translations!.enterPassword),
                    focusNode: register.passwordFocus,
                    prefixIcon: eSvgAssets.lock,
                    suffixIcon: SvgPicture.asset(
                            register.isNewPassword
                                ? eSvgAssets.hide
                                : eSvgAssets.eye,
                            fit: BoxFit.scaleDown)
                        .inkWell(onTap: () => register.newPasswordSeenTap()),
                    validator: (value) =>
                        validation.passValidation(context, value))
                .paddingSymmetric(horizontal: Insets.i20),
            const VSpace(Sizes.s15),
            ContainerWithTextLayout(title: translations!.confirmPassword),
            const VSpace(Sizes.s8),
            TextFieldCommon(
                hintText: translations!.enterConfirmPassword!,
                obscureText: register.isConfirmPassword,
                controller: register.txtConfirmPass,
                focusNode: register.confirmPasswordFocus,
                suffixIcon: SvgPicture.asset(
                        register.isConfirmPassword
                            ? eSvgAssets.hide
                            : eSvgAssets.eye,
                        fit: BoxFit.scaleDown)
                    .inkWell(onTap: () => register.confirmPasswordSeenTap()),
                prefixIcon: eSvgAssets.lock,
                validator: (value) => validation.confirmPassValidation(
                    context, value, register.txtPass.text)).paddingSymmetric(
                horizontal: Insets.i20),
            const VSpace(Sizes.s15),
            ContainerWithTextLayout(
                title:
                    "${translations!.referralCode ?? 'Referral Code'} (${translations!.optional ?? 'Optional'})"),
            const VSpace(Sizes.s8),
            TextFieldCommon(
              controller: register.refCode,
              hintText: translations!.enterReferralCode ??
                  "", // translations!.enterRefCode!,
              focusNode: register.referCodeFocus,
              prefixIcon: eSvgAssets.discount,
            ).paddingSymmetric(horizontal: Insets.i20), //translations!.refCode
            const VSpace(Sizes.s8),
            const TermsLayout(),
            const VSpace(Sizes.s35),
            ButtonCommon(
                    title: translations!.signUp!,
                    onTap: () => register.signUp(buildContext!))
                .paddingSymmetric(horizontal: Insets.i20),
            const VSpace(Sizes.s15),
            RegisterWidgetClass().notMember(context)
          ]).paddingSymmetric(vertical: Insets.i20);
    });
  }
}
