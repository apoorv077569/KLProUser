import 'dart:developer';

import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/screens/app_pages_screens/payment_screen/layouts/payment_method_layout.dart';
import 'package:klpro_user/screens/app_pages_screens/payment_screen/layouts/wallet_option_selection.dart';
import 'package:klpro_user/users_services.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(builder: (context1, value, child) {
      log("kdsjhg");
      return StatefulWrapper(
          onInit: () => Future.delayed(Durations.short3)
              .then((_) => value.getUserDetail(context)),
          child: Scaffold(
              appBar: AppBarCommon(title: translations!.payment),
              body: Stack(alignment: Alignment.bottomCenter, children: [
                ListView(controller: value.scrollController, children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language(context, translations!.selectMethod),
                                style: appCss.dmDenseSemiBold14
                                    .textColor(appColor(context).lightText))
                            .paddingSymmetric(horizontal: Insets.i20),
                        const VSpace(Sizes.s5),
                        if (value.bookingId == 0)
                          if (userModel?.wallet != null &&
                              userModel!.wallet!.balance >
                                  (value.checkoutModel != null
                                      ? value.checkoutModel!.total!.total ?? 0.0
                                      : 0.0))
                            const WalletOptionSelection()
                                .paddingSymmetric(horizontal: Insets.i20),
                        ...value.paymentList
                            .where((element) => element.status == true)
                            .toList()
                            .asMap()
                            .entries
                            .map((e) => PaymentMethodLayout(
                                index: e.key,
                                data: e.value,
                                selectIndex: value.selectIndex,
                                onTap: () => value.onSelectPaymentMethod(
                                    e.key, e.value.slug)))
                      ]),
                  const VSpace(Sizes.s100)
                ]),
                SafeArea(
                  child: AnimatedBuilder(
                      animation: value.scrollController,
                      builder: (BuildContext context, Widget? child) {
                        return AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            height: 70,
                            child: child);
                      },
                      child: ButtonCommon(
                              isLoading: value.isPayment,
                              title: translations!.continues!,
                              margin: Sizes.s20,
                              onTap: () => value.addToCartOrBooking(context))
                          .paddingOnly(bottom: Insets.i20)
                          .backgroundColor(appColor(context).whiteBg)),
                )
              ])));
    });
  }
}
