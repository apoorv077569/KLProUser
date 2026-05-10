import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/common_tap.dart';
import 'package:klpro_user/screens/app_pages_screens/pending_booking_screen/layouts/payment_status_summary.dart';
import 'package:klpro_user/screens/app_pages_screens/slot_booking_screen/layouts/bill_row_common.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';
import '../../bottom_screens/booking_screen/booking_shimmer/booking_detail_shimmer.dart';

class AcceptedBookingScreen extends StatelessWidget {
  const AcceptedBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AcceptedBookingProvider, PendingBookingProvider>(
        builder: (context, val, val2, child) {
      final price = val.booking?.service?.price ?? 0.0;
      final requiredServicemen = val.booking?.service?.requiredServicemen ?? 1;
      final selectedRequiredServiceMan =
          val.booking?.service?.selectedRequiredServiceMan ?? 1;
      final serviceRate = val.booking?.service?.serviceRate ?? 0.0;

      final currencyVal = currency(context).currencyVal;

      double totalPrice = (currencyVal *
          ((price / requiredServicemen) * selectedRequiredServiceMan));
      double baseRate =
          (currencyVal * (serviceRate * selectedRequiredServiceMan));
      double difference = totalPrice - baseRate;

      String formattedDifference = symbolPosition
          ? "-${getSymbol(context)}${difference.toStringAsFixed(2)}"
          : "-${difference.toStringAsFixed(2)}${getSymbol(context)}";
      return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            val.onBack(context, false);
            if (didPop) return;
          },
          child: StatefulWrapper(
              onInit: () => Future.delayed(const Duration(milliseconds: 150),
                  () => val.onReady(context)),
              child: val.isLoading || val.booking == null
                  ? const BookingDetailShimmer().padding(top: Sizes.s40)
                  : Scaffold(
                      appBar: AppBarCommon(
                          title: val.booking?.bookingStatus?.slug == "assigned"
                              ? translations?.assignBooking ??
                                  appFonts.assignedBooking
                              : translations?.acceptedBookings ?? "Accepted Booking",
                          onTap: () => val.onBack(context, true)),
                      body: SizedBox.expand(
                          child: Stack(children: [
                        RefreshIndicator(
                          onRefresh: () async {
                            val.onRefresh(context);
                          },
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                StatusDetailLayout(
                                    data: val.booking,
                                    onTapStatus: () => showBookingStatus(
                                        context, val.booking)),
                                Text(
                                        language(
                                            context, translations?.billSummary ?? "Bill Summary"),
                                        style: appCss.dmDenseSemiBold14
                                            .textColor(
                                                appColor(context).darkText))
                                    .paddingOnly(
                                        top: Insets.i25, bottom: Insets.i10),
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(isDark(context)
                                              ? eImageAssets.pendingBillBgDark
                                              : eImageAssets.pendingBillBg),
                                          fit: BoxFit.fill)),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            BillRowCommon(
                                              title: translations?.service ?? "Service",
                                              price: symbolPosition
                                                  ? "${getSymbol(context)}${(val.booking?.service?.price ?? 0)}"
                                                  : "${((val.booking?.service?.price ?? 0)).toStringAsFixed(2)}${getSymbol(context)}",
                                            ).marginOnly(bottom: Insets.i20),
                                            if (val.booking?.service
                                                        ?.discount !=
                                                    null &&
                                                val.booking?.service
                                                        ?.discount !=
                                                    0)
                                              BillRowCommon(
                                                      color:
                                                          appColor(context).red,
                                                      title:
                                                          "${translations?.appliedDiscount ?? "Applied Discount"} (${val.booking?.service?.discountDisplay ?? ''}%)",
                                                      price:
                                                          formattedDifference)
                                                  .marginOnly(
                                                      bottom: Insets.i20),
                                            BillRowCommon(
                                                    title:
                                                        "${(val.booking?.requiredServicemen ?? 0) + (val.booking?.totalExtraServicemen ?? 0)} ${language(context, translations?.serviceman ?? "Serviceman")} (${getSymbol(context)}${((val.booking?.perServicemanCharge ?? 0))} × ${(val.booking?.requiredServicemen ?? 0) + (val.booking?.totalExtraServicemen ?? 0)})",
                                                    price: symbolPosition
                                                        ? "${getSymbol(context)}${(val.booking?.totalExtraServicemenCharge ?? 0)}"
                                                        : "${(val.booking?.totalExtraServicemenCharge ?? 0)}${getSymbol(context)}",
                                                    style: appCss.dmDenseBold14
                                                        .textColor(
                                                            appColor(context)
                                                                .darkText))
                                                .marginOnly(bottom: Insets.i20),
                                            if (val.booking?.additionalServices !=
                                                null)
                                              ...val.booking!.additionalServices!
                                                  .map((charge) {
                                                return BillRowCommon(
                                                  title:
                                                      "${charge.title} (\$${charge.price} × ${charge.qty})",
                                                  color:
                                                      appColor(context).green,
                                                  price: symbolPosition
                                                      ? "+${getSymbol(context)}${charge.totalPrice?.toStringAsFixed(2) ?? "0.00"}"
                                                      : "+${charge.totalPrice?.toStringAsFixed(2) ?? "0.00"}${getSymbol(context)}",
                                                ).padding(bottom: Insets.i20);
                                              }),
                                            BillRowCommon(
                                                    title: translations?.platformFees ?? "Platform Fees",
                                                    price: symbolPosition
                                                        ? "+${getSymbol(context)}${(currency(context).currencyVal * (val.booking?.platformFees ?? 0.0)).toStringAsFixed(2)}"
                                                        : "+${(currency(context).currencyVal * (val.booking?.platformFees ?? 0.0)).toStringAsFixed(2)}${getSymbol(context)}",
                                                    color: appColor(context)
                                                        .online)
                                                .padding(bottom: Insets.i20),
                                            if (val.booking?.taxes != null &&
                                                val.booking!.taxes!.isNotEmpty)
                                              ...val.booking!.taxes!.map((tax) {
                                                double rate = tax.rate ?? 0;

                                                return BillRowCommon(
                                                  title:
                                                      "${translations?.tax ?? "Tax"} (${tax.name ?? ""} ${rate.toStringAsFixed(0)}%)",
                                                  price:
                                                      "+${getSymbol(context)}${tax.amount ?? 0}",
                                                  color:
                                                      appColor(context).online,
                                                ).paddingOnly(
                                                    bottom: Insets.i10);
                                              }),
                                            if (val.booking?.taxes != null &&
                                                val.booking!.taxes!.isNotEmpty)
                                              const VSpace(Sizes.s20),
                                          ],
                                        ),
                                        const VSpace(Sizes.s15),
                                        BillRowCommon(
                                                title:
                                                    translations?.totalAmount ?? "Total Amount",
                                                price: symbolPosition
                                                    ? "${getSymbol(context)}${(currency(context).currencyVal * (val.booking?.total ?? 0.0)).toStringAsFixed(2)}"
                                                    : "${(currency(context).currencyVal * (val.booking?.total ?? 0.0)).toStringAsFixed(2)}${getSymbol(context)}",
                                                styleTitle: appCss
                                                    .dmDenseMedium14
                                                    .textColor(appColor(context)
                                                        .darkText),
                                                style: appCss.dmDenseBold16
                                                    .textColor(appColor(context)
                                                        .primary))
                                            .paddingOnly(top: Insets.i10)
                                      ]).paddingSymmetric(vertical: Insets.i20),
                                ),
                                if (val.booking?.advancePaymentEnable ?? false)
                                  PaymentSummaryWidget(
                                    booking: val.booking!,
                                  ),
                                (val.booking?.bookingStatus?.slug ==
                                            appFonts.accepted ||
                                        val.booking?.bookingStatus?.slug ==
                                            appFonts.pending)
                                    ? val.checkForCancelButtonShow()
                                        ? ButtonCommon(
                                            title: translations?.cancelBooking ?? "Cancel Booking",
                                            onTap: () => val.onCancelBooking(
                                                context)).paddingOnly(
                                            top: Insets.i35, bottom: Insets.i30)
                                        : const VSpace(Sizes.s80)
                                    : const VSpace(Sizes.s80)
                              ]).paddingSymmetric(horizontal: Insets.i20)),
                        ),
                        if (val.booking?.bookingStatus?.slug == "assigned" &&
                            (val.booking?.service?.type == "remotely" ||
                                val.booking?.service?.type == "provider_site"))
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(children: [
                                if (val.booking?.service?.type ==
                                    "provider_site")
                                  Expanded(
                                    child: ButtonCommon(
                                            title: translations?.location ?? "Location",
                                            color: appColor(context).whiteBg,
                                            borderColor: appColor(context).primary,
                                            fontColor: appColor(context).primary,
                                            onTap: () async {
                                              final availableMaps =
                                                  await MapLauncher
                                                      .installedMaps;
                                              if (availableMaps.isNotEmpty) {
                                                await availableMaps.first
                                                    .showMarker(
                                                  coords: Coords(
                                                    double.tryParse(val
                                                                .booking
                                                                ?.service
                                                                ?.destinationLocation
                                                                ?.lat ??
                                                            '') ??
                                                        0.0,
                                                    double.tryParse(val
                                                                .booking
                                                                ?.service
                                                                ?.destinationLocation
                                                                ?.lng ??
                                                            '') ??
                                                        0.0,
                                                  ),
                                                  title: val.booking?.service?.title ?? "Service Location",
                                                );
                                              }
                                            })
                                        .paddingOnly(
                                            left: Sizes.s20,
                                            right: Sizes.s20,
                                            bottom: Insets.i20)
                                        .backgroundColor(
                                            appColor(context).whiteBg),
                                  ),
                                val.booking?.service?.type == "remotely"
                                    ? val.booking?.zoomMeeting == null
                                        ? Container()
                                        : Expanded(
                                            child: ButtonCommon(
                                                    title: "Join Meeting",
                                                    onTap: () {
                                                      val.openZoom(context,
                                                          bookingId:
                                                              val.booking?.id,
                                                          meetingLink: val
                                                              .booking
                                                              ?.zoomMeeting
                                                              ?.joinUrl);
                                                    })
                                                .paddingOnly(
                                                    left: Sizes.s20,
                                                    right: Sizes.s20,
                                                    bottom: Insets.i20)
                                                .backgroundColor(
                                                    appColor(context).whiteBg),
                                          )
                                    : Expanded(
                                        child:
                                            ButtonCommon(
                                                    title: translations?.startService ?? "Start Service",
                                                    onTap: () =>
                                                        val.onStart(context))
                                                .paddingOnly(
                                                    left: Sizes.s20,
                                                    right: Sizes.s20,
                                                    bottom: Insets.i20)
                                                .backgroundColor(
                                                    appColor(context).whiteBg))
                              ]))
                      ])))));
    });
  }
}
