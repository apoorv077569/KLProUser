import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:klpro_user/common_tap.dart';
import 'package:klpro_user/config.dart';
import 'package:klpro_user/helper/notification.dart';
import 'package:klpro_user/screens/bottom_screens/cart_screen/layouts/add_on_cart.dart';
import 'package:klpro_user/widgets/alert_message_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import '../../screens/bottom_screens/cart_screen/layouts/service_detail_layout.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> cartList = [];
  CouponModel? data;
  bool isLoading = false;
  double widget1Opacity = 0.0;
  dynamic checkoutBody;
  AnimationController? animationController;
  TextEditingController couponCtrl = TextEditingController();
  FocusNode focus = FocusNode();
  ScrollController scrollController = ScrollController();

  bool isPositionedRight = false;
  bool isAnimateOver = false, isPayment = false;
  AnimationController? controller;
  Animation<Offset>? offsetAnimation;
  CheckoutModel? checkoutModel;

  bool isEditing = false;
  int? editingItemId;

  onCode(context, values) async {
    if (values != null) {
      isLoading = true;
      notifyListeners();
      data = values;
      couponCtrl.text = data!.code!;
      notifyListeners();
      log("data!.code::${data!.code}///$data");
      await checkout(context);

      isLoading = false;

      notifyListeners();
    }
  }

  List bookReadingList = [];

  Future onReady(context) async {
    // Wrap in microtask to avoid "setState() during build" error
    Future.delayed(Duration.zero, () {
      isLoading = true;
      notifyListeners();
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userString = preferences.getString(session.user);

      if (userString != null) {
        UserModel userModel = UserModel.fromJson(json.decode(userString));

        // GET https://klproind.com/api/cart
        await apiServices
            .getApi(api.getCart, {}, isToken: true, isData: true)
            .then((value) {
          if (value.isSuccess! && value.data != null) {
            log("CART GET API SUCCESS: ${value.data}");

            // Response root contains "data" (list) and "total" (object)
            List<dynamic> listMap = value.data['data'] ?? [];
            cartList = listMap.map((e) => CartModel.fromJson(e)).toList();

            // Update checkoutModel totals from server response root
            if (value.data['total'] != null) {
              checkoutModel ??= CheckoutModel();
              checkoutModel!.total = FinalTotal.fromJson(value.data['total']);
            }

            log("Cart items decoded: ${cartList.length}");
          } else {
            log("FETCH CART FAILED: ${value.message}");
          }
        });
      }

      final dash = Provider.of<DashboardProvider>(context, listen: false);
      dash.getCoupons();

      /* // OLD LOCAL STORAGE CODE
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final rawJson = preferences.getString(session.cart);
    final dash = Provider.of<DashboardProvider>(context, listen: false);
    dash.getCoupons();
    debugPrint("rawJson : $rawJson");
    if (rawJson != null) {
      List<dynamic> listMap = jsonDecode(rawJson);
      debugPrint("map : $listMap");
      cartList = listMap.map((e) {
        log(" json.decode(e)['isPackage']:${json.decode(e)['serviceList']}");

        CartModel cartModel = CartModel(
            isPackage: json.decode(e)['isPackage'],
            servicePackageList: json.decode(e)['isPackage'] == true
                ? ServicePackageModel.fromJson(
                    json.decode(e)['servicePackageList'])
                : null,
            serviceList: json.decode(e)['isPackage'] == false
                ? Services.fromJson(json.decode(e)['serviceList'])
                : null);

        return cartModel;
      }).toList();
      log("cartListcartListcartList:${cartList}");
    } */
    } catch (e) {
      log("ERROR FETCHING CART: $e");
    }

    isLoading = false;
    notifyListeners();
    log("cartList : ${cartList.length}");
    log("cartList : $isLoading");
  }

  syncCartWithApi(context) async {
    try {
      if (cartList.isEmpty) {
        log("SYNC CART SKIPPED: Cart is empty (avoiding 422)");
        return;
      }

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userString = preferences.getString(session.user);
      if (userString != null) {
        UserModel userModel = UserModel.fromJson(json.decode(userString));

        Map body = {
          "consumer_id": userModel.id,
          "cart_data": cartList.map((e) => e.toJson()).toList()
        };

        log("SYNC CART BODY: $body");
        // POST https://klproind.com/api/cart
        await apiServices
            .postApi(api.syncCart, body, isData: true, isToken: true)
            .then((value) {
          if (value.isSuccess! && value.data != null) {
            log("CART SYNCED SUCCESSFULLY: ${value.data}");

            // Parsing root-level 'data' and 'total' from response
            if (value.data['data'] != null) {
              List<dynamic> listMap = value.data['data'] ?? [];
              cartList = listMap.map((e) => CartModel.fromJson(e)).toList();
            }

            // Update checkoutModel totals from server response root
            if (value.data['total'] != null) {
              checkoutModel ??= CheckoutModel();
              checkoutModel!.total = FinalTotal.fromJson(value.data['total']);
            }
            notifyListeners();
          } else {
            log("CART SYNC FAILED: ${value.message}");
          }
        });
      }
    } catch (e) {
      log("ERROR SYNCING CART: $e");
    }
  }

  onServiceDetail(context, {data, packageServices, totalServiceman}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context2) {
        return ServiceDetailLayout(
          data: data,
          packageService: packageServices,
          totalServiceman: totalServiceman,
        );
      },
    );
  }

  addOns(context, {data, packageServices, totalServiceman}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context2) {
        return AddOnServiceCart(
          data: data,
        );
      },
    );
  }

  int totalRequiredServiceMan(List<Services> service) {
    int count = 0;
    service.asMap().entries.forEach((element) {
      count = count + (element.value.selectedRequiredServiceMan!);
    });

    notifyListeners();
    return count;
  }

  checkout(context, {isCreateBook = false}) async {
    isLoading = true;
    notifyListeners();
    try {
      if (cartList.isNotEmpty) {
        try {
          int primaryIndex = 0;
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences = await SharedPreferences.getInstance();
          //Map user = json.decode(preferences!.getString(session.user)!);
          UserModel userModel = UserModel.fromJson(
              json.decode(preferences.getString(session.user)!));
          final locationCtrl =
              Provider.of<LocationProvider>(context, listen: false);
          int index = locationCtrl.addressList
              .indexWhere((element) => element.isPrimary == 1);
          if (index >= 0) {
            primaryIndex = index;
          } else {
            primaryIndex = 0;
          }
          List services = [];
          List servicesPackage = [];

          cartList.asMap().entries.forEach((element) {
            if (element.value.isPackage! == false) {
              List idList = [];
              if (element.value.serviceList!.selectedServiceMan != null &&
                  element.value.serviceList!.selectedServiceMan!.isNotEmpty) {
                for (var list
                    in element.value.serviceList!.selectedServiceMan!) {
                  idList.add(list.id);
                }
              }
              List<Map<String, dynamic>> additionalServiceList = [];
              if (element.value.serviceList?.selectedAdditionalServices !=
                      null &&
                  element.value.serviceList!.selectedAdditionalServices!
                      .isNotEmpty) {
                for (var item
                    in element.value.serviceList!.selectedAdditionalServices!) {
                  if (item is Map<String, dynamic>) {
                    additionalServiceList.add({
                      "id": item['id'],
                      "qty": item['qty'] ?? 1,
                    });
                  } else {
                    additionalServiceList.add({
                      "id": item.id,
                      "qty": item.qty ?? 1,
                    });
                  }
                }
              }

              if (element.value.serviceList?.taxes != null &&
                  element.value.serviceList!.taxes!.isNotEmpty) {
                for (var item in element.value.serviceList!.taxes!) {
                  if (item is Map<String, dynamic>) {
                    additionalServiceList.add(item['id']);
                  } else {
                    // Assume item has an 'id' property
                    additionalServiceList.add(item.id);
                  }
                }
              }
              List<Map<String, dynamic>> scheduledDatesArray =
                  (element.value.serviceList?.scheduledDatesJson ?? [])
                      .map<Map<String, dynamic>>((date) {
                return {
                  "date": DateFormat("yyyy-MM-dd").format(date),
                  "time": DateFormat("HH:mm").format(DateFormat("hh:mm a")
                      .parse(element.value.serviceList!
                          .scheduleTime!)), //element.value.serviceList?.scheduleTime,
                };
              }).toList();

              log("element.value.serviceList!.type::${element.value.serviceList?.serviceDate}");
              var serviceData = {
                "service_id": element.value.serviceList!.id,
                "type": element.value.serviceList!.type ?? 'fixed',
                "required_servicemen": element.value.serviceList!
                        .selectedRequiredServiceMan ??
                    element.value.serviceList!.requiredServicemen ??
                    1,
                if (element.value.serviceList!.type != "scheduled")
                  "date_time":
                      "${DateFormat("dd-MMM-yyyy").format(element.value.serviceList?.serviceDate ?? DateTime.now())},${DateFormat("hh:mm").format(element.value.serviceList?.serviceDate ?? DateTime.now())} ${element.value.serviceList?.selectedDateTimeFormat != null ? element.value.serviceList?.selectedDateTimeFormat?.toLowerCase() : DateFormat("aa").format(element.value.serviceList?.serviceDate ?? DateTime.now()).toLowerCase()}",
                "address_id": element.value.serviceList?.primaryAddress?.id ??
                    (locationCtrl.addressList.isNotEmpty
                        ? locationCtrl.addressList[primaryIndex].id
                        : 0),
                "select_serviceman":
                    element.value.serviceList?.selectServiceManType,
                "serviceman_ids": idList,
                if (element.value.serviceList!.type != "scheduled")
                  "select_date_time":
                      element.value.serviceList?.selectDateTimeOption,
                "description":
                    element.value.serviceList?.selectedServiceNote ?? "",
                "additional_services": additionalServiceList,
                if ((element.value.serviceList?.type == 'scheduled' ||
                        element.value.serviceList?.type == 'schedule') &&
                    element.value.serviceList?.isScheduledBooking == 1) ...{
                  "is_scheduled_booking":
                      element.value.serviceList!.isScheduledBooking == 1
                          ? 1
                          : 0,
                  "schedule_start_date": DateFormat("yyyy-MM-dd")
                      .format(element.value.serviceList!.scheduleStartDate!),
                  //element.value.serviceList!.scheduleStartDate,
                  "schedule_end_date": DateFormat("yyyy-MM-dd")
                      .format(element.value.serviceList!.scheduleEndDate!),
                  "schedule_time": DateFormat("HH:mm").format(
                      DateFormat("hh:mm a")
                          .parse(element.value.serviceList!.scheduleTime!)),
                  "booking_frequency":
                      element.value.serviceList!.bookingFrequency,
                  "scheduled_dates_json": scheduledDatesArray,
                  "scheduled_services_count":
                      element.value.serviceList!.scheduledServicesCount,
                  if (element.value.serviceList!.bookingFrequency == "daily" &&
                      element.value.serviceList!.selectedWeekdays != null)
                    "selected_weekdays": element
                            .value.serviceList!.selectedWeekdays
                            ?.map((day) => day.toLowerCase())
                            .toList() ??
                        [],
                }
              };

              services.add(serviceData);
            } else {
              List servicesPackageService = [];
              List idList = [];

              for (var ser in element.value.servicePackageList!.services!) {
                log("ser.selectServiceManType  :${ser.selectServiceManType} //${ser.id}");
                if (ser.selectServiceManType != "app_choose") {
                  for (var list in ser.selectedServiceMan!) {
                    idList.add(list.id);
                  }
                } else {
                  idList = [];
                  ser.selectedRequiredServiceMan ??= 1;
                }
                log("idList :$idList");
                List<Map<String, dynamic>> additionalServiceList = [];
                if (ser.selectedAdditionalServices != null &&
                    ser.selectedAdditionalServices!.isNotEmpty) {
                  for (var list in ser.selectedAdditionalServices!) {
                    additionalServiceList.add({
                      "id": list.id,
                      "qty": list.qty ?? 1,
                    });
                  }
                }

                var serviceData = {
                  "service_id": ser.id,
                  "type": ser.type ?? "fixed",
                  "required_servicemen": ser.selectedRequiredServiceMan ??
                      (idList.isEmpty ? "1" : idList.length.toString()),
                  "date_time":
                      "${DateFormat("dd-MMM-yyyy").format(ser.serviceDate!)},${DateFormat("hh:mm").format(ser.serviceDate!)} ${ser.selectedDateTimeFormat != null ? ser.selectedDateTimeFormat!.toLowerCase() : DateFormat("aa").format(ser.serviceDate!).toLowerCase()}",
                  "address_id": ser.primaryAddress != null
                      ? ser.primaryAddress!.id
                      : locationCtrl.addressList[primaryIndex].id,
                  "select_serviceman": ser.selectServiceManType,
                  "serviceman_ids":
                      ser.selectServiceManType == "app_choose" ? [] : idList,
                  "select_date_time": ser.selectDateTimeOption,
                  "description": ser.selectedServiceNote,
                  "additional_services": additionalServiceList
                };

                servicesPackageService.add(serviceData);
              }

              var package = {
                "service_package_id": element.value.servicePackageList!.id,
                "services": servicesPackageService,
              };
              servicesPackage.add(package);
            }
          });

          notifyListeners();
          var body = {
            "consumer_id": userModel.id,
            "services": services,
            "service_packages": servicesPackage,
            "coupon": data != null
                ? data!.code
                : couponCtrl.text.isEmpty
                    ? null
                    : couponCtrl.text,
            "wallet_balance": userModel.wallet?.balance,
            "payment_method": "cash",
            "currency_code": "USD"
          };

          log("CHECKOUT : $body");
          checkoutBody = body;
          notifyListeners();
          await apiServices
              .postApi(api.checkout, body, isData: true, isToken: true)
              .then((value) async {
            log("CHECKOUT RES :${value.data}");
            if (value.data == 0) {
              if (value.message.contains("Unauthenticated.") ||
                  value.message == "Unauthenticated.") {
                SharedPreferences? preferences =
                    await SharedPreferences.getInstance();
                final dash =
                    Provider.of<DashboardProvider>(context, listen: false);
                dash.selectIndex = 0;
                dash.notifyListeners();
                preferences.remove(session.user);
                preferences.remove(session.accessToken);
                preferences.remove(session.isContinueAsGuest);
                preferences.remove(session.isLogin);
                preferences.remove(session.cart);
                preferences.remove(session.recentSearch);

                final auth = FirebaseAuth.instance.currentUser;

                if (auth != null) {
                  FirebaseAuth.instance.signOut();
                  /* GoogleSignIn().disconnect(); */
                  final googleSignIn = GoogleSignIn.instance;

                  googleSignIn.disconnect();
                  route.pushNamedAndRemoveUntil(context, routeName.login);
                }
                notifyListeners();
                route.pop(context);
                route.pushAndRemoveUntil(context);
                route.pushAndRemoveUntil(context);
              } else {
                Fluttertoast.showToast(
                    msg: value.message, backgroundColor: Colors.red);
                couponCtrl.text = '';
                data = null;
                notifyListeners();
              }
            } else {
              if (value.isSuccess!) {
                checkoutModel = CheckoutModel.fromJson(value.data);
                // log("message-=-=-=-=-=${checkoutModel?.services?[0].additionalServices?.first?.totalPrice}");

                notifyListeners();
              } else {
                Fluttertoast.showToast(msg: value.message);
                log("message 1234564643 ${value.message}");
              }
            }
          });
          Future.delayed(const Duration(milliseconds: 500), () {
            widget1Opacity = 1;
            notifyListeners();
          });
          log("checkoutModel::$checkoutModel");
        } catch (e, s) {
          Future.delayed(const Duration(milliseconds: 500), () {
            widget1Opacity = 1;
            notifyListeners();
          });
          log("CART ERROE :$e====> $s");
        } finally {
          isLoading = false;
          notifyListeners();
        }
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          widget1Opacity = 1;
          notifyListeners();
        });
      }
    } catch (e) {
      log("EEEE checkout : $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  editCart(CartModel cart, context, index) async {
    if (cart.isPackage!) {
      isEditing = true;
      editingItemId = cart.id;
      notifyListeners();

      route.pushNamed(context, routeName.selectServiceScreen, arg: {
        "services": cart.servicePackageList!,
        "id": cart.servicePackageList!.id
      });
    } else {
      log("afjdiojfdisfjdiksfjdsmessage");
      final providerDetail =
          Provider.of<ProviderDetailsProvider>(context, listen: false);
      providerDetail.selectProviderIndex = 0;
      providerDetail.notifyListeners();

      isEditing = true;
      editingItemId = cart.id;
      notifyListeners();

      onBook(context, cart.serviceList!,
          addTap: () => onAdd(context, index),
          minusTap: () => onRemoveService(context, index));
    }
  }

  updateCartItemApi(context, CartModel updatedCartItem) async {
    try {
      showLoading(context);
      isLoading = true;
      notifyListeners();

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userString = preferences.getString(session.user);
      if (userString != null && editingItemId != null) {
        UserModel userModel = UserModel.fromJson(json.decode(userString));

        Map body = {
          "consumer_id": userModel.id,
          "cart_data": [updatedCartItem.toJson()]
        };

        log("UPDATE CART ITEM BODY: $body");
        // POST https://klproind.com/api/cart/{id}
        await apiServices
            .postApi("${api.cart}/$editingItemId", body,
                isData: true, isToken: true)
            .then((value) async {
          if (value.isSuccess!) {
            log("CART ITEM UPDATED SUCCESSFULLY: ${value.data}");
            isEditing = false;
            editingItemId = null;
            await onReady(context);
            notifyListeners();
            route.pushNamed(context, routeName.cartScreen);
          } else {
            log("CART ITEM UPDATE FAILED: ${value.message}");
            flutterAlertMessage(context,
                msg: value.message, bgColor: appColor(context).red);
          }
        });
      }
    } catch (e) {
      log("ERROR UPDATING CART ITEM: $e");
    } finally {
      isLoading = false;
      hideLoading(context);
      isEditing = false; // Reset anyway
      notifyListeners();
    }
  }

  onRemoveService(context, index) async {
    if ((cartList[index].serviceList!.selectedRequiredServiceMan!) == 1) {
      route.pop(context);
      isAlert = false;
      notifyListeners();
    } else {
      if ((cartList[index].serviceList!.requiredServicemen!) ==
          (cartList[index].serviceList!.selectedRequiredServiceMan!)) {
        isAlert = true;
        notifyListeners();
        await Future.delayed(DurationClass.s3);
        isAlert = false;
        notifyListeners();
      } else {
        isAlert = false;
        notifyListeners();
        cartList[index].serviceList!.selectedRequiredServiceMan =
            ((cartList[index].serviceList!.selectedRequiredServiceMan!) - 1);
        
        // Sync with API immediately
        await syncCartWithApi(context);
        await checkout(context);
      }
    }
    notifyListeners();
  }

  onAdd(context, index) async {
    isAlert = false;
    notifyListeners();
    int count = (cartList[index].serviceList!.selectedRequiredServiceMan!);
    count++;
    cartList[index].serviceList!.selectedRequiredServiceMan = count;

    // Sync with API immediately
    await syncCartWithApi(context);
    await checkout(context);
    notifyListeners();
  }

  deleteCart(context, index) async {
    final cartItem = cartList[index];
    int? itemId = cartItem.id;
    route.pop(context);
    isLoading = true;
    notifyListeners();

    if (itemId != null) {
      // DELETE https://klproind.com/api/cart/{id}
      await apiServices
          .deleteApi("${api.deleteCart}/$itemId", {}, isToken: true)
          .then((value) async {
        if (value.isSuccess!) {
          cartList.removeAt(index);
          // If server returns updated totals in delete response, we can parse them here
          // For now, we refresh via onReady to be safe
          await onReady(context);
          completeSuccess(context);
        } else {
          log("DELETE FAILED: ${value.message}");
        }
      });
    } else {
      // Fallback if no ID (should not happen with synced cart)
      cartList.removeAt(index);
      await syncCartWithApi(context);
      completeSuccess(context);
    }

    isLoading = false;
    notifyListeners();
  }

  completeSuccess(context) {
    showCupertinoDialog(
      context: context,
      builder: (context1) {
        return AlertDialogCommon(
          title: translations!.successfullyDelete,
          height: Sizes.s140,
          image: eGifAssets.successGif,
          subtext: language(context, translations!.cartDeletedSuccessfully),
          bText1: language(context, translations!.okay),
          b1OnTap: () {
            // route.pushNamed(context, routeName.dashboard);
            Navigator.pop(context1);
          },
        );
      },
    );
  }

  onApplyRemoveTap(context) {
    if (data != null) {
      data = null;
      couponCtrl.text = "";
      notifyListeners();
    }
    checkout(context);
  }

  deleteCartConfirmation(context, sync, id) {
    animateDesign(sync);
    showDialog(
        context: context,
        builder: (context1) {
          return StatefulBuilder(builder: (context2, setState) {
            return Consumer<CartProvider>(builder: (context3, value, child) {
              return AlertDialog(
                  insetPadding:
                      const EdgeInsets.symmetric(horizontal: Insets.i20),
                  shape: const SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.all(SmoothRadius(
                          cornerRadius: AppRadius.r14, cornerSmoothing: 1))),
                  backgroundColor: appColor(context).whiteBg,
                  content: Stack(alignment: Alignment.topRight, children: [
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      // Gif
                      Stack(alignment: Alignment.topCenter, children: [
                        Stack(alignment: Alignment.topCenter, children: [
                          SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        SizedBox(
                                            height: Sizes.s180,
                                            width: Sizes.s150,
                                            child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                curve: isPositionedRight
                                                    ? Curves.bounceIn
                                                    : Curves.bounceOut,
                                                alignment: isPositionedRight
                                                    ? Alignment.center
                                                    : Alignment.topCenter,
                                                child: AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    height: 40,
                                                    child: Image.asset(
                                                        eImageAssets
                                                            .cartTrash)))),
                                        Image.asset(eImageAssets.dustbin,
                                                height: Sizes.s88,
                                                width: Sizes.s88)
                                            .paddingOnly(bottom: Insets.i24)
                                      ]))
                              .decorated(
                                  color: appColor(context).fieldCardBg,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.r10)),
                        ]),
                        if (offsetAnimation != null)
                          SlideTransition(
                              position: offsetAnimation!,
                              child: (offsetAnimation != null &&
                                      isAnimateOver == true)
                                  ? Image.asset(eImageAssets.dustbinCover,
                                      height: 38)
                                  : const SizedBox())
                      ]),
                      // Sub text
                      const VSpace(Sizes.s15),
                      Text(
                          language(
                              context, translations!.deleteCartSuccessfully),
                          textAlign: TextAlign.center,
                          style: appCss.dmDenseRegular14
                              .textColor(appColor(context).lightText)
                              .textHeight(1.2)),
                      const VSpace(Sizes.s20),
                      Row(children: [
                        Expanded(
                            child: ButtonCommon(
                                onTap: () => route.pop(context),
                                title: translations!.no!,
                                borderColor: appColor(context).primary,
                                color: appColor(context).whiteBg,
                                style: appCss.dmDenseSemiBold16
                                    .textColor(appColor(context).primary))),
                        const HSpace(Sizes.s15),
                        Expanded(
                            child: ButtonCommon(
                                color: appColor(context).primary,
                                fontColor: appColor(context).whiteColor,
                                onTap: () => deleteCart(context, id),
                                title: translations!.yes!))
                      ])
                    ]).padding(top: Insets.i40),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          Text(
                              language(
                                  context, translations!.successfullyDelete),
                              style: appCss.dmDenseExtraBold18
                                  .textColor(appColor(context).darkText)),
                          Icon(CupertinoIcons.multiply,
                                  size: Sizes.s20,
                                  color: appColor(context).darkText)
                              .inkWell(onTap: () => route.pop(context))
                        ])
                  ]));
            });
          });
        }).then((value) {
      isPositionedRight = false;
      isAnimateOver = false;
      notifyListeners();
    });
  }

  onPaymentTap(context) {
    if (checkoutModel != null &&
        checkoutModel!.total != null &&
        checkoutModel!.total!.total! < 100) {
      flutterAlertMessage(context,
          msg: "Service less than ₹100 is not applicable,please add-on another service.",
          bgColor: appColor(context).red);
      return;
    }
    bool isServiceOnline = false;
    bool isPackageOnline = false;
    for (var a in cartList) {
      if (!a.isPackage!) {
        // log("a.serviceList!.type:${a.serviceList!.type}");
        if (a.serviceList!.type!.contains("hourly")) {
          isServiceOnline = true;
          notifyListeners();
        }
      } else {
        List<Services> ser = a.servicePackageList!.services!;
        log("a.serviceList!.type:${a.servicePackageList!.services![0].advancePaymentEnabled}");
        isPackageOnline =
            ser.where((element) => element.type == "hourly").isNotEmpty;
      }
    }
    log("ISS :$isPackageOnline || $isServiceOnline");
    if (isServiceOnline || isPackageOnline) {
      proceedToBook(context);
    } else {
      route.pushNamed(context, routeName.paymentScreen,
          arg: {"checkoutBody": checkoutBody, "checkoutModel": checkoutModel});
    }
  }

  proceedToBook(context) async {
    try {
      showLoading(context);
      notifyListeners();
      var body = checkoutBody;
/*
      body["payment_method"] = "cash";
      body["currency_code"] = currency(context).currency!.code;
*/
      checkoutBody = body;
      notifyListeners();
      log("CCCCCCHECKOUT BODY: $checkoutBody");
      await apiServices
          .postApi(api.booking, body, isData: true, isToken: true)
          .then((value) async {
        hideLoading(context);
        notifyListeners();
        if (value.isSuccess!) {
          log("SHHHH :${value.data}");
          createBookingNotification(NotificationType.createBookingEvent);
          // onContinue(context);

          notifyListeners();
        } else {
          log("SHHHH ::;:${value.data} //${value.message}");
          flutterAlertMessage(context,
              msg: value.message, bgColor: appColor(context).red);
        }
      });
    } catch (e) {
      log("SHHHH:$e");
      flutterAlertMessage(context,
          msg: e.toString(), bgColor: appColor(context).red);
      hideLoading(context);
      notifyListeners();
    }
  }

  // onContinue(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context1) {
  //         return AlertDialogCommon(
  //             isBooked: true,
  //             title: appFonts.successfullyBooked,
  //             widget: AnimatedOpacity(
  //                 opacity: 1.0,
  //                 duration: const Duration(seconds: 2),
  //                 child: Container(
  //                   alignment: Alignment.center,
  //                   width: MediaQuery.of(context).size.width,
  //                   child: Image.asset(eSvgAssets.booked, height: Sizes.s145),
  //                 )).paddingSymmetric(vertical: Insets.i20),
  //             subtext: appFonts.yourBookingHasBeen,
  //             bText1: appFonts.goToBookingList,
  //             height: Sizes.s145,
  //             b1OnTap: () async {
  //               route.pushNamedAndRemoveUntil(context, routeName.dashboard);
  //               final dash =
  //                   Provider.of<DashboardProvider>(context, listen: false);
  //               final common =
  //                   Provider.of<CommonApiProvider>(context, listen: false);
  //               common.selfApi(context);
  //               final wallet =
  //                   Provider.of<WalletProvider>(context, listen: false);
  //               wallet.getWalletList(context);
  //               dash.selectIndex = 1;
  //               dash.notifyListeners();
  //               dash.getBookingHistory(context);

  //               checkoutModel = null;
  //               isPayment = true;
  //               cartList = [];

  //               notifyListeners();

  //               SharedPreferences preferences =
  //                   await SharedPreferences.getInstance();
  //               preferences.remove(session.cart);
  //               notifyListeners();
  //             });
  //       });
  // }

  animateDesign(TickerProvider sync) {
    Future.delayed(DurationClass.ms500).then((value) {
      isPositionedRight = true;
      notifyListeners();
    }).then((value) {
      Future.delayed(DurationClass.ms150).then((value) {
        isAnimateOver = true;
        notifyListeners();
      }).then((value) {
        controller = AnimationController(
            vsync: sync, duration: const Duration(seconds: 2))
          ..forward();
        offsetAnimation = Tween<Offset>(
                begin: const Offset(0, 0.5), end: const Offset(0, 1))
            .animate(
                CurvedAnimation(parent: controller!, curve: Curves.elasticOut));
        notifyListeners();
      });
    });

    notifyListeners();
  }

  addServiceEmptyTap(BuildContext context) {
    route.pushReplacementNamed(context, routeName.dashboard);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dash = Provider.of<DashboardProvider>(context, listen: false);
      dash.selectIndex = 0;
      dash.notifyListeners();
    });
  }

  onBack(BuildContext context, bool isBack) {
    if (isBack) {
      // Delay to the next frame
      /*  WidgetsBinding.instance.addPostFrameCallback((_) { */
      route.pushNamed(context, routeName.dashboard);
      /*      }); */
    }

    widget1Opacity = 0.0;
    notifyListeners();
  }
}
