import 'dart:convert';
import 'dart:developer';

import 'package:klpro_user/common_tap.dart';
import 'package:klpro_user/config.dart';
import 'package:klpro_user/users_services.dart';
import 'package:provider/provider.dart';

class SelectServicemanProvider with ChangeNotifier {
  ServicePackageModel? servicePackageModel;

  ProviderModel? providerModel;
  List<ProviderModel> providerList = [];

  List<Services> servicePackageList = [];

  bool isOpen = false;
  bool isAlert = false;

  onReady(context) {
    servicePackageList = [];

    providerList = [];

    notifyListeners();

    try {
      /// =========================
      /// DUMMY SERVICEMAN LIST
      /// =========================

      providerList = [
        ProviderModel(
          id: 1,
          name: "Rahul Sharma",
          email: "rahul@gmail.com",
          reviewRatings: 4.8,
          media: [
            Media(
              originalUrl: "https://randomuser.me/api/portraits/men/11.jpg",
            ),
          ],
        ),

        ProviderModel(
          id: 2,
          name: "Amit Verma",
          email: "amit@gmail.com",
          reviewRatings: 4.5,
          media: [
            Media(
              originalUrl: "https://randomuser.me/api/portraits/men/32.jpg",
            ),
          ],
        ),

        ProviderModel(
          id: 3,
          name: "Rohit Kumar",
          email: "rohit@gmail.com",
          reviewRatings: 4.9,
          media: [
            Media(
              originalUrl: "https://randomuser.me/api/portraits/men/45.jpg",
            ),
          ],
        ),

        ProviderModel(
          id: 4,
          name: "Vikas Singh",
          email: "vikas@gmail.com",
          reviewRatings: 4.7,
          media: [
            Media(
              originalUrl: "https://randomuser.me/api/portraits/men/55.jpg",
            ),
          ],
        ),

        ProviderModel(
          id: 5,
          name: "Ankit Raj",
          email: "ankit@gmail.com",
          reviewRatings: 4.6,
          media: [
            Media(
              originalUrl: "https://randomuser.me/api/portraits/men/66.jpg",
            ),
          ],
        ),
      ];

      log("APP_DEBUG providerList length : ${providerList.length}");

      notifyListeners();
    } catch (e, stackTrace) {
      log("APP_DEBUG onReady ERROR : $e");

      log("APP_DEBUG STACK : $stackTrace");
    }
  }

  onTapBook(
    context, {
    service,
    ProviderModel? providerModel,
    index,
    selectProviderIndex,
    providerId,
    isPackage = false,
  }) async {
    try {
      log("service:$service");

      isOpen = false;
      notifyListeners();

      Services selectServicesCart = Services(
        id: service?.id != null ? int.tryParse(service.id.toString()) : null,
        title: service?.title,
        description: service?.description,
        duration: service?.duration,
        durationUnit: service?.durationUnit,
        isFeatured: service?.isFeatured != null
            ? int.tryParse(service.isFeatured.toString())
            : null,
        media: service?.media,
        discount: service?.discount != null
            ? double.tryParse(service.discount.toString())
            : null,
        discountAmount: service?.discountAmount ?? "0",
        tax: service?.tax,
        taxes: service?.taxes != null
            ? (service.taxes as List)
                  .map(
                    (e) => Tax(
                      id: e.id != null ? int.tryParse(e.id.toString()) : null,
                      name: e.name,
                      rate: e.rate != null
                          ? double.tryParse(e.rate.toString())
                          : null,
                      amount: e.amount,
                    ),
                  )
                  .toList()
            : [],
        video: service?.video,
        faqs: service?.faqs ?? [],
        price: service?.price,
        status: service?.status != null
            ? int.tryParse(service.status.toString())
            : null,
        serviceRate: service?.serviceRate,
        userId: providerId,
        type: service?.type.toString(),
        requiredServicemen: service?.requiredServicemen != null
            ? int.tryParse(service.requiredServicemen.toString())
            : null,
        advancePaymentEnabled: service?.advancePaymentEnabled ?? false,
        advancePaymentPercentage: service?.advancePaymentPercentage,
        selectServiceManType: selectProviderIndex == 0
            ? "app_choose"
            : "as_per_my_choice",
        user: providerModel,
        selectDateTimeOption: "custom",
        selectedRequiredServiceMan: service?.requiredServicemen != null
            ? int.tryParse(service.requiredServicemen.toString())
            : 1,
        selectedAdditionalServices: service?.selectedAdditionalServices,
      );

      notifyListeners();

      log("PACKAGE: $index");

      if (selectProviderIndex == 0) {
        route
            .pushNamed(
              context,
              routeName.slotBookingScreen,
              arg: {
                "selectServicesCart": selectServicesCart,
                "isPackage": isPackage,
                "selectProviderIndex": selectProviderIndex,
              },
            )
            .then((e) {
              route.pop(context);

              if (e != null) {
                if (isPackage && index != null) {
                  Services services = e;

                  servicePackageList[index].selectServiceManType =
                      services.selectServiceManType;

                  servicePackageList[index].selectedServiceMan = null;

                  notifyListeners();
                }
              }

              notifyListeners();
            });
      } else {
        route
            .pushNamed(
              context,
              routeName.serviceSelectedUserScreen,
              arg: {
                "selectServicesCart": selectServicesCart,
                "isPackage": isPackage,
                "selectProviderIndex": selectProviderIndex,
              },
            )
            .then((e) {
              route.pop(context);

              selectProviderIndex = 0;

              notifyListeners();

              if (e != null) {
                if (isPackage && index != null) {
                  Services services = e;

                  servicePackageList[index].selectServiceManType =
                      services.selectServiceManType;

                  notifyListeners();
                }
              }
            });

        notifyListeners();
      }
    } catch (e, stackTrace) {
      log("APP_DEBUG onTapBook ERROR : $e");
      log("APP_DEBUG STACK : $stackTrace");
    }
  }

