import 'dart:developer';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/config.dart';
import 'package:klpro_user/screens/app_pages_screens/app_details_screen/layouts/page_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../models/status_booking_model.dart';

class PendingBookingProvider with ChangeNotifier {
  List<StatusBookingModel> pendingBookingList = [];
  StatusBookingModel? statusModel;
  BookingModel? booking;
  final FocusNode searchFocus = FocusNode();
  TextEditingController reasonCtrl = TextEditingController();
  bool isLoading = false; // Track loading state

  onReady(BuildContext context) async {
    final modalRoute = ModalRoute.of(context);
    if (modalRoute == null) return;
    
    dynamic arg = modalRoute.settings.arguments;
    if (arg == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());

    try {
      if (arg is Map && arg['bookingId'] != null) {
        await getBookingDetailById(context, id: arg['bookingId']);
      } else if (arg is Map && arg["booking"] != null) {
        // Case 2: Use passed BookingModel without API call
        booking = arg["booking"] as BookingModel;
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
      } else {
        log("No bookingId or booking provided in arguments");
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
      }
    } catch (e) {
      log("Error in onReady: $e");
      isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  onBack(context, isBack) {
    booking = null;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  checkForCancelButtonShow() {
    if (booking?.dateTime == null) return false;
    bool isShow = false;
    DateTime now = DateTime.now();
    try {
      DateTime bookDate = DateTime.parse(booking!.dateTime!);
      Duration duration = now.difference(bookDate);
      isShow = duration.inHours <
          int.parse(
              appSettingModel?.general?.cancellationRestrictionHours ?? "1");
    } catch (e) {
      log("Error parsing date: $e");
    }
    return isShow;
  }

  // Booking detail by ID
  getBookingDetailById(context, {id}) async {
    final bookingId = id ?? booking?.id;
    if (bookingId == null) return;
    
    isLoading = true;
    try {
      final response = await apiServices.getApi(
        "${api.booking}/$bookingId",
        [],
        isToken: true,
        isData: true,
      );

      if (response.isSuccess == true) {
        isLoading = false;
        if (response.data != null && response.data['data'] != null) {
          booking = BookingModel.fromJson(response.data['data']);
        }
        notifyListeners();
      } else {
        isLoading = false;
        Fluttertoast.showToast(msg: response.message ?? "Failed to fetch booking details");
        notifyListeners();
      }
    } catch (e, s) {
      isLoading = false;
      debugPrint("Error fetching booking details: $e=========>$s");
      notifyListeners();
    }
  }

  onRefresh(context) async {
    if (booking?.id == null) return;
    isLoading = true;
    notifyListeners();
    await getBookingDetailById(context);
    isLoading = false;
    notifyListeners();
  }

  // Update status
  bool isUpdateCancel = false;

  updateStatus(context, {isCancel = false}) async {
    if (booking?.id == null) return;
    
    try {
      isUpdateCancel = true;
      showLoading(context);
      notifyListeners();
      dynamic data = isCancel
          ? {"reason": reasonCtrl.text, "booking_status": "cancel"}
          : {"booking_status": "cancel"};
 
      final response = await apiServices.putApi(
        "${api.booking}/${booking?.id}",
        data,
        isToken: true,
        isData: true,
      );
 
      if (context.mounted) {
        hideLoading(context);
      }
      if (response.isSuccess == true) {
        isUpdateCancel = false;
        if (response.data != null) {
           booking = BookingModel.fromJson(response.data);
        }
        reasonCtrl.clear();
        if (context.mounted) {
          route.pop(context);
          completeSuccess(context);
        }
      } else {
        isUpdateCancel = false;
        Fluttertoast.showToast(msg: response.message ?? "Failed to update status");
      }
    } catch (e) {
      isUpdateCancel = false;
      if (context.mounted) {
        hideLoading(context);
      }
      debugPrint("Error updating status: $e");
    }
    notifyListeners();
  }
 
  onCancelBooking(context) {
    final appDetails = Provider.of<AppDetailsProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (context1) =>
            Consumer<PendingBookingProvider>(builder: (context2, value, child) {
              return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  insetPadding:
                      const EdgeInsets.symmetric(horizontal: Insets.i20),
                  shape: const SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.all(SmoothRadius(
                          cornerRadius: AppRadius.r14, cornerSmoothing: 1))),
                  backgroundColor: appColor(context).whiteBg,
                  content: Stack(alignment: Alignment.topRight, children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(language(context, translations?.reason ?? "Reason"),
                              style: appCss.dmDenseMedium14
                                  .textColor(appColor(context).darkText)),
                          const VSpace(Sizes.s8),
                          TextFieldCommon(
                              controller: reasonCtrl,
                              focusNode: searchFocus,
                              hintText:
                                  translations?.writeHere ?? appFonts.writeHere,
                              maxLines: 4,
                              onChanged: (v) {
                                notifyListeners();
                              },
                              minLines: 4,
                              fillColor: appColor(context).fieldCardBg),
                          // Sub text
                          const VSpace(Sizes.s15),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language(context, "•"),
                                    style: appCss.dmDenseMedium14.textColor(
                                        appColor(context).lightText)),
                                const HSpace(Sizes.s10),
                                Expanded(
                                    child: RichText(
                                        text: TextSpan(
                                            style: appCss.dmDenseMedium14
                                                .textColor(appColor(context)
                                                    .lightText),
                                            text: language(context,
                                                translations?.pleaseReadThe ?? ""),
                                            children: [
                                      if (translations?.cancellationPolicy != null)
                                      TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              appDetails.pageList
                                                  .asMap()
                                                  .entries
                                                  .forEach((e) {
                                                if (e.value.title ==
                                                        language(
                                                            context,
                                                            translations?.cancellationPolicy ?? "Cancellation Policy")) {
                                                     route.push(
                                                        context,
                                                        PageDetail(
                                                          page: e.value,
                                                        ));
                                                }
                                              });
                                            },
                                          style: TextStyle(
                                              color: appColor(context).darkText,
                                              fontFamily: GoogleFonts.dmSans()
                                                  .fontFamily,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  TextDecoration.underline),
                                          text: language(
                                              context,
                                              translations?.cancellationPolicy ?? "Cancellation Policy")),
                                      TextSpan(
                                          style: appCss.dmDenseMedium14
                                              .textColor(
                                                  appColor(context).lightText),
                                          text: language(context,
                                              translations?.beforeCancelling ?? ""))
                                    ])))
                              ]),
                          const VSpace(Sizes.s20),
                          ButtonCommon(
                              color: reasonCtrl.text.isNotEmpty
                                  ? appColor(context).primary
                                  : appColor(context).primary.withOpacity(0.10),
                              borderColor: reasonCtrl.text.isNotEmpty
                                  ? appColor(context).primary
                                  : appColor(context).primary.withOpacity(0.10),
                              fontColor: reasonCtrl.text.isNotEmpty
                                  ? appColor(context).whiteColor
                                  : appColor(context).primary,
                              onTap: () {
                                if (reasonCtrl.text.isNotEmpty) {
                                  updateStatus(context, isCancel: true);
                                  getBookingDetailById(context);
                                  Provider.of<DashboardProvider>(context,
                                          listen: false)
                                      .getBookingHistory(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please Enter reason");
                                }
                              },
                              title: translations?.submit ?? appFonts.submit)
                        ]).padding(
                        horizontal: Insets.i20,
                        top: Insets.i60,
                        bottom: Insets.i20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          Text(
                              language(
                                  context, translations?.reasonOfCancelBooking ?? "Reason of Cancel Booking"),
                              style: appCss.dmDenseExtraBold16
                                  .textColor(appColor(context).darkText)),
                          Icon(CupertinoIcons.multiply,
                                  size: Sizes.s20,
                                  color: appColor(context).darkText)
                              .inkWell(onTap: () => route.pop(context))
                        ]).paddingAll(Insets.i20)
                  ]));
            })).then((value) {
      reasonCtrl.text = "";
      notifyListeners();
    });
  }
 
  completeSuccess(context) {
    showCupertinoDialog(
        context: context,
        builder: (context1) {
          return AlertDialogCommon(
              title: translations?.successfullyDelete ?? "Successfully Deleted",
              height: Sizes.s140,
              image: eGifAssets.successGif,
              subtext:
                  language(context, translations?.cancelBookingSuccessfully ?? "Your booking has been cancelled successfully."),
              bText1: language(context, translations?.okay ?? "Okay"),
              b1OnTap: () {
                route.pop(context);
                if (booking?.id != null) {
                route.pushNamed(context, routeName.cancelledServiceScreen,
                    arg: {"bookingId": booking?.id}).then((e) {
                  route.pushNamedAndRemoveUntil(context, routeName.dashboard);
                  if (context.mounted) {
                    final dash =
                        Provider.of<DashboardProvider>(context, listen: false);
                    dash.selectIndex = 1;
                    dash.notifyListeners();
                  }
                });
                }
              });
        });
  }
}

