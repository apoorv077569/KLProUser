import 'dart:developer';

import '../../../../config.dart';

class BillLayout extends StatelessWidget {
  const BillLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<CartProvider>(context, listen: true);

    if (value.checkoutModel?.services?.isNotEmpty == true) {
      log("Checkout Services count: ${value.checkoutModel?.services?.length}");
    }
    return value.checkoutModel != null
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: Insets.i20),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(isDark(context)
                        ? eImageAssets.pendingBillBgDark
                        : eImageAssets.pendingBillBg),
                    fit: BoxFit.fill)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    if (value.checkoutModel!.servicesPackage != null)
                      Column(
                        children: [
                          ...value.checkoutModel!.servicesPackage!
                              .asMap()
                              .entries
                              .map((e) => Column(
                                    children: e.value.services!
                                        .asMap()
                                        .entries
                                        .map((ser) {
                                      int total = getTotalRequiredServiceMan(
                                          value.cartList,
                                          ser.value.serviceId,
                                          true);
                                      return ser.value.total!.totalServicemen! >
                                              1
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                  Row(children: [
                                                    Text(
                                                        getName(
                                                            value.cartList,
                                                            ser.value.serviceId,
                                                            true),
                                                        style: appCss
                                                            .dmDenseMedium14
                                                            .textColor(appColor(
                                                                    context)
                                                                .lightText)),
                                                    const HSpace(Sizes.s5),
                                                    SvgPicture.asset(
                                                            eSvgAssets.about,
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            colorFilter:
                                                                ColorFilter.mode(
                                                                    appColor(
                                                                            context)
                                                                        .primary,
                                                                    BlendMode
                                                                        .srcIn))
                                                        .inkWell(
                                                            onTap: () => value
                                                                .onServiceDetail(
                                                                    context,
                                                                    packageServices:
                                                                        ser
                                                                            .value,
                                                                    totalServiceman:
                                                                        total))
                                                  ]),
                                                  Text(
                                                      "${getSymbol(context)}${(currency(context).currencyVal * ser.value.total!.subtotal!).toStringAsFixed(2)}",
                                                      style: appCss
                                                          .dmDenseMedium14
                                                          .textColor(
                                                              appColor(context)
                                                                  .darkText))
                                                ]).paddingOnly(
                                              bottom: Insets.i10,
                                              right: Insets.i15,
                                              left: Insets.i15)
                                          : BillRowCommon(
                                                  title: getName(
                                                      value.cartList,
                                                      ser.value.serviceId,
                                                      true),
                                                  color: appColor(context)
                                                      .darkText,
                                                  price: symbolPosition
                                                      ? "${getSymbol(context)}${(currency(context).currencyVal * ser.value.total!.subtotal!).toStringAsFixed(2)}"
                                                      : "${(currency(context).currencyVal * ser.value.total!.subtotal!).toStringAsFixed(2)}${getSymbol(context)}")
                                              .paddingOnly(bottom: Insets.i10);
                                    }).toList(),
                                  ))
                        ],
                      ),
                    if (value.cartList.isNotEmpty &&
                        value.checkoutModel?.services?.isNotEmpty == true)
                      Column(
                        children: value.cartList.asMap().entries.map((entry) {
                          int listIndex = entry.key;
                          var item = entry.value;
                          final service = item.serviceList;

                          // Find matching checkout data for this specific service
                          final checkoutData = value.checkoutModel?.services?.firstWhere(
                              (s) => s.serviceId == service?.id,
                              orElse: () => SingleServices());

                          final discount = service?.discount ?? 0;
                          final title = service?.title ?? "Service";
                          final isScheduled = checkoutData?.type == "scheduled";
                          final double scheduledPrice =
                              (checkoutData?.baseSubtotal ?? 0).toDouble();
                          final int serviceCount =
                              checkoutData?.scheduledServicesCount ?? 1;
                          final double servicePrice =
                              (service?.price ?? 0).toDouble();

                          // Use subtotal from checkout API if available, otherwise fallback to local calculation
                          final double displaySubtotal = checkoutData?.total?.subtotal ??
                              (isScheduled
                                  ? (scheduledPrice * serviceCount)
                                  : servicePrice);

                          final discountedAmount =
                              discount > 0 ? (servicePrice * discount / 100) : 0;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isScheduled
                                        ? "$title (${translations?.total} ${translations?.scheduledService} : ${checkoutData?.scheduledServicesCount})"
                                        : title,
                                    style: appCss.dmDenseMedium14
                                        .textColor(appColor(context).lightText),
                                  ).width(Sizes.s200),
                                  Text(
                                    symbolPosition
                                        ? "${getSymbol(context)}${displaySubtotal.toStringAsFixed(2)}"
                                        : "${displaySubtotal.toStringAsFixed(2)}${getSymbol(context)}",
                                    style: appCss.dmDenseMedium14
                                        .textColor(appColor(context).darkText),
                                  ),
                                ],
                              ).paddingOnly(
                                  bottom: Insets.i10,
                                  left: Insets.i15,
                                  right: Insets.i15),
                              if (discount > 0 && !isScheduled)
                                BillRowCommon(
                                  title: "Discount (${discount % 1 == 0 ? discount.toInt() : discount}%)",
                                  color: appColor(context).red,
                                  price: symbolPosition
                                      ? "-${getSymbol(context)}${discountedAmount.toStringAsFixed(2)}"
                                      : "-${discountedAmount.toStringAsFixed(2)}${getSymbol(context)}",
                                ).paddingOnly(bottom: Insets.i10),
                              if (isScheduled)
                                BillRowCommon(
                                  title: "${translations?.subtotal}",
                                  price: symbolPosition
                                      ? "${getSymbol(context)}${scheduledPrice.toStringAsFixed(2)}"
                                      : "${scheduledPrice.toStringAsFixed(2)}${getSymbol(context)}",
                                ).paddingOnly(bottom: Insets.i10),
                              // ✅ Add-On Display
                              if (service != null && service.selectedAdditionalServices != null &&
                                  service.selectedAdditionalServices!.isNotEmpty)
                                ...service.selectedAdditionalServices!.map((addon) {
                                  final addonTitle = addon.title ?? "Add-On";
                                  final addonPrice = addon.price ?? 0;
                                  final totalPrice = addonPrice * addon.qty;

                                  return BillRowCommon(
                                    title: addonTitle,
                                    color: appColor(context).green,
                                    price: symbolPosition
                                        ? "+${getSymbol(context)}${totalPrice.toStringAsFixed(2)}"
                                        : "+${totalPrice.toStringAsFixed(2)}${getSymbol(context)}",
                                  ).paddingOnly(bottom: Insets.i10);
                                }).toList(),
                              if (checkoutData?.taxes != null &&
                                  checkoutData!.taxes!.isNotEmpty)
                                ...checkoutData.taxes!.map((tax) {
                                  return BillRowCommon(
                                    title: "${translations!.tax} (${tax.rate ?? 0}%)",
                                    color: appColor(context).online,
                                    price:
                                        "+${getSymbol(context)}${(currency(context).currencyVal * (tax.amount ?? 0)).toStringAsFixed(2)}",
                                  ).paddingOnly(bottom: Insets.i10);
                                }).toList(),
                            ],
                          );
                        }).toList(),
                      ),
                    BillRowCommon(
                            title: translations!.platformFees,
                            color: appColor(context).online,
                            price: symbolPosition
                                ? "+${getSymbol(context)}${value.checkoutModel!.total!.platformFees != null ? (currency(context).currencyVal * value.checkoutModel!.total!.platformFees!).toStringAsFixed(2) : "0.00"}"
                                : "+${value.checkoutModel!.total!.platformFees != null ? (currency(context).currencyVal * value.checkoutModel!.total!.platformFees!).toStringAsFixed(2) : "0.00"}${getSymbol(context)}")
                        .paddingOnly(bottom: Insets.i10),
                    if (value.checkoutModel!.total!.couponTotalDiscount !=
                            null &&
                        value.checkoutModel!.total!.couponTotalDiscount! > 0)
                      // Display coupon discount only if it's greater than 0
                      BillRowCommon(
                              title: translations!.coupons,
                              color: appColor(context).red,
                              price: symbolPosition
                                  ? "-${getSymbol(context)}${(currency(context).currencyVal * value.checkoutModel!.total!.couponTotalDiscount!).toStringAsFixed(2)}"
                                  : "-${(currency(context).currencyVal * value.checkoutModel!.total!.couponTotalDiscount!).toStringAsFixed(2)}${getSymbol(context)}")
                          .paddingOnly(bottom: Insets.i10),
                  ]),
                  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        Text(language(context, translations!.totalAmount),
                            style: appCss.dmDenseMedium14
                                .textColor(appColor(context).darkText)),
                        Text(
                            symbolPosition
                                ? "${getSymbol(context)}${(currency(context).currencyVal * value.checkoutModel!.total!.total!).toStringAsFixed(2)}"
                                : "${(currency(context).currencyVal * value.checkoutModel!.total!.total!).toStringAsFixed(2)}${getSymbol(context)}",
                            style: appCss.dmDenseBold16
                                .textColor(appColor(context).primary))
                      ])
                      .paddingSymmetric(horizontal: Insets.i15)
                      .paddingOnly(bottom: Insets.i5, top: Insets.i10)
                ]))
        : Container();
  }
}
