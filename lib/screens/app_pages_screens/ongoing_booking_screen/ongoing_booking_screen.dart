import 'dart:developer';

import 'package:klpro_user/common_tap.dart';
import 'package:klpro_user/screens/app_pages_screens/ongoing_booking_screen/layout/extra_service_add_billing.dart';
import 'package:klpro_user/screens/app_pages_screens/ongoing_booking_screen/layout/no_extra_service_billing.dart';
import 'package:klpro_user/screens/app_pages_screens/pending_booking_screen/layouts/payment_status_summary.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';
import '../../bottom_screens/booking_screen/booking_shimmer/booking_detail_shimmer.dart';

class OngoingBookingScreen extends StatefulWidget {
  const OngoingBookingScreen({super.key});

  @override
  State<OngoingBookingScreen> createState() => _OngoingBookingScreenState();
}

class _OngoingBookingScreenState extends State<OngoingBookingScreen>
    with TickerProviderStateMixin {
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      log("fdftsf :$state");
      final book = Provider.of<OngoingBookingProvider>(context, listen: false);
      book.getBookingDetailBy(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OngoingBookingProvider>(builder: (context1, value, child) {
      log("value.booking?.grandTotalWithExtras::${value.booking?.grandTotalWithExtras}////${value.booking?.total}");
      return StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 150), () => value.onReady(context)),
          child: PopScope(
              canPop: true,
              onPopInvoked: (didPop) {
                value.onBack(context, false);
                if (didPop) return;
              },
              child: Scaffold(
                  appBar: AppBarCommon(
                      title: translations?.ongoingBooking ?? "Ongoing Booking",
                      onTap: () => value.onBack(context, true)),
                  body: value.isLoading || value.booking == null
                      ? const BookingDetailShimmer()
                      : Stack(alignment: Alignment.bottomCenter, children: [
                          RefreshIndicator(
                            onRefresh: () async {
                              value.onRefresh(context);
                            },
                            child: SingleChildScrollView(
                                controller: value.scrollController,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      StatusDetailLayout(
                                          data: value.booking,
                                          onTapStatus: () => showBookingStatus(
                                              context, value.booking)),
                                      if (value.booking?.extraCharges?.isNotEmpty ?? false)
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                      language(
                                                          context,
                                                          translations?.addedServiceDetails ?? "Added Service Details"),
                                                      style: appCss
                                                          .dmDenseSemiBold14
                                                          .textColor(
                                                              appColor(context)
                                                                  .darkText))
                                                  .padding(
                                                      top: Insets.i20,
                                                      bottom: Insets.i10),
                                              AddServiceLayout(
                                                  extraCharge: value
                                                      .booking?.extraCharges),
                                            ]),
                                      Text(
                                              language(context,
                                                  translations?.billSummary ?? "Bill Summary"),
                                              style: appCss.dmDenseSemiBold14
                                                  .textColor(appColor(context)
                                                      .darkText))
                                          .paddingOnly(
                                              top: Insets.i25,
                                              bottom: Insets.i10),
                                      (value.booking?.extraCharges?.isNotEmpty ?? false)
                                          ? ExtraServiceAddBilling(
                                              booking: value.booking)
                                          : NoExtraServiceAddedBill(
                                              bookingModel: value.booking),
                                      if (value.booking?.advancePaymentEnable == true)
                                        PaymentSummaryWidget(
                                          booking: value.booking!,
                                        ),
                                      if (value.booking?.service != null)
                                        Column(
                                          children: [
                                            if (value.booking?.service?.reviews?.isNotEmpty ?? false)
                                              Column(
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                                language(
                                                                    context,
                                                                    translations?.review ?? "Review"),
                                                                overflow:
                                                                    TextOverflow.clip,
                                                                style: appCss
                                                                    .dmDenseSemiBold14
                                                                    .textColor(appColor(
                                                                            context)
                                                                        .darkText))),
                                                        Text(
                                                                language(
                                                                    context,
                                                                    translations?.viewAll ?? "View All"),
                                                                style: appCss
                                                                    .dmDenseRegular14
                                                                    .textColor(appColor(
                                                                            context)
                                                                        .primary))
                                                            .inkWell(
                                                                onTap: () =>
                                                                    route.pushNamed(
                                                                        context,
                                                                        routeName
                                                                            .servicesReviewScreen,
                                                                        arg: value
                                                                            .booking?.service))
                                                      ]).paddingOnly(
                                                      top: Insets.i20,
                                                      bottom: Insets.i12),
                                                  ...value.booking!.service!.reviews!
                                                      .asMap()
                                                      .entries
                                                      .map((e) => ServiceReviewLayout(
                                                          data: e.value,
                                                          index: e.key,
                                                          list: appArray.reviewList)),
                                                ],
                                              ),
                                          ],
                                        ),
                                      const VSpace(Sizes.s100)
                                    ]).paddingOnly(
                                    left: Insets.i20, right: Insets.i20)),
                          ),
                          AnimatedBuilder(
                              animation: value.scrollController,
                              builder: (BuildContext context, Widget? child) {
                                return AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    height: (value.scrollController.hasClients && value.scrollController.position
                                                .userScrollDirection ==
                                            ScrollDirection.reverse)
                                        ? 0
                                        : 70,
                                    color: appColor(context).whiteBg,
                                    padding: const EdgeInsets.only(
                                        left: Insets.i20,
                                        right: Insets.i20,
                                        bottom: Insets.i20),
                                    child: value.booking?.bookingStatus?.slug ==
                                            appFonts.onthewayStatus
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            decoration: ShapeDecoration(
                                                color:
                                                    appColor(context).primary,
                                                shape: SmoothRectangleBorder(
                                                    borderRadius:
                                                        SmoothBorderRadius(
                                                            cornerRadius:
                                                                AppRadius.r8,
                                                            cornerSmoothing:
                                                                1))),
                                            child:
                                                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              value.isUpdateStatus
                                                  ? const CircularProgressIndicator(
                                                          color: Colors.white)
                                                      .center()
                                                      .padding(
                                                          vertical: Sizes.s5)
                                                  : Text(
                                                      translations?.startService ?? "Start Service",
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: appCss
                                                          .dmDenseSemiBold16
                                                          .textColor(
                                                              appColor(context)
                                                                  .whiteColor))
                                            ])).inkWell(onTap: () => value.onStart(context))
                                        : value.isPayButton
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 50,
                                                decoration: ShapeDecoration(
                                                    color: appColor(context)
                                                        .greenColor,
                                                    shape: SmoothRectangleBorder(
                                                        borderRadius:
                                                            SmoothBorderRadius(
                                                                cornerRadius:
                                                                    AppRadius
                                                                        .r8,
                                                                cornerSmoothing:
                                                                    1))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    value.isBooking
                                                        ? const CircularProgressIndicator(
                                                                color: Colors
                                                                    .white)
                                                            .center()
                                                            .padding(
                                                                vertical:
                                                                    Sizes.s5)
                                                        : Text(
                                                            (value.booking?.advancePaymentEnable ==
                                                                        true &&
                                                                    (value.booking
                                                                            ?.remainingPaymentStatus
                                                                            ?.toLowerCase() !=
                                                                        'completed'))
                                                                ? (symbolPosition
                                                                    ? "${language(context, translations?.pay ?? "Pay")} ${getSymbol(context)}${value.booking?.remainingPaymentAmount?.toStringAsFixed(2) ?? "0.00"}"
                                                                    : "${language(context, translations?.pay ?? "Pay")} ${value.booking?.remainingPaymentAmount?.toStringAsFixed(2) ?? "0.00"}${getSymbol(context)}")
                                                                : (value.booking
                                                                            ?.paymentStatus !=
                                                                        "COMPLETED"
                                                                    ? (symbolPosition
                                                                        ? (value.booking?.grandTotalWithExtras ?? 0) !=
                                                                                0
                                                                            ? "${language(context, translations?.pay ?? "Pay")} ${getSymbol(context)}${value.booking?.grandTotalWithExtras?.toStringAsFixed(2) ?? "0.00"}"
                                                                            : "${language(context, translations?.pay ?? "Pay")} ${getSymbol(context)}${(value.booking?.total ?? 0).toStringAsFixed(2)}"
                                                                        : (value.booking?.grandTotalWithExtras ?? 0) !=
                                                                                0
                                                                            ? "${language(context, translations?.pay ?? "Pay")} ${value.booking?.grandTotalWithExtras?.toStringAsFixed(2) ?? "0.00"}${getSymbol(context)}"
                                                                            : "${language(context, translations?.pay ?? "Pay")} ${(value.booking?.total ?? 0).toStringAsFixed(2)}${getSymbol(context)}")
                                                                    : (symbolPosition
                                                                        ? "${language(context, translations?.pay ?? "Pay")} ${getSymbol(context)}${value.booking?.extraChargesTotal?.grandTotal == 0 ? (value.booking?.total ?? 0) : value.booking?.extraChargesTotal?.grandTotal?.toStringAsFixed(2) ?? "0.00"}"
                                                                        : "${language(context, translations?.pay ?? "Pay")} ${value.booking?.extraChargesTotal?.grandTotal == 0 ? (value.booking?.total ?? 0) : value.booking?.extraChargesTotal?.grandTotal?.toStringAsFixed(2) ?? "0.00"}${getSymbol(context)}")),
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: appCss
                                                                .dmDenseSemiBold16
                                                                .textColor(appColor(
                                                                        context)
                                                                    .whiteColor),
                                                          )
                                                  ],
                                                ),
                                              ).inkWell(onTap: () => value.paySuccess(context))
                                            : value.booking?.service != null &&
                                                    value.booking!.service!
                                                            .type ==
                                                        "remotely"
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                          child: ButtonCommon(
                                                              title: translations
                                                                      ?.completed ??
                                                                  "Completed",
                                                              onTap: () => value
                                                                  .completeConfirmation(
                                                                      context,
                                                                      this))),
                                                    ],
                                                  )
                                                : Row(children: [
                                                    /* Expanded(
                                                        child: ButtonCommon(
                                                            title: value.booking!
                                                                        .bookingStatus
                                                                        ?.slug ==
                                                                    appFonts
                                                                        .onHold
                                                                ? translations
                                                                        ?.restart ??
                                                                    "Restart"
                                                                : translations
                                                                        ?.pause ??
                                                                    "Pause",
                                                            color: value
                                                                        .booking!
                                                                        .bookingStatus!
                                                                        .name!
                                                                        .toLowerCase() ==
                                                                    appFonts
                                                                        .onHold
                                                                ? const Color(
                                                                    0xFF27AF4D)
                                                                : const Color(
                                                                    0xFFFF4B4B),
                                                            onTap: () => value
                                                                        .booking!
                                                                        .bookingStatus!
                                                                        .slug ==
                                                                    appFonts
                                                                        .onHold
                                                                ? value.onPauseConfirmation(
                                                                    context,
                                                                    isHold: false)
                                                                : value.onPauseConfirmation(context))),
                                                    const HSpace(Sizes.s15), */
                                                    Expanded(
                                                        child: ButtonCommon(
                                                            title: translations
                                                                    ?.completed ??
                                                                "Completed",
                                                            onTap: () => value
                                                                .completeConfirmation(
                                                                    context,
                                                                    this)))
                                                  ]));
                              })
                        ]))));
    });
  }
}
