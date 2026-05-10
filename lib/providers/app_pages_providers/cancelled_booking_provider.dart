import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';

import '../../config.dart';
import '../../models/status_booking_model.dart';

class CancelledBookingProvider with ChangeNotifier {
  List<StatusBookingModel> cancelledBookingList = [];
  BookingModel? booking;

  bool isLoading = false;

  onReady(BuildContext context) async {
    dynamic arg = ModalRoute.of(context)?.settings.arguments;
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());

    try {
      if (arg != null && arg is Map && arg['bookingId'] != null) {
        // Case 1: Fetch data from API using bookingId
        await getBookingDetailBy(context, id: arg['bookingId']);
      } else if (arg != null && arg is Map && arg["booking"] != null) {
        // Case 2: Use passed BookingModel without API call
        booking = arg["booking"] as BookingModel;
        log("Using passed booking: id=${booking?.id}, serviceTitle=${booking?.service?.title}");
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
      } else {
        log("No bookingId or booking provided in arguments");
        Fluttertoast.showToast(msg: "Invalid booking data");
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
      }
    } catch (e) {
      log("Error in onReady: $e");
      Fluttertoast.showToast(msg: "Error loading booking details");
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

  //booking detail by id
  getBookingDetailBy(context, {id}) async {
    if (id == null && booking?.id == null) return;
    isLoading = true;
    try {
      await apiServices
          .getApi("${api.booking}/${id ?? booking?.id}", [],
              isToken: true, isData: true)
          .then((value) {
        if (context.mounted) {
          hideLoading(context);
        }
        if (value.isSuccess ?? false) {
          isLoading = false;
          debugPrint("BOOKING DATA : ${value.data['data']}");
          booking = BookingModel.fromJson(value.data['data']);
          notifyListeners();
        } else {
          Fluttertoast.showToast(msg: value.message);
        }
      });
      log("STATYS L $booking");
    } catch (e) {
      if (context.mounted) {
        hideLoading(context);
      }
      notifyListeners();
      isLoading = false;
    }
  }
}