  onRemoveService(context, index) async {
    try {
      int selectedCount =
          servicePackageList[index].selectedRequiredServiceMan ?? 0;

      int requiredCount = servicePackageList[index].requiredServicemen ?? 0;

      if (selectedCount == 1) {
        route.pop(context);

        isAlert = false;

        notifyListeners();
      } else {
        if (requiredCount == selectedCount) {
          isAlert = true;

          notifyListeners();

          await Future.delayed(DurationClass.s3);

          isAlert = false;

          notifyListeners();
        } else {
          isAlert = false;

          notifyListeners();

          servicePackageList[index].selectedRequiredServiceMan =
              selectedCount - 1;
        }
      }

      notifyListeners();
    } catch (e) {
      log("APP_DEBUG onRemoveService ERROR : $e");
    }
  }

  onAdd(index) {
    try {
      isAlert = false;

      notifyListeners();

      int count = servicePackageList[index].selectedRequiredServiceMan ?? 0;

      count++;

      servicePackageList[index].selectedRequiredServiceMan = count;

      notifyListeners();
    } catch (e) {
      log("APP_DEBUG onAdd ERROR : $e");
    }
  }

  bool buttonVisible(context) {
    int count = 0;

    servicePackageList.asMap().entries.forEach((element) {
      if (element.value.serviceDate != null) {
        count++;
      }
    });

    return count == servicePackageList.length;
  }

  onBack() async {
    try {
      servicePackageList.asMap().entries.forEach((element) {
        element.value.selectedRequiredServiceMan =
            element.value.requiredServicemen;

        element.value.serviceDate = null;

        element.value.selectedDateTimeFormat = null;

        element.value.selectedServiceMan = null;

        element.value.selectDateTimeOption = null;

        element.value.selectServiceManType = null;
      });

      notifyListeners();
    } catch (e) {
      log("APP_DEBUG onBack ERROR : $e");
    }
  }

  addToCart(context) async {
    try {
      final cartCtrl = Provider.of<CartProvider>(context, listen: false);

      if (servicePackageModel == null) {
        log("APP_DEBUG ERROR : servicePackageModel is null");
        return;
      }

      servicePackageModel!.services = servicePackageList;

      notifyListeners();

      int index = cartCtrl.cartList.indexWhere(
        (element) =>
            element.isPackage == true &&
            element.servicePackageList != null &&
            element.servicePackageList!.id == servicePackageModel!.id,
      );

      log("index :$index");

      if (index < 0) {
        CartModel cartModel = CartModel(
          isPackage: true,
          servicePackageList: servicePackageModel,
        );

        cartCtrl.cartList.add(cartModel);

        cartCtrl.notifyListeners();
      }

      log("CART: ${cartCtrl.cartList.map((e) => e.toString()).toList()}");

      cartCtrl.notifyListeners();

      if (cartCtrl.isEditing) {
        CartModel updatedCartItem = CartModel(
          isPackage: true,
          servicePackageList: servicePackageModel,
        );

        await cartCtrl.updateCartItemApi(context, updatedCartItem);
      } else {
        cartCtrl.syncCartWithApi(context);

        cartCtrl.checkout(context);

        route.pushNamed(context, routeName.cartScreen);
      }
    } catch (e, stackTrace) {
      log("APP_DEBUG addToCart ERROR : $e");
      log("APP_DEBUG STACK : $stackTrace");
    }
  }
}
