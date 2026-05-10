import 'package:klpro_user/screens/app_pages_screens/pending_booking_screen/layouts/payment_status_summary.dart';
import 'package:klpro_user/screens/bottom_screens/booking_screen/booking_shimmer/booking_detail_shimmer.dart';
import 'package:provider/provider.dart';
import '../../../common_tap.dart';
import '../../../config.dart';

class PendingBookingScreen extends StatelessWidget {
  const PendingBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PendingBookingProvider>(builder: (context1, value, child) {
      return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            value.onBack(context, false);
            if (didPop) return;
          },
          child: StatefulWrapper(
              onInit: () => value.onReady(context),
              child: Scaffold(
                  appBar: AppBarCommon(
                    title: translations?.pendingBooking ?? "Pending Booking",
                    onTap: () => value.onBack(context, true),
                  ),
                  body: SafeArea(
                      child: value.isLoading || value.booking == null
                          ? const BookingDetailShimmer()
                          : ListView(children: [
                              RefreshIndicator(
                                  onRefresh: () => value.onRefresh(context),
                                  child: SingleChildScrollView(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        StatusDetailLayout(
                                          data: value.booking,
                                          onTapStatus: () => showBookingStatus(
                                              context, value.booking),
                                        ),
                                        Text(
                                          language(context,
                                              translations?.billSummary ?? "Bill Summary"),
                                          style: appCss.dmDenseSemiBold14
                                              .textColor(
                                                  appColor(context).darkText),
                                        ).paddingOnly(
                                            top: Insets.i15,
                                            bottom: Insets.i10),
                                        Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(isDark(
                                                            context)
                                                        ? eImageAssets
                                                            .pendingBillBgDark
                                                        : eImageAssets
                                                            .pendingBillBg),
                                                    fit: BoxFit.fill)),
                                            child: Column(children: [
                                              BillRowCommon(
                                                      title:
                                                          "${translations?.service ?? "Service"}",
                                                      price: symbolPosition
                                                          ? "${getSymbol(context)}${(value.booking?.service?.price ?? 0).toStringAsFixed(2)}"
                                                          : "${(value.booking?.service?.price ?? 0).toStringAsFixed(2)}${getSymbol(context)}",
                                                      style: appCss
                                                          .dmDenseBold14
                                                          .textColor(
                                                              appColor(context)
                                                                  .darkText))
                                                  .padding(bottom: Insets.i10),
                                              if (value.booking?.service
                                                          ?.discount !=
                                                      null &&
                                                  value.booking?.service
                                                          ?.discount !=
                                                      0)
                                                BillRowCommon(
                                                        color: appColor(context)
                                                            .red,
                                                        title:
                                                            "${translations?.appliedDiscount ?? "Applied Discount"} (${value.booking?.service?.discountDisplay ?? ''}%)",
                                                        price: symbolPosition
                                                            ? "-${getSymbol(context)}${value.booking?.service?.discountAmount ?? 0}"
                                                            : "-${value.booking?.service?.discountAmount ?? 0}${getSymbol(context)}")
                                                    .marginOnly(
                                                        bottom: Insets.i10),
                                              if (value.booking?.couponTotalDiscount !=
                                                      null &&
                                                  value.booking?.couponTotalDiscount !=
                                                      0.0)
                                                BillRowCommon(
                                                        color: appColor(context)
                                                            .red,
                                                        title:
                                                            "${translations?.couponDiscount ?? "Coupon Discount"} ",
                                                        price: symbolPosition
                                                            ? "-${getSymbol(context)}${value.booking?.couponTotalDiscount?.toString() ?? "0"}"
                                                            : "-${value.booking?.couponTotalDiscount?.toString() ?? "0"}${getSymbol(context)}")
                                                    .marginOnly(
                                                        bottom: Insets.i10),
                                              BillRowCommon(
                                                      title: symbolPosition
                                                          ? "${(value.booking?.requiredServicemen ?? 0) + (value.booking?.totalExtraServicemen ?? 0)} ${language(context, translations?.serviceman ?? "Serviceman")} (${getSymbol(context)}${value.booking?.perServicemanCharge ?? 0} × ${(value.booking?.requiredServicemen ?? 0) + (value.booking?.totalExtraServicemen ?? 0)})"
                                                          : "${(value.booking?.requiredServicemen ?? 0) + (value.booking?.totalExtraServicemen ?? 0)} ${language(context, translations?.serviceman ?? "Serviceman")} (${value.booking?.perServicemanCharge ?? 0}${getSymbol(context)} × ${(value.booking?.requiredServicemen ?? 0) + (value.booking?.totalExtraServicemen ?? 0)})",
                                                      price: symbolPosition
                                                          ? "${getSymbol(context)}${(value.booking?.totalExtraServicemenCharge ?? 0).toStringAsFixed(2)}"
                                                          : "${(value.booking?.totalExtraServicemenCharge ?? 0).toStringAsFixed(2)}${getSymbol(context)}",
                                                      style: appCss
                                                          .dmDenseBold14
                                                          .textColor(
                                                              appColor(context)
                                                                  .darkText))
                                                  .padding(bottom: Insets.i10),
                                              if (value.booking?.additionalServices?.isNotEmpty ?? false)
                                                ...value.booking!.additionalServices!
                                                    .map((charge) {
                                                  return BillRowCommon(
                                                          title: charge.title ?? "Additional Service",
                                                          /* "${charge.title ?? "Additional Service"} (\$${charge.price ?? 0} × ${charge.qty ?? 0})", */
                                                          color:
                                                              appColor(context)
                                                                  .green,
                                                          price: symbolPosition
                                                              ? "+${getSymbol(context)}${(charge.totalPrice ?? 0).toStringAsFixed(2)}"
                                                              : "+${(charge.totalPrice ?? 0).toStringAsFixed(2)}${getSymbol(context)}")
                                                      .padding(
                                                          bottom: Insets.i10);
                                                }),
                                              BillRowCommon(
                                                title:
                                                    translations?.platformFees ?? "Platform Fees",
                                                price: symbolPosition
                                                    ? "+${getSymbol(context)}${(currency(context).currencyVal * (value.booking?.platformFees ?? 0.0)).toStringAsFixed(2)}"
                                                    : "+${(currency(context).currencyVal * (value.booking?.platformFees ?? 0.0)).toStringAsFixed(2)}${getSymbol(context)}",
                                                color: appColor(context).online,
                                              ).padding(bottom: Insets.i10),
                                              if (value.booking?.taxes?.isNotEmpty ?? false)
                                                ...value.booking!.taxes!
                                                    .map((tax) {
                                                  double rate = tax.rate ?? 0;
 
                                                  return BillRowCommon(
                                                          title:
                                                              "${translations?.tax ?? "Tax"} (${tax.name ?? ""} ${rate.toStringAsFixed(0)}%)",
                                                          price: symbolPosition
                                                              ? "+${getSymbol(context)}${tax.amount ?? 0}"
                                                              : "+${tax.amount ?? 0}${getSymbol(context)}",
                                                          color:
                                                              appColor(context)
                                                                  .online)
                                                      .paddingOnly(
                                                          bottom: Insets.i10);
                                                }),
                                              if (value.booking?.taxes?.isNotEmpty ?? false)
                                                const VSpace(Sizes.s20),
                                              BillRowCommon(
                                                  title:
                                                      translations?.totalAmount ?? "Total Amount",
                                                  price: symbolPosition
                                                      ? "${getSymbol(context)}${(currency(context).currencyVal * (value.booking?.total ?? 0.0)).toStringAsFixed(2)}"
                                                      : "${(currency(context).currencyVal * (value.booking?.total ?? 0.0)).toStringAsFixed(2)}${getSymbol(context)}",
                                                  styleTitle: appCss
                                                      .dmDenseMedium14
                                                      .textColor(
                                                          appColor(context)
                                                              .darkText),
                                                  style: appCss.dmDenseBold16
                                                      .textColor(
                                                          appColor(context)
                                                              .primary))
                                            ]).paddingSymmetric(
                                                vertical: Insets.i20)),
                                        if (value.booking?.advancePaymentEnable == true)
                                          PaymentSummaryWidget(
                                            booking: value.booking!,
                                          ),
                                        if (value.booking?.bookingStatus != null && value.booking?.bookingStatus?.slug != translations?.cancel && value.booking?.dateTime != null && value.checkForCancelButtonShow())
                                          ButtonCommon(
                                                  title: translations?.cancelBooking ?? "Cancel Booking",
                                                  onTap: value.isUpdateCancel
                                                      ? () {}
                                                      : () => value.onCancelBooking(context))
                                               .paddingOnly(
                                                   top: Insets.i35,
                                                   bottom: Insets.i30),
                                        if (value.booking?.dateTime != null &&
                                            !value.checkForCancelButtonShow())
                                          SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            language(context,
                                                                "${translations?.status ?? "Status"}:"),
                                                            style: appCss
                                                                .dmDenseMedium14
                                                                .textColor(appColor(
                                                                        context)
                                                                    .red)),
                                                        const HSpace(Sizes.s10),
                                                        Expanded(
                                                            child: Text(
                                                                language(
                                                                    context,
                                                                    "You can’t cancel this booking short time before it starts."),
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                style: appCss
                                                                    .dmDenseRegular14
                                                                    .textColor(
                                                                        appColor(context)
                                                                            .red)))
                                                      ]).paddingAll(Insets.i15))
                                              .boxShapeExtension(
                                                  color: appColor(context)
                                                      .red
                                                      .withOpacity(0.1))
                                              .paddingDirectional(
                                                  vertical: Sizes.s20)
                                      ]).paddingOnly(
                                          left: Insets.i20, right: Insets.i20)))
                            ])))));
    });
  }
}
