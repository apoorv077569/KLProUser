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
    debugPrint("APPU_DEBUG CART API DISABLED");

    isLoading = false;

    notifyListeners();
  }

  syncCartWithApi(context) async {
    debugPrint("APPU_DEBUG syncCartWithApi DISABLED");
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
        return AddOnServiceCart(data: data);
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
    debugPrint("APPU_DEBUG CHECKOUT DISABLED");

    isLoading = false;

    notifyListeners();
  }

  editCart(CartModel cart, context, index) async {
    if (cart.isPackage!) {
      isEditing = true;
      editingItemId = cart.id;
      notifyListeners();

      route.pushNamed(
        context,
        routeName.selectServiceScreen,
        arg: {
          "services": cart.servicePackageList!,
          "id": cart.servicePackageList!.id,
        },
      );
    } else {
      log("afjdiojfdisfjdiksfjdsmessage");
      final providerDetail = Provider.of<ProviderDetailsProvider>(
        context,
        listen: false,
      );
      providerDetail.selectProviderIndex = 0;
      providerDetail.notifyListeners();

      isEditing = true;
      editingItemId = cart.id;
      notifyListeners();

      onBook(
        context,
        cart.serviceList!,
        addTap: () => onAdd(context, index),
        minusTap: () => onRemoveService(context, index),
      );
    }
  }

  updateCartItemApi(context, CartModel updatedCartItem) async {
    debugPrint("APPU_DEBUG updateCartItemApi DISABLED");
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
    debugPrint("APPU_DEBUG DELETE CART LOCAL");

    cartList.removeAt(index);

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
        return StatefulBuilder(
          builder: (context2, setState) {
            return Consumer<CartProvider>(
              builder: (context3, value, child) {
                return AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: Insets.i20,
                  ),
                  shape: const SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.all(
                      SmoothRadius(
                        cornerRadius: AppRadius.r14,
                        cornerSmoothing: 1,
                      ),
                    ),
                  ),
                  backgroundColor: appColor(context).whiteBg,
                  content: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Gif
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Stack(
                                alignment: Alignment.topCenter,
                                children: [
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
                                              milliseconds: 200,
                                            ),
                                            curve: isPositionedRight
                                                ? Curves.bounceIn
                                                : Curves.bounceOut,
                                            alignment: isPositionedRight
                                                ? Alignment.center
                                                : Alignment.topCenter,
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              height: 40,
                                              child: Image.asset(
                                                eImageAssets.cartTrash,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                          eImageAssets.dustbin,
                                          height: Sizes.s88,
                                          width: Sizes.s88,
                                        ).paddingOnly(bottom: Insets.i24),
                                      ],
                                    ),
                                  ).decorated(
                                    color: appColor(context).fieldCardBg,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.r10,
                                    ),
                                  ),
                                ],
                              ),
                              if (offsetAnimation != null)
                                SlideTransition(
                                  position: offsetAnimation!,
                                  child:
                                      (offsetAnimation != null &&
                                          isAnimateOver == true)
                                      ? Image.asset(
                                          eImageAssets.dustbinCover,
                                          height: 38,
                                        )
                                      : const SizedBox(),
                                ),
                            ],
                          ),
                          // Sub text
                          const VSpace(Sizes.s15),
                          Text(
                            language(
                              context,
                              translations!.deleteCartSuccessfully,
                            ),
                            textAlign: TextAlign.center,
                            style: appCss.dmDenseRegular14
                                .textColor(appColor(context).lightText)
                                .textHeight(1.2),
                          ),
                          const VSpace(Sizes.s20),
                          Row(
                            children: [
                              Expanded(
                                child: ButtonCommon(
                                  onTap: () => route.pop(context),
                                  title: translations!.no!,
                                  borderColor: appColor(context).primary,
                                  color: appColor(context).whiteBg,
                                  style: appCss.dmDenseSemiBold16.textColor(
                                    appColor(context).primary,
                                  ),
                                ),
                              ),
                              const HSpace(Sizes.s15),
                              Expanded(
                                child: ButtonCommon(
                                  color: appColor(context).primary,
                                  fontColor: appColor(context).whiteColor,
                                  onTap: () => deleteCart(context, id),
                                  title: translations!.yes!,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ).padding(top: Insets.i40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          Text(
                            language(context, translations!.successfullyDelete),
                            style: appCss.dmDenseExtraBold18.textColor(
                              appColor(context).darkText,
                            ),
                          ),
                          Icon(
                            CupertinoIcons.multiply,
                            size: Sizes.s20,
                            color: appColor(context).darkText,
                          ).inkWell(onTap: () => route.pop(context)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    ).then((value) {
      isPositionedRight = false;
      isAnimateOver = false;
      notifyListeners();
    });
  }

onPaymentTap(context) {

  debugPrint(
    "APPU_DEBUG PAYMENT DISABLED",
  );

  route.pushNamed(
    context,
    routeName.providerDetailsScreen,
  );
}

  proceedToBook(context) async {
    debugPrint("APPU_DEBUG BOOKING API DISABLED");
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
    Future.delayed(DurationClass.ms500)
        .then((value) {
          isPositionedRight = true;
          notifyListeners();
        })
        .then((value) {
          Future.delayed(DurationClass.ms150)
              .then((value) {
                isAnimateOver = true;
                notifyListeners();
              })
              .then((value) {
                controller = AnimationController(
                  vsync: sync,
                  duration: const Duration(seconds: 2),
                )..forward();
                offsetAnimation =
                    Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: const Offset(0, 1),
                    ).animate(
                      CurvedAnimation(
                        parent: controller!,
                        curve: Curves.elasticOut,
                      ),
                    );
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
